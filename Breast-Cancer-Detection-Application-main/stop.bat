@echo off
echo Stopping Breast Cancer Detection Application...
echo.

powershell -ExecutionPolicy Bypass -File "%~dp0stop.ps1"
