@echo off

REM Build Number and other version info
call "%~dp0\!_Version.bat"
if "%BUILD_NO%"==""         echo BUILD_NO is not defined!         & pause & goto:eof
if "%MPLAYER_REVISION%"=="" echo MPLAYER_REVISION is not defined! & pause & goto:eof
if "%SMPLAYER_VERSION%"=="" echo SMPLAYER_VERSION is not defined! & pause & goto:eof
if "%MPUI_VERSION%"==""     echo MPUI_VERSION is not defined!     & pause & goto:eof
if "%CODECS_DATE%"==""      echo CODECS_DATE is not defined!      & pause & goto:eof
if "%BUILD_NO%"==""         echo BUILD_NO is not defined!         & pause & goto:eof

REM BSetup prerequisites path
call "%~dp0\!_Paths.bat"
if "%NSIS_PATH%"==""   echo NSIS_PATH is not defined!   & pause & goto:eof
if "%UPX_PATH%"==""    echo UPX_PATH is not defined!    & pause & goto:eof
if "%SEVENZ_PATH%"=="" echo SEVENZ_PATH is not defined! & pause & goto:eof
if "%VPATCH_PATH%"=="" echo VPATCH_PATH is not defined! & pause & goto:eof

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
if not exist "%NSIS_PATH%\makensis.exe" (
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

REM Generate docs
call "%~dp0\Docs\minify.cmd"

REM Build update tool
"%NSIS_PATH%\makensis.exe" "/DMPLAYER_BUILDNO=%BUILD_NO%" "/DMPLAYER_DATE=%ISO_DATE%" "/DUPX_PATH=%UPX_PATH%" "/DMPLAYER_OUTFILE=%~dp0\.Compile\Updater.exe" "%~dp0\MPUI_Updater.nsi"
if %ERRORLEVEL% NEQ 0 (
	pause
	goto:eof
)
"%NSIS_PATH%\peheader.exe" "%~dp0\.Compile\Updater.exe"
if %ERRORLEVEL% NEQ 0 (
	pause
	goto:eof
)

REM Build main installer
"%NSIS_PATH%\makensis.exe" "/DMPLAYER_BUILDNO=%BUILD_NO%" "/DMPLAYER_DATE=%ISO_DATE%" "/DMPLAYER_REVISION=%MPLAYER_REVISION%" "/DSMPLAYER_VERSION=%SMPLAYER_VERSION%" "/DMPUI_VERSION=%MPUI_VERSION%" "/DCODECS_DATE=%CODECS_DATE%" "/DUPX_PATH=%UPX_PATH%" "/DMPLAYER_OUTFILE=%~dp0\.Release\MPUI.%ISO_DATE%.sfx" "%~dp0\MPUI_Setup.nsi"
if %ERRORLEVEL% NEQ 0 (
	pause
	goto:eof
)
"%NSIS_PATH%\peheader.exe" "%~dp0\.Release\MPUI.%ISO_DATE%.sfx"
if %ERRORLEVEL% NEQ 0 (
	pause
	goto:eof
)

REM Build installer wrapper
call "%SEVENZ_PATH%\7zSDex.cmd" "%~dp0\.Release\MPUI.%ISO_DATE%.sfx" "%~dp0\.Release\MPUI.%ISO_DATE%.exe" "MPlayer for Windows" "mpui-install-r%BUILD_NO%"
if %ERRORLEVEL% NEQ 0 (
	pause
	goto:eof
)
"%NSIS_PATH%\peheader.exe" "%~dp0\.Release\MPUI.%ISO_DATE%.exe"
if %ERRORLEVEL% NEQ 0 (
	pause
	goto:eof
)

set "VERPATCH_PRODUCT=MPlayer for Windows (Installer)"
set "VERPATCH_FILEVER=%ISO_DATE:-=.%.%BUILD_NO%"
"%VPATCH_PATH%\VerPatch.exe" "%~dp0\.Release\MPUI.%ISO_DATE%.exe" "%VERPATCH_FILEVER%" /pv "%VERPATCH_FILEVER%" /fn /s desc "%VERPATCH_PRODUCT%" /s product "%VERPATCH_PRODUCT%" /s title "MPUI Setup SFX" /s copyright "Copyright (C) LoRd_MuldeR" /s company "Free Software Foundation"
if %ERRORLEVEL% NEQ 0 (
	pause
	goto:eof
)

pause
