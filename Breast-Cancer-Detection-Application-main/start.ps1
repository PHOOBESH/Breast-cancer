Write-Host "Starting Breast Cancer Detection Application..." -ForegroundColor Green

# Check if Docker is installed
try {
    docker --version | Out-Null
}
catch {
    Write-Host "Error: Docker is not installed or not in PATH." -ForegroundColor Red
    Write-Host "Please install Docker Desktop from https://www.docker.com/products/docker-desktop" -ForegroundColor Yellow
    exit 1
}

# Check if Docker Compose is installed
try {
    docker-compose --version | Out-Null
}
catch {
    Write-Host "Error: Docker Compose is not installed or not in PATH." -ForegroundColor Red
    Write-Host "Docker Compose is included with Docker Desktop for Windows." -ForegroundColor Yellow
    exit 1
}

Write-Host "Building and starting containers..." -ForegroundColor Cyan
docker-compose up -d

if ($LASTEXITCODE -ne 0) {
    Write-Host "Error: Failed to start containers." -ForegroundColor Red
    Write-Host "Please check the error messages above." -ForegroundColor Yellow
    exit 1
}

Write-Host "`nApplication started successfully!" -ForegroundColor Green
Write-Host "`nFrontend: http://localhost:8080" -ForegroundColor Cyan
Write-Host "Backend API: http://localhost:5002" -ForegroundColor Cyan

Write-Host "`nPress Enter to view logs, or Ctrl+C to exit..." -ForegroundColor Yellow
Read-Host | Out-Null

Write-Host "`nShowing logs (press Ctrl+C to exit)..." -ForegroundColor Cyan
docker-compose logs -f
