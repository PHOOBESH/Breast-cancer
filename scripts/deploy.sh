#!/bin/bash
# Deployment script for Breast Cancer Detection Application

set -e  # Exit immediately if a command exits with a non-zero status

# Configuration
APP_DIR="/opt/breast-cancer-app"
DOCKER_COMPOSE_FILE="$APP_DIR/docker-compose.yml"
BACKUP_DIR="$APP_DIR/backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Function to log messages
log() {
  echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

# Backup current configuration
backup() {
  log "Creating backup of current configuration..."
  if [ -f "$DOCKER_COMPOSE_FILE" ]; then
    cp "$DOCKER_COMPOSE_FILE" "$BACKUP_DIR/docker-compose_$TIMESTAMP.yml"
    log "Backup created at $BACKUP_DIR/docker-compose_$TIMESTAMP.yml"
  else
    log "No docker-compose.yml found to backup"
  fi
}

# Pull latest images
pull_images() {
  log "Pulling latest Docker images..."
  cd "$APP_DIR"
  docker-compose pull
  log "Images pulled successfully"
}

# Deploy the application
deploy() {
  log "Deploying the application..."
  cd "$APP_DIR"
  docker-compose up -d
  log "Application deployed successfully"
}

# Clean up old resources
cleanup() {
  log "Cleaning up old resources..."
  docker system prune -f
  
  # Keep only the 5 most recent backups
  cd "$BACKUP_DIR"
  ls -t | tail -n +6 | xargs -r rm
  log "Cleanup completed"
}

# Check deployment status
check_status() {
  log "Checking deployment status..."
  docker-compose ps
  
  # Check if containers are running
  if docker-compose ps | grep -q "Up"; then
    log "Deployment successful: Containers are running"
    return 0
  else
    log "Deployment failed: Containers are not running"
    return 1
  fi
}

# Main execution
main() {
  log "Starting deployment process..."
  
  backup
  pull_images
  deploy
  cleanup
  check_status
  
  log "Deployment process completed"
}

# Run the main function
main
