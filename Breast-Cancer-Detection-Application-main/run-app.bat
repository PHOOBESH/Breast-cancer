@echo off
echo Starting Breast Cancer Detection Application...
echo.

docker-compose up -d

if %errorlevel% neq 0 (
    echo.
    echo Error: Failed to start containers.
    echo Please check the error messages above.
    pause
    exit /b 1
)

echo.
echo Application started successfully!
echo.
echo Frontend: http://localhost:8080
echo Backend API: http://localhost:5002
echo.
echo Press any key to exit...
pause > nul
