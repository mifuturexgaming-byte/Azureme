@echo off
setlocal
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0Deploy-Azure.ps1"
pause
