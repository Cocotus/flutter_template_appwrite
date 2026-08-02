@echo off
echo Installing app...
if not exist "%LOCALAPPDATA%\app" mkdir "%LOCALAPPDATA%\app"
xcopy /E /I /Y * "%LOCALAPPDATA%\app\"
echo Done! Run %LOCALAPPDATA%\app\app.exe to launch.
