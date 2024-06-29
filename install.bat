@echo off
setlocal

:: Introductory section
echo The super cool mod installation script by WG
echo ====================================================
echo This script will perform the following actions:
echo 1. Check if Java is installed on your system.
echo 2. Install Minecraft Forge if it is not already installed.
echo 3. Copy mods from the source directory to the Minecraft mods directory.
echo ====================================================
echo Disclaimer: I am not responsible for any issues or damages
echo this script may cause. Use it at your own risk.
echo ====================================================
echo.

:: Ask user for confirmation to proceed
set /p "UserInput=Do you want to proceed with the above actions? (Y/N): "
if /i "%UserInput%" neq "Y" (
    echo ====================================================
    echo Bruh you don't trust me do you. Moderators invert their balls!!!!
    pause
    exit /b
)

:: Variables
set "FORGE_INSTALLER=installers\forge-1.20.1-47.3.0-installer.jar"
set "MINECRAFT_DIR=%APPDATA%\.minecraft"
set "MODS_SOURCE_DIR=.\mods"  :: Change this to the path of your mods folder
set "MODS_DEST_DIR=%MINECRAFT_DIR%\mods"

:: Function to check if Java is installed
:CheckJavaInstalled
java -version >nul 2>&1
if %errorlevel% neq 0 (
    echo Java is not installed. Please locate the Java installer in the "Installers" Folder.
    pause
    exit /b
) else (
    echo ====================================================
    echo Java is already installed.
)


:: Check if Forge is already installed
if not exist "%MINECRAFT_DIR%\libraries\net\minecraftforge\forge" (
    :: Check if Forge installer exists
    if not exist "%FORGE_INSTALLER%" (
        echo Forge installer not found. Please place 'forge-1.20.1-47.3.0-installer.jar' in the 'installers' folder.
        pause
        exit /b
    )

    :: Install Forge
    echo Installing Forge...
    java -jar "%FORGE_INSTALLER%" --installClient "%MINECRAFT_DIR%"
    if %errorlevel% neq 0 (
        echo Forge installation failed. Please check the Forge installer and or Install it manually.
        pause
        exit /b
    )
) else (
    echo ====================================================
    echo Forge is already installed.
    echo ====================================================
)

:: Prompt user before copying mods folder

set /p "UserInput=Do you want to proceed with copying the mods folder? (Y/N): "
if /i "%UserInput%" neq "Y" (
    echo Operation cancelled by user.
    pause
    exit /b
)

:: Copy mods folder
echo ====================================================
echo Copying mods folder...
if not exist "%MODS_DEST_DIR%" (
    mkdir "%MODS_DEST_DIR%"
)

:: Loop through files in mods source directory
for %%I in ("%MODS_SOURCE_DIR%\*") do (
    :: Check if the file already exists in destination
    if exist "%MODS_DEST_DIR%\%%~nxI" (
        echo File '%%~nxI' already exists in mods directory.
    ) else (
        :: Copy the file if it doesn't exist
        copy /Y "%%I" "%MODS_DEST_DIR%\"
    )
)

echo ====================================================
echo CONGRATS THE INSTALL WAS SUCCESSFUL!!!! 
echo (c) WG 2024
echo ====================================================
pause
endlocal
