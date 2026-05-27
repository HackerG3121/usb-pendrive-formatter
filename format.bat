@echo off
setlocal enabledelayedexpansion
title USB Pendrive Formatter v3.0
color 0A
mode con: cols=60 lines=35
cls

:: -----------------------------------------------
:: STEP 1 - Get disk list via PowerShell to temp file
:: -----------------------------------------------
powershell -NoProfile -Command "Get-WmiObject Win32_DiskDrive | Sort-Object Index | ForEach-Object { $gb = [math]::Round($_.Size/1GB,0); Write-Output ($_.Index.ToString()+'|'+$gb.ToString()+' GB|'+$_.Model) }" > "%temp%\diskinfo.txt" 2>nul

cls
echo.
echo  +--------------------------------------------------+
echo  *        USB PENDRIVE FORMATTER  v3.0              *
echo  +--------------------------------------------------+
echo.
echo    Scanning connected disks...
echo.
echo  +--------+----------+----------------------------+
echo  *  Disk  *   Size   *   Model / Name             *
echo  +--------+----------+----------------------------+

set DISKCOUNT=0
for /f "usebackq tokens=1,2,* delims=|" %%A in ("%temp%\diskinfo.txt") do (
    set /a DISKCOUNT+=1
    set "MDL=%%C"
    set "MDL=!MDL:~0,26!"
    echo  *   %%A    *  %%B  *  !MDL!
)

echo  +--------+----------+----------------------------+
echo.
echo    Total Disks Found : !DISKCOUNT!
echo.
echo  +--------------------------------------------------+
echo  *  WARNING : Formatting will ERASE ALL DATA        *
echo  +--------------------------------------------------+
echo.
set /p "DISKNUM=   Enter Disk Number to Format  >>  "

:: Validate - numbers only
set "VALID="
for /f "delims=0123456789" %%i in ("!DISKNUM!") do set "VALID=%%i"
if defined VALID (
    color 0C
    echo.
    echo   [ERROR] Invalid input. Enter a number only.
    echo.
    pause
    exit /b
)

:: Get model and size of selected disk
set "SELGB=Unknown"
set "SELMDL=Unknown"
for /f "usebackq tokens=1,2,* delims=|" %%A in ("%temp%\diskinfo.txt") do (
    if "%%A"=="!DISKNUM!" (
        set "SELGB=%%B"
        set "SELMDL=%%C"
    )
)

:: -----------------------------------------------
:: STEP 2 - Confirm Screen
:: -----------------------------------------------
cls
echo.
echo  +--------------------------------------------------+
echo  *               CONFIRM FORMAT                     *
echo  +--------------------------------------------------+
echo.
echo    Disk Number  :  !DISKNUM!
echo    Model        :  !SELMDL!
echo    Size         :  !SELGB!
echo    Format As    :  FAT32  (Quick Format)
echo    Label        :  USB DRIVE
echo.
echo  +--------------------------------------------------+
echo  *       ALL DATA WILL BE PERMANENTLY DELETED       *
echo  *          THIS ACTION CANNOT BE UNDONE            *
echo  +--------------------------------------------------+
echo.
echo    Press ENTER to confirm format...
echo    Press Ctrl+C to cancel.
echo.
pause /b


:: -----------------------------------------------
:: STEP 3 - Format
:: -----------------------------------------------
cls
echo.
echo  +--------------------------------------------------+
echo  *           FORMATTING IN PROGRESS                 *
echo  +--------------------------------------------------+
echo.
echo    Disk    :  !DISKNUM!
echo    Model   :  !SELMDL!
echo    Size    :  !SELGB!
echo    Format  :  FAT32 Quick
echo.
echo    Please wait. Do NOT remove the drive...
echo.

(
echo select disk !DISKNUM!
echo clean
echo create partition primary
echo select partition 1
echo format fs=fat32 quick label=USBDRIVE
echo assign
echo exit
) > "%temp%\fmt_script.txt"

diskpart /s "%temp%\fmt_script.txt"

:: -----------------------------------------------
:: STEP 4 - Done
:: -----------------------------------------------
cls
echo.
echo  +--------------------------------------------------+
echo  *           FORMAT COMPLETED                       *
echo  +--------------------------------------------------+
echo.
echo    Disk     :  !DISKNUM!
echo    Model    :  !SELMDL!
echo    Size     :  !SELGB!
echo    Format   :  FAT32
echo    Label    :  USBDRIVE
echo.
echo    Your pendrive is ready to use!
echo.
echo  +--------------------------------------------------+
echo.
pause