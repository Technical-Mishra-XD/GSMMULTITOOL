
@echo off
setlocal EnableExtensions
title ADB + Fastboot All-in-One Repair Tool
color 0B

set "INSTALL_DIR=C:\Android\platform-tools"
set "ZIP=%TEMP%\platform-tools-latest-windows.zip"
set "LOG=%TEMP%\ADB_Fastboot_Installer.log"
set "URL=https://dl.google.com/android/repository/platform-tools-latest-windows.zip"

if not exist "%TEMP%" mkdir "%TEMP%"
echo.>"%LOG%"

:: Administrator check and elevation
net session >nul 2>&1
if not "%errorlevel%"=="0" (
    echo Requesting Administrator permission...
    powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

:MENU
cls
echo ==================================================
echo       ADB + FASTBOOT ALL-IN-ONE REPAIR TOOL
echo ==================================================
echo.
echo  [1] Install / Repair ADB and Fastboot
echo  [2] Repair Windows PATH
echo  [3] Check ADB Device
echo  [4] Check Fastboot Device
echo  [5] Check USB / PnP Devices
echo  [6] Show ADB and Fastboot Versions
echo  [7] Open Platform-Tools Folder
echo  [8] View Installation Log
echo  [9] Uninstall Platform-Tools
echo  [0] Exit
echo.
choice /c 1234567890 /n /m "Select option: "

if errorlevel 10 goto END
if errorlevel 9 goto UNINSTALL
if errorlevel 8 goto VIEWLOG
if errorlevel 7 goto OPENFOLDER
if errorlevel 6 goto VERSION
if errorlevel 5 goto USB
if errorlevel 4 goto FASTBOOT
if errorlevel 3 goto ADB
if errorlevel 2 goto PATHFIX
if errorlevel 1 goto INSTALL
goto MENU

:INSTALL
cls
echo [1/5] Preparing installation...
echo [%date% %time%] Install started>>"%LOG%"

if not exist "C:\Android" mkdir "C:\Android"

echo.
echo [2/5] Downloading official Google Platform-Tools...
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
 "$ProgressPreference='SilentlyContinue'; Invoke-WebRequest -Uri '%URL%' -OutFile '%ZIP%'"

if errorlevel 1 (
    echo ERROR: Download failed.
    echo Check internet connection and try again.
    echo [%date% %time%] Download failed>>"%LOG%"
    pause
    goto MENU
)

echo.
echo [3/5] Extracting files...
if exist "%INSTALL_DIR%" (
    echo Existing installation found.
    echo Updating files in %INSTALL_DIR%
) else (
    mkdir "%INSTALL_DIR%"
)

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
 "Expand-Archive -LiteralPath '%ZIP%' -DestinationPath '%TEMP%\adb_pt_extract' -Force"

if errorlevel 1 (
    echo ERROR: Extraction failed.
    echo [%date% %time%] Extraction failed>>"%LOG%"
    pause
    goto MENU
)

if not exist "%TEMP%\adb_pt_extract\platform-tools\adb.exe" (
    echo ERROR: adb.exe not found in downloaded package.
    pause
    goto MENU
)

robocopy "%TEMP%\adb_pt_extract\platform-tools" "%INSTALL_DIR%" /E /COPY:DAT /R:2 /W:1 /NFL /NDL /NP
if %errorlevel% GEQ 8 (
    echo ERROR: File copy failed.
    pause
    goto MENU
)

echo.
echo [4/5] Repairing Windows Machine PATH...
call :FIXPATH

echo.
echo [5/5] Verifying installation...
if exist "%INSTALL_DIR%\adb.exe" (
    echo ADB: OK
) else (
    echo ADB: MISSING
)

if exist "%INSTALL_DIR%\fastboot.exe" (
    echo Fastboot: OK
) else (
    echo Fastboot: MISSING
)

del "%ZIP%" >nul 2>&1
if exist "%TEMP%\adb_pt_extract" rmdir /s /q "%TEMP%\adb_pt_extract" >nul 2>&1

echo [%date% %time%] Installation/repair completed>>"%LOG%"
echo.
echo Installation finished. Open a NEW CMD window.
pause
goto MENU

:FIXPATH
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
 "$p=[Environment]::GetEnvironmentVariable('Path','Machine');" ^
 "$d='%INSTALL_DIR%';" ^
 "$parts=@($p -split ';' | Where-Object { $_.Trim() -ne '' });" ^
 "if (-not ($parts | Where-Object { $_.TrimEnd('\') -ieq $d.TrimEnd('\') })) {" ^
 "$new=($parts + $d) -join ';';" ^
 "[Environment]::SetEnvironmentVariable('Path',$new,'Machine');" ^
 "Write-Output 'Machine PATH updated.' } else {" ^
 "Write-Output 'Platform-Tools already in Machine PATH.' }"

if errorlevel 1 (
    echo PATH repair failed. Check administrator permission.
    echo [%date% %time%] PATH repair failed>>"%LOG%"
) else (
    echo PATH repair checked.
    echo [%date% %time%] PATH repair checked>>"%LOG%"
)

set "PATH=%INSTALL_DIR%;%PATH%"
exit /b

:PATHFIX
cls
echo Repairing PATH...
call :FIXPATH
echo.
echo Current session PATH updated.
echo New terminals will load the saved Machine PATH.
pause
goto MENU

:ADB
cls
echo Checking ADB connection...
if not exist "%INSTALL_DIR%\adb.exe" (
    echo ADB is not installed. Select option 1 first.
    pause
    goto MENU
)
"%INSTALL_DIR%\adb.exe" start-server
"%INSTALL_DIR%\adb.exe" devices -l
echo.
echo If the phone says unauthorized, unlock it and accept
echo the USB debugging authorization prompt.
echo [%date% %time%] ADB device check>>"%LOG%"
pause
goto MENU

:FASTBOOT
cls
echo Checking Fastboot connection...
if not exist "%INSTALL_DIR%\fastboot.exe" (
    echo Fastboot is not installed. Select option 1 first.
    pause
    goto MENU
)
"%INSTALL_DIR%\fastboot.exe" devices
echo.
echo A blank device list can mean a driver, cable,
echo port, or device-mode issue.
echo [%date% %time%] Fastboot device check>>"%LOG%"
pause
goto MENU

:USB
cls
echo Checking connected Plug and Play devices...
powershell -NoProfile -Command ^
 "Get-PnpDevice -PresentOnly -ErrorAction SilentlyContinue | Where-Object { $_.Class -in @('AndroidUsbDevice','USB','Android','Ports') -or $_.FriendlyName -match 'ADB|Android|Fastboot|MediaTek|Qualcomm' } | Format-Table Status,Class,FriendlyName -AutoSize"
echo.
echo This is a basic device check, not a complete driver diagnosis.
echo [%date% %time%] PnP device check>>"%LOG%"
pause
goto MENU

:VERSION
cls
if exist "%INSTALL_DIR%\adb.exe" (
    "%INSTALL_DIR%\adb.exe" version
) else (
    echo ADB not installed.
)
echo.
if exist "%INSTALL_DIR%\fastboot.exe" (
    "%INSTALL_DIR%\fastboot.exe" --version
) else (
    echo Fastboot not installed.
)
echo [%date% %time%] Version check>>"%LOG%"
pause
goto MENU

:OPENFOLDER
if exist "%INSTALL_DIR%" (
    start "" explorer.exe "%INSTALL_DIR%"
) else (
    echo Platform-Tools folder not found.
    pause
)
goto MENU

:VIEWLOG
if exist "%LOG%" (
    notepad.exe "%LOG%"
) else (
    echo No log file found.
    pause
)
goto MENU

:UNINSTALL
cls
echo WARNING:
echo This removes the installed Platform-Tools folder
echo and its exact Machine PATH entry.
echo Other ADB installations are not intentionally removed.
echo.
choice /c YN /m "Continue with uninstall"
if errorlevel 2 goto MENU

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
 "$d='%INSTALL_DIR%';" ^
 "$p=[Environment]::GetEnvironmentVariable('Path','Machine');" ^
 "$parts=@($p -split ';' | Where-Object { $_.Trim() -ne '' -and $_.TrimEnd('\') -ine $d.TrimEnd('\') });" ^
 "[Environment]::SetEnvironmentVariable('Path',($parts -join ';'),'Machine')"

if exist "%INSTALL_DIR%" rmdir /s /q "%INSTALL_DIR%"

echo Uninstall operation completed.
echo Note: Existing terminal windows may retain their old PATH.
echo [%date% %time%] Uninstall requested>>"%LOG%"
pause
goto MENU

:END
echo Exiting...
endlocal
exit /b
