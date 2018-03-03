@echo off

REM Build Number and other version info
set "BUILD_NO=136"
set "MPLAYER_REVISION=37905"
set "SMPLAYER_VERSION=16.11.0 (SVN-r8243)"
set "MPUI_VERSION=1.2-pre3 (Build 38)"
set "CODECS_DATE=2011-01-31"

REM Path to NSIS, Unicode version highly recommended!
set "NSIS_PATH=E:\Source\Prerequisites\NSIS\makensis.exe"

REM Path to UPX executable compressor program
set "UPX_PATH=E:\Source\Prerequisites\UPX\UPX.exe"

REM --------------------------------------------------------------------------
REM Do NOT modify any lines below!
REM --------------------------------------------------------------------------

echo ---------------------------------------------------------
echo BUILD_NO: %BUILD_NO%
echo MPLAYER_REVISION: %MPLAYER_REVISION%
echo SMPLAYER_VERSION: %SMPLAYER_VERSION%
echo MPUI_VERSION: %MPUI_VERSION%
echo CODECS_DATE: %CODECS_DATE%
echo ---------------------------------------------------------

REM Get current Date
set ISO_DATE=
for /F "tokens=1,2 delims=:" %%a in ('"%~dp0\Utils\Date.exe" +ISODATE:%%Y-%%m-%%d') do (
	if "%%a"=="ISODATE" set "ISO_DATE=%%b"
)

REM Check for MakeNSIS
if not exist "%MAKE_NSIS%\makensis.exe" (
	echo MAKENSIS executable not found, check path!
	pause
	goto:eof
)

REM Print some Info
echo Build #%BUILD_NO%, Date: %ISO_DATE%
echo.

REM Create outputfolder, if not exists yet
mkdir "%~dp0\.Compile" 2> NUL
mkdir "%~dp0\.Release" 2> NUL

REM Build update tool
"%MAKE_NSIS%\makensis.exe" "/DMPLAYER_BUILDNO=%BUILD_NO%" "/DMPLAYER_DATE=%ISO_DATE%" "/DUPX_PATH=%UPX_PATH%" "/DMPLAYER_OUTFILE=%~dp0\.Compile\Updater.exe" "%~dp0\MPUI_Updater.nsi"
if %ERRORLEVEL% NEQ 0 (
	pause
	goto:eof
)
"%MAKE_NSIS%\peheader.exe" "%~dp0\.Compile\Updater.exe"
if %ERRORLEVEL% NEQ 0 (
	pause
	goto:eof
)

REM Build main installer
"%MAKE_NSIS%\makensis.exe" "/DMPLAYER_BUILDNO=%BUILD_NO%" "/DMPLAYER_DATE=%ISO_DATE%" "/DMPLAYER_REVISION=%MPLAYER_REVISION%" "/DSMPLAYER_VERSION=%SMPLAYER_VERSION%" "/DMPUI_VERSION=%MPUI_VERSION%" "/DCODECS_DATE=%CODECS_DATE%" "/DUPX_PATH=%UPX_PATH%" "/DMPLAYER_OUTFILE=%~dp0\.Release\MPUI.%ISO_DATE%.sfx" "%~dp0\MPUI_Setup.nsi"
if %ERRORLEVEL% NEQ 0 (
	pause
	goto:eof
)
"%MAKE_NSIS%\peheader.exe" "%~dp0\.Release\MPUI.%ISO_DATE%.sfx"
if %ERRORLEVEL% NEQ 0 (
	pause
	goto:eof
)

REM Build installer wrapper
call "%~dp0\Utils\7zSD.cmd" "%~dp0\.Release\MPUI.%ISO_DATE%.sfx" "%~dp0\.Release\MPUI.%ISO_DATE%.exe" "MPlayer for Windows" "MPUI-Setup-r%BUILD_NO%"
if %ERRORLEVEL% NEQ 0 (
	pause
	goto:eof
)
"%MAKE_NSIS%\peheader.exe" "%~dp0\.Release\MPUI.%ISO_DATE%.exe"
if %ERRORLEVEL% NEQ 0 (
	pause
	goto:eof
)

set "VERPATCH_PRODUCT=MPlayer for Windows (Installer)"
set "VERPATCH_FILEVER=%ISO_DATE:-=.%.%BUILD_NO%"
"%~dp0\Utils\VerPatch.exe" "%~dp0\.Release\MPUI.%ISO_DATE%.exe" "%VERPATCH_FILEVER%" /pv "%VERPATCH_FILEVER%" /fn /s desc "%VERPATCH_PRODUCT%" /s product "%VERPATCH_PRODUCT%" /s title "MPUI Setup SFX" /s copyright "Copyright (C) LoRd_MuldeR" /s company "Free Software Foundation"
if %ERRORLEVEL% NEQ 0 (
	pause
	goto:eof
)

pause
