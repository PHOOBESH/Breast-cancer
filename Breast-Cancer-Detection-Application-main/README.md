# Breast Cancer Detection Application

This application uses machine learning to detect breast cancer from uploaded images. It consists of a React frontend and a Flask backend with a TensorFlow model.

## Quick Start

1. Make sure Docker Desktop is installed and running
2. Double-click on `run-app.bat`
3. Open your browser and go to http://localhost:8080

## Features

- Upload medical images for breast cancer detection
- Get instant prediction results (Cancerous/Non-Cancerous)
- Responsive web interface
- Containerized application for easy deployment
- CI/CD pipeline for automated testing and deployment

## System Requirements

- Docker and Docker Compose
- 2GB RAM minimum (4GB recommended)
- 5GB free disk space

## Stopping the Application

Run the `stop-app.bat` script

## CI/CD Pipeline

This project includes a complete CI/CD pipeline implemented with GitHub Actions:

- **Automated Testing**: Runs tests for both frontend and backend components
- **Docker Image Building**: Builds and pushes Docker images to Docker Hub
- **Automated Deployment**: Deploys to staging automatically, with manual approval for production
- **Environment Management**: Supports both staging and production environments

For more details, see the [CI/CD documentation](CI_CD_README.md).

## Troubleshooting

- **Frontend can't connect to backend**: Make sure both containers are running with `docker-compose ps`
- **Image upload fails**: Check backend logs with `docker-compose logs backend`
- **Container won't start**: Ensure Docker has enough resources allocated
- **CI/CD pipeline fails**: Check GitHub Actions logs for detailed error messages

## Architecture

- **Frontend**: React application served by Nginx
- **Backend**: Flask API with TensorFlow for prediction
- **Containerization**: Docker with docker-compose for orchestration
- **CI/CD**: GitHub Actions workflow for continuous integration and deployment
