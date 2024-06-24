@echo off
setlocal

:: Variables
set "FORGE_INSTALLER=installers\forge-1.20.1-47.3.0-installer.jar"
set "MINECRAFT_DIR=%APPDATA%\.minecraft"
set "MODS_SOURCE_DIR=.\mods"  :: Change this to the path of your mods folder
set "MODS_DEST_DIR=%MINECRAFT_DIR%\mods"
set "JAVA_INSTALLER=jdk-22_windows-x64_bin.exe"  :: Latest Java installer as of writing
set "JAVA_URL=https://download.oracle.com/java/22/latest/%JAVA_INSTALLER%"

:: Function to check if Java is installed
:CheckJavaInstalled
java -version >nul 2>&1
if %errorlevel% neq 0 (
    echo Java is not installed. Downloading Java...
    if not exist "%JAVA_INSTALLER%" (
        echo Downloading Java installer...
        powershell -Command "(New-Object System.Net.WebClient).DownloadFile('%JAVA_URL%', '%JAVA_INSTALLER%')"
        if %errorlevel% neq 0 (
            echo Failed to download Java installer. Please check the URL manually.
            pause
            exit /b
        )
    )

    :: Prompt user to install Java
    echo.
    echo Please install Java by running '%JAVA_INSTALLER%'.
    echo Once installed, press any key to continue...
    pause

    :: Check if Java is installed after manual installation
    goto :CheckJavaInstalled
) else (
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
    java -jar "%FORGE_INSTALLER%" --installServer "%MINECRAFT_DIR%"
    if %errorlevel% neq 0 (
        echo Forge installation failed. Please check the Forge installer.
        pause
        exit /b
    )
) else (
    echo Forge is already installed.
)

:: Copy mods folder
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

echo Script completed successfully.
pause
endlocal
