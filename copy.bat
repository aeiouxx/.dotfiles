@echo off

REM Set the source directory (adjust this to your dotfiles location)
set SOURCE_DIR=%~dp0.config

REM Set the target directory
set TARGET_DIR=%USERPROFILE%\.config

REM Ensure the target directory exists
if not exist "%TARGET_DIR%" (
    echo Creating target directory: %TARGET_DIR%
    mkdir "%TARGET_DIR%"
)

REM Sync files from source to target, excluding .git
echo Copying files from %SOURCE_DIR% to %TARGET_DIR%, excluding .git ...
robocopy "%SOURCE_DIR%" "%TARGET_DIR%" /E /Z /XA:H /XD .git /R:1 /W:1

REM Confirmation
echo Sync complete.
pause

