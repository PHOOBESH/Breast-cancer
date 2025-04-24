# CI/CD Pipeline for Breast Cancer Detection Application

This document describes the Continuous Integration and Continuous Deployment (CI/CD) pipeline set up for the Breast Cancer Detection Application.

## Overview

The CI/CD pipeline automates the testing, building, and deployment of the application. It is implemented using GitHub Actions and consists of the following stages:

1. **Test**: Run automated tests for both frontend and backend
2. **Build**: Build Docker images for frontend and backend
3. **Deploy to Staging**: Deploy the application to the staging environment
4. **Deploy to Production**: Deploy the application to the production environment (manual trigger)

## Pipeline Configuration

The pipeline is configured in the `.github/workflows/ci-cd.yml` file. It is triggered on:

- Push to main/master branch
- Pull requests to main/master branch
- Manual trigger (workflow_dispatch) with environment selection

## Required Secrets

The following secrets need to be configured in your GitHub repository:

### Docker Hub
- `DOCKERHUB_USERNAME`: Your Docker Hub username
- `DOCKERHUB_TOKEN`: Your Docker Hub access token

### Staging Environment
- `STAGING_HOST`: Hostname or IP address of the staging server
- `STAGING_USERNAME`: SSH username for the staging server
- `STAGING_SSH_KEY`: SSH private key for the staging server

### Production Environment
- `PRODUCTION_HOST`: Hostname or IP address of the production server
- `PRODUCTION_USERNAME`: SSH username for the production server
- `PRODUCTION_SSH_KEY`: SSH private key for the production server

## Deployment Process

The deployment process uses SSH to connect to the target server and run the necessary commands to update and restart the application. The deployment script performs the following steps:

1. Pull the latest Docker images
2. Start or restart the containers using Docker Compose
3. Clean up unused Docker resources

## Manual Deployment

To manually trigger a deployment:

1. Go to the "Actions" tab in your GitHub repository
2. Select the "CI/CD Pipeline" workflow
3. Click "Run workflow"
4. Select the target environment (staging or production)
5. Click "Run workflow"

## Testing

The pipeline includes automated tests for both the frontend and backend:

- **Backend Tests**: Uses pytest to run tests in the `BACKEND/tests` directory
- **Frontend Tests**: Uses Jest to run React component tests

## Monitoring

After deployment, you can monitor the application by:

1. Checking the container status: `docker-compose ps`
2. Viewing container logs: `docker-compose logs -f`
3. Accessing the application at:
   - Frontend: http://your-server:8080
   - Backend API: http://your-server:5002

## Troubleshooting

If the deployment fails, check:

1. GitHub Actions logs for error messages
2. Server logs: `docker-compose logs`
3. Container status: `docker-compose ps`

## Rollback Procedure

To rollback to a previous version:

1. SSH into the server
2. Navigate to the application directory: `cd /opt/breast-cancer-app`
3. Pull the specific version: `TAG=previous-version docker-compose -f docker-compose.prod.yml up -d`
