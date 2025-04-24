@echo off
echo Stopping Breast Cancer Detection Application...
echo.

docker-compose down

if %errorlevel% neq 0 (
    echo.
    echo Error: Failed to stop containers.
    echo Please check the error messages above.
    pause
    exit /b 1
)

echo.
echo Application stopped successfully!
echo.
echo Press any key to exit...
pause > nul
