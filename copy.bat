@echo off
REM Check if XDG_CONFIG_HOME is set, optionally set it
if "%XDG_CONFIG_HOME%"=="" (
    echo ===============================================
    echo WARNING: The XDG_CONFIG_HOME environment variable is not set.
    echo This variable defines the base directory relative to which 
    echo user-specific configuration files should be stored.
    echo Would you like to set it to %USERPROFILE%\.config?
    echo ===============================================
    
    choice /c YN /n /m "Enter your choice (Y = Yes, N = No): "
    if errorlevel 2 (
        echo You chose not to set the XDG_CONFIG_HOME variable.
        echo The script cannot continue without this setting.
        echo Exiting the script...
        pause
        exit /b 1
    ) else (
        echo Setting XDG_CONFIG_HOME to %USERPROFILE%\.config...
        setx XDG_CONFIG_HOME "%USERPROFILE%\.config" >nul
        set XDG_CONFIG_HOME=%USERPROFILE%\.config
        echo XDG_CONFIG_HOME has been set successfully.
    )
)

REM Set the source directory (adjust this to your dotfiles location)
set SOURCE_DIR=%~dp0.config

REM Set the target directory
set TARGET_DIR=%USERPROFILE%\.config

REM Ensure the target directory exists
if not exist "%TARGET_DIR%" (
    mkdir "%TARGET_DIR%"
)

REM Sync files from source to target, excluding .git
robocopy "%SOURCE_DIR%" "%TARGET_DIR%" /E /Z /XA:H /XD .git /R:1 /W:1

REM Confirmation
echo Sync complete.
pause

