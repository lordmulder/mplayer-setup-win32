@echo off

REM Build Number and other version info
set "BUILD_NO=121"
set "MPLAYER_REVISION=36573"
set "SMPLAYER_VERSION=0.8.6 (SVN-r5971)"
set "MPUI_VERSION=1.2-pre3 (Build 38)"
set "CODECS_DATE=2011-01-31"

REM Path to NSIS, Unicode version highly recommended!
set "MAKE_NSIS=D:\NSIS\_Unicode\makensis.exe"

REM Path to UPX executable compressor program
set "UPX_PATH=%~dp0\Utils\UPX.exe"

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
if not exist "%MAKE_NSIS%" (
	echo MAKENSIS.EXE not found, check path!
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
"%MAKE_NSIS%" "/DMPLAYER_BUILDNO=%BUILD_NO%" "/DMPLAYER_DATE=%ISO_DATE%" "/DUPX_PATH=%UPX_PATH%" "/DMPLAYER_OUTFILE=%~dp0\.Compile\Updater.exe" "%~dp0\MPUI_Updater.nsi"
if errorlevel 1 (
	pause
	goto:eof
)

REM Build main installer
"%MAKE_NSIS%" "/DMPLAYER_BUILDNO=%BUILD_NO%" "/DMPLAYER_DATE=%ISO_DATE%" "/DMPLAYER_REVISION=%MPLAYER_REVISION%" "/DSMPLAYER_VERSION=%SMPLAYER_VERSION%" "/DMPUI_VERSION=%MPUI_VERSION%" "/DCODECS_DATE=%CODECS_DATE%" "/DUPX_PATH=%UPX_PATH%" "/DMPLAYER_OUTFILE=%~dp0\.Release\MPUI.%ISO_DATE%.sfx" "%~dp0\MPUI_Setup.nsi"
if errorlevel 1 (
	pause
	goto:eof
)

REM Build installer wrapper
"%MAKE_NSIS%" "/DMPLAYER_BUILDNO=%BUILD_NO%" "/DMPLAYER_DATE=%ISO_DATE%" "/DMPLAYER_REVISION=%MPLAYER_REVISION%" "/DUPX_PATH=%UPX_PATH%" "/DMPLAYER_SRCFILE=%~dp0\.Release\MPUI.%ISO_DATE%.sfx" "/DMPLAYER_OUTFILE=%~dp0\.Release\MPUI.%ISO_DATE%.exe" "%~dp0\MPUI_Wrapper.nsi"
if errorlevel 1 (
	pause
	goto:eof
)

pause
