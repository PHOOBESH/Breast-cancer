# Makefile for Breast Cancer Detection Application

# Variables
DOCKER_USERNAME ?= your-dockerhub-username
TAG ?= latest
ENV ?= staging

# Docker image names
BACKEND_IMAGE = $(DOCKER_USERNAME)/breast-cancer-backend:$(TAG)
FRONTEND_IMAGE = $(DOCKER_USERNAME)/breast-cancer-frontend:$(TAG)

# Default target
.PHONY: all
all: build

# Build Docker images
.PHONY: build
build:
	@echo "Building Docker images..."
	docker build -t $(BACKEND_IMAGE) ./BACKEND
	docker build -t $(FRONTEND_IMAGE) ./my-app
	@echo "Docker images built successfully."

# Push Docker images to registry
.PHONY: push
push: build
	@echo "Pushing Docker images to registry..."
	docker push $(BACKEND_IMAGE)
	docker push $(FRONTEND_IMAGE)
	@echo "Docker images pushed successfully."

# Run the application locally
.PHONY: run
run:
	@echo "Starting the application locally..."
	docker-compose up -d
	@echo "Application started. Frontend: http://localhost:8080, Backend: http://localhost:5002"

# Stop the application
.PHONY: stop
stop:
	@echo "Stopping the application..."
	docker-compose down
	@echo "Application stopped."

# Run backend tests
.PHONY: test-backend
test-backend:
	@echo "Running backend tests..."
	cd BACKEND && python -m pytest -v tests/
	@echo "Backend tests completed."

# Run frontend tests
.PHONY: test-frontend
test-frontend:
	@echo "Running frontend tests..."
	cd my-app && npm test -- --watchAll=false
	@echo "Frontend tests completed."

# Run all tests
.PHONY: test
test: test-backend test-frontend
	@echo "All tests completed."

# Deploy to environment (staging or production)
.PHONY: deploy
deploy:
	@echo "Deploying to $(ENV) environment..."
	@if [ "$(ENV)" = "production" ]; then \
		echo "WARNING: Deploying to production environment!"; \
		read -p "Are you sure? (y/n): " confirm && [ $$confirm = "y" ] || exit 1; \
	fi
	docker-compose -f docker-compose.prod.yml --env-file .env.$(ENV) up -d
	@echo "Deployed to $(ENV) environment."

# Clean up Docker resources
.PHONY: clean
clean:
	@echo "Cleaning up Docker resources..."
	docker-compose down --rmi local
	docker system prune -f
	@echo "Cleanup completed."

# Setup CI/CD pipeline
.PHONY: setup-cicd
setup-cicd:
	@echo "Setting up CI/CD pipeline..."
	bash scripts/setup-cicd.sh
	@echo "CI/CD pipeline setup completed."

# Help
.PHONY: help
help:
	@echo "Breast Cancer Detection Application Makefile"
	@echo ""
	@echo "Usage:"
	@echo "  make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  build         Build Docker images"
	@echo "  push          Push Docker images to registry"
	@echo "  run           Run the application locally"
	@echo "  stop          Stop the application"
	@echo "  test-backend  Run backend tests"
	@echo "  test-frontend Run frontend tests"
	@echo "  test          Run all tests"
	@echo "  deploy        Deploy to environment (ENV=staging|production)"
	@echo "  clean         Clean up Docker resources"
	@echo "  setup-cicd    Setup CI/CD pipeline"
	@echo "  help          Show this help message"
	@echo ""
	@echo "Variables:"
	@echo "  DOCKER_USERNAME  Docker Hub username (default: your-dockerhub-username)"
	@echo "  TAG             Docker image tag (default: latest)"
	@echo "  ENV             Deployment environment (default: staging)"
