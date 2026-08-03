@echo off
rem Installs the Windows release bundle for the current user (no admin
rem needed): copies it to %LOCALAPPDATA% and creates a Start Menu shortcut
rem with a proper display name -- without the shortcut, Explorer has nothing
rem to pin/show at all, and any shortcut a user creates manually falls back
rem to the exe's own filename instead of a human-readable name.
rem
rem Rename the placeholders below when you fork this template:
rem   - app_id:   must match windows/CMakeLists.txt's BINARY_NAME (the
rem               compiled executable's filename, without ".exe").
rem   - app_name: the human-readable name shown in the Start Menu.
setlocal
set app_id=flutter_template_appwrite
set app_name=Flutter Appwrite Template

echo Installing %app_name%...
if not exist "%LOCALAPPDATA%\%app_id%" mkdir "%LOCALAPPDATA%\%app_id%"
xcopy /E /I /Y * "%LOCALAPPDATA%\%app_id%\"

powershell -NoProfile -Command ^
  "$ws = New-Object -ComObject WScript.Shell;" ^
  "$dir = Join-Path $env:APPDATA 'Microsoft\Windows\Start Menu\Programs';" ^
  "$sc = $ws.CreateShortcut((Join-Path $dir '%app_name%.lnk'));" ^
  "$sc.TargetPath = Join-Path $env:LOCALAPPDATA '%app_id%\%app_id%.exe';" ^
  "$sc.WorkingDirectory = Join-Path $env:LOCALAPPDATA '%app_id%';" ^
  "$sc.IconLocation = (Join-Path $env:LOCALAPPDATA '%app_id%\%app_id%.exe') + ',0';" ^
  "$sc.Save()"

echo Done! Launch %app_name% from the Start Menu, or run: %LOCALAPPDATA%\%app_id%\%app_id%.exe
pause
