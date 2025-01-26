@echo off
REM Check if XDG_CONFIG_HOME is set
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

set SOURCE_XDG_CONFIG_HOME=%~dp0XDG_CONFIG_HOME
set SOURCE_USERPROFILE=%~dp0windows\USERPROFILE

if not exist "%XDG_CONFIG_HOME%" (
    mkdir "%XDG_CONFIG_HOME%"
)

echo Syncing XDG_CONFIG_HOME: %XDG_CONFIG_HOME%
robocopy "%SOURCE_XDG_CONFIG_HOME%" "%XDG_CONFIG_HOME%" /E /Z /R:1 /W:1

echo Windows specific:
echo Syncing USERPROFILE: %USERPROFILE%
robocopy "%SOURCE_USERPROFILE%" "%USERPROFILE%" /E /Z /R:1 /W:1

REM Final confirmation
echo ===============================================
echo All configurations synced successfully.
echo ===============================================
pause

