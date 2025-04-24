Write-Host "Stopping Breast Cancer Detection Application..." -ForegroundColor Green

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

Write-Host "Stopping containers..." -ForegroundColor Cyan
docker-compose down

if ($LASTEXITCODE -ne 0) {
    Write-Host "Error: Failed to stop containers." -ForegroundColor Red
    Write-Host "Please check the error messages above." -ForegroundColor Yellow
    exit 1
}

Write-Host "`nApplication stopped successfully!" -ForegroundColor Green
Write-Host "`nPress Enter to exit..." -ForegroundColor Yellow
Read-Host | Out-Null
