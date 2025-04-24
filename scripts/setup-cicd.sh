#!/bin/bash
# Script to set up CI/CD pipeline for Breast Cancer Detection Application

set -e  # Exit immediately if a command exits with a non-zero status

# Configuration
GITHUB_REPO="your-github-username/breast-cancer-detection"
DOCKERHUB_USERNAME="your-dockerhub-username"

# Function to log messages
log() {
  echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

# Check if GitHub CLI is installed
check_gh_cli() {
  log "Checking if GitHub CLI is installed..."
  if ! command -v gh &> /dev/null; then
    log "GitHub CLI is not installed. Please install it from https://cli.github.com/"
    exit 1
  fi
  log "GitHub CLI is installed."
}

# Check if Docker is installed
check_docker() {
  log "Checking if Docker is installed..."
  if ! command -v docker &> /dev/null; then
    log "Docker is not installed. Please install it from https://docs.docker.com/get-docker/"
    exit 1
  fi
  log "Docker is installed."
}

# Check if user is logged in to GitHub
check_github_login() {
  log "Checking GitHub login status..."
  if ! gh auth status &> /dev/null; then
    log "You are not logged in to GitHub. Please run 'gh auth login' first."
    exit 1
  fi
  log "You are logged in to GitHub."
}

# Check if user is logged in to Docker Hub
check_dockerhub_login() {
  log "Checking Docker Hub login status..."
  if ! docker info | grep -q "Username: $DOCKERHUB_USERNAME"; then
    log "You are not logged in to Docker Hub as $DOCKERHUB_USERNAME. Please run 'docker login' first."
    exit 1
  fi
  log "You are logged in to Docker Hub as $DOCKERHUB_USERNAME."
}

# Set up GitHub repository secrets
setup_github_secrets() {
  log "Setting up GitHub repository secrets..."
  
  # Create a Docker Hub access token if needed
  log "Please create a Docker Hub access token at https://hub.docker.com/settings/security if you haven't already."
  read -p "Enter your Docker Hub access token: " DOCKERHUB_TOKEN
  
  # Set up GitHub secrets
  gh secret set DOCKERHUB_USERNAME -b"$DOCKERHUB_USERNAME" -R "$GITHUB_REPO"
  gh secret set DOCKERHUB_TOKEN -b"$DOCKERHUB_TOKEN" -R "$GITHUB_REPO"
  
  # Set up staging environment secrets
  read -p "Enter staging server hostname or IP: " STAGING_HOST
  read -p "Enter staging server username: " STAGING_USERNAME
  read -p "Enter path to SSH private key for staging server: " STAGING_SSH_KEY_PATH
  
  gh secret set STAGING_HOST -b"$STAGING_HOST" -R "$GITHUB_REPO" --env staging
  gh secret set STAGING_USERNAME -b"$STAGING_USERNAME" -R "$GITHUB_REPO" --env staging
  gh secret set STAGING_SSH_KEY -f"$STAGING_SSH_KEY_PATH" -R "$GITHUB_REPO" --env staging
  
  # Set up production environment secrets
  read -p "Enter production server hostname or IP: " PRODUCTION_HOST
  read -p "Enter production server username: " PRODUCTION_USERNAME
  read -p "Enter path to SSH private key for production server: " PRODUCTION_SSH_KEY_PATH
  
  gh secret set PRODUCTION_HOST -b"$PRODUCTION_HOST" -R "$GITHUB_REPO" --env production
  gh secret set PRODUCTION_USERNAME -b"$PRODUCTION_USERNAME" -R "$GITHUB_REPO" --env production
  gh secret set PRODUCTION_SSH_KEY -f"$PRODUCTION_SSH_KEY_PATH" -R "$GITHUB_REPO" --env production
  
  log "GitHub secrets set up successfully."
}

# Create GitHub environments
create_github_environments() {
  log "Creating GitHub environments..."
  
  # Create staging environment
  gh api repos/$GITHUB_REPO/environments/staging --method PUT -f wait_timer=0 -f reviewers=[]
  
  # Create production environment with required reviewers
  read -p "Enter GitHub username for production deployment approver: " APPROVER_USERNAME
  APPROVER_ID=$(gh api users/$APPROVER_USERNAME --jq .id)
  
  gh api repos/$GITHUB_REPO/environments/production --method PUT -f wait_timer=0 -f reviewers="[{\"type\":\"User\",\"id\":$APPROVER_ID}]"
  
  log "GitHub environments created successfully."
}

# Prepare servers for deployment
prepare_servers() {
  log "Preparing servers for deployment..."
  
  log "Please make sure the following is set up on your servers:"
  echo "1. Docker and Docker Compose are installed"
  echo "2. The deployment user has permissions to run Docker commands"
  echo "3. The deployment directory exists and is writable"
  echo "4. SSH keys are properly configured for passwordless login"
  
  read -p "Have you completed these steps? (y/n): " SERVERS_READY
  if [[ $SERVERS_READY != "y" ]]; then
    log "Please complete the server setup before continuing."
    exit 1
  fi
  
  log "Servers are ready for deployment."
}

# Main execution
main() {
  log "Starting CI/CD pipeline setup..."
  
  check_gh_cli
  check_docker
  check_github_login
  check_dockerhub_login
  setup_github_secrets
  create_github_environments
  prepare_servers
  
  log "CI/CD pipeline setup completed successfully."
  log "You can now push your code to GitHub to trigger the CI/CD pipeline."
}

# Run the main function
main
