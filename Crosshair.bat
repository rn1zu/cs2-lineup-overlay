@echo off
title Crosshair Overlay Toggle

tasklist /FI "IMAGENAME eq AutoHotkey64.exe" 2>NUL | find /I "AutoHotkey64.exe" >NUL
if "%ERRORLEVEL%"=="0" goto kill
tasklist /FI "IMAGENAME eq AutoHotkey32.exe" 2>NUL | find /I "AutoHotkey32.exe" >NUL
if "%ERRORLEVEL%"=="0" goto kill
goto start

:kill
taskkill /IM AutoHotkey64.exe /F >NUL 2>&1
taskkill /IM AutoHotkey32.exe /F >NUL 2>&1
echo Overlay OFF
timeout /t 1 >NUL
exit

:start
start "" "%~dp0lineup_overlay.ahk"
echo Overlay ON
timeout /t 1 >NUL