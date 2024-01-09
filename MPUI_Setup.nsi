; ///////////////////////////////////////////////////////////////////////////////
; // MPlayer for Windows - Install Script
; // Copyright (C) 2004-2024 LoRd_MuldeR <MuldeR2@GMX.de>
; //
; // This program is free software; you can redistribute it and/or modify
; // it under the terms of the GNU General Public License as published by
; // the Free Software Foundation; either version 2 of the License, or
; // (at your option) any later version.
; //
; // This program is distributed in the hope that it will be useful,
; // but WITHOUT ANY WARRANTY; without even the implied warranty of
; // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; // GNU General Public License for more details.
; //
; // You should have received a copy of the GNU General Public License along
; // with this program; if not, write to the Free Software Foundation, Inc.,
; // 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
; //
; // http://www.gnu.org/licenses/gpl-2.0.txt
; ///////////////////////////////////////////////////////////////////////////////


;--------------------------------------------------------------------------------
; BASIC DEFINES
;--------------------------------------------------------------------------------

!ifndef NSIS_UNICODE
  !error "NSIS_UNICODE is undefined, please compile with Unicode NSIS !!!"
!endif

!ifndef MPLAYER_BUILDNO
  !error "MPLAYER_BUILDNO is not defined !!!"
!endif

!ifndef MPLAYER_REVISION
  !error "MPLAYER_REVISION is not defined !!!"
!endif

!ifndef MPLAYER_DATE
  !error "MPLAYER_DATE is not defined !!!"
!endif

!ifndef SMPLAYER_VERSION
  !error "SMPLAYER_VERSION is not defined !!!"
!endif

!ifndef MPUI_VERSION
  !error "MPUI_VERSION is not defined !!!"
!endif

!ifndef CODECS_DATE
  !error "CODECS_DATE is not defined !!!"
!endif

!ifndef MPLAYER_OUTFILE
  !error "MPLAYER_OUTFILE is not defined !!!"
!endif

!ifndef UPX_PATH
  !error "UPX_PATH is not defined !!!"
!endif

; UUID
!define MPlayerRegPath "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{97D341C8-B0D1-4E4A-A49A-C30B52F168E9}"

; Web-Site
!define MPlayerWebSite "http://mplayerhq.hu/"


;--------------------------------------------------------------------------------
; INSTALLER ATTRIBUTES
;--------------------------------------------------------------------------------

RequestExecutionLevel admin
ShowInstDetails show
ShowUninstDetails show

Name "$(MPLAYER_LANG_MPLAYER_WIN32) ${MPLAYER_DATE} (Build #${MPLAYER_BUILDNO})"
Caption "$(MPLAYER_LANG_MPLAYER_WIN32) ${MPLAYER_DATE} (Build #${MPLAYER_BUILDNO})"
BrandingText "MPlayer-Win32 (Build #${MPLAYER_BUILDNO})"
InstallDir "$PROGRAMFILES\MPlayer for Windows"
InstallDirRegKey HKLM "${MPlayerRegPath}" "InstallLocation"
OutFile "${MPLAYER_OUTFILE}"


;--------------------------------------------------------------------------------
; COMPRESSOR
;--------------------------------------------------------------------------------

SetCompressor /SOLID /FINAL LZMA
SetCompressorDictSize 112

!tempfile PACKHDRTEMP
!packhdr "${PACKHDRTEMP}" '"Utils\MT.exe" -manifest "Resources\Setup.manifest" -outputresource:"${PACKHDRTEMP};1"'

!packhdr "$%TEMP%\exehead.tmp" '"${UPX_PATH}\upx.exe" --brute "$%TEMP%\exehead.tmp"'


;--------------------------------------------------------------------------------
; RESERVE FILES
;--------------------------------------------------------------------------------

ReserveFile "${NSISDIR}\Plugins\Aero.dll"
ReserveFile "${NSISDIR}\Plugins\Banner.dll"
ReserveFile "${NSISDIR}\Plugins\CPUFeatures.dll"
ReserveFile "${NSISDIR}\Plugins\InstallOptions.dll"
ReserveFile "${NSISDIR}\Plugins\LangDLL.dll"
ReserveFile "${NSISDIR}\Plugins\LockedList.dll"
ReserveFile "${NSISDIR}\Plugins\LockedList64.dll"
ReserveFile "${NSISDIR}\Plugins\nsDialogs.dll"
ReserveFile "${NSISDIR}\Plugins\nsExec.dll"
ReserveFile "${NSISDIR}\Plugins\StartMenu.dll"
ReserveFile "${NSISDIR}\Plugins\StdUtils.dll"
ReserveFile "${NSISDIR}\Plugins\System.dll"
ReserveFile "${NSISDIR}\Plugins\UserInfo.dll"
ReserveFile "Dialogs\Page_CPU.ini"
ReserveFile "Resources\Splash.gif"


;--------------------------------------------------------------------------------
; INCLUDES
;--------------------------------------------------------------------------------

!include `MUI2.nsh`
!include `InstallOptions.nsh`
!include `WinVer.nsh`
!include `x64.nsh`
!include `StrFunc.nsh`
!include `StdUtils.nsh`
!include `CPUFeatures.nsh`
!include `MPUI_Common.nsh`

; Enable functions
${StrRep}


;--------------------------------------------------------------------------------
; GLOBAL VARIABLES
;--------------------------------------------------------------------------------

Var StartMenuFolder
Var DetectedCPUType
Var DetectedCPUCores
Var SelectedCPUType
Var SelectedTweaks
Var NotUpdateInstall


;--------------------------------------------------------------------------------
; VERSION INFO
;--------------------------------------------------------------------------------

!searchreplace PRODUCT_VERSION_DATE "${MPLAYER_DATE}" "-" "."
VIProductVersion "${PRODUCT_VERSION_DATE}.${MPLAYER_BUILDNO}"

VIAddVersionKey "Author" "LoRd_MuldeR <mulder2@gmx.de>"
VIAddVersionKey "Comments" "This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version."
VIAddVersionKey "CompanyName" "Free Software Foundation"
VIAddVersionKey "FileDescription" "MPlayer for Windows (Build #${MPLAYER_BUILDNO})"
VIAddVersionKey "FileVersion" "${PRODUCT_VERSION_DATE}.${MPLAYER_BUILDNO}"
VIAddVersionKey "LegalCopyright" "Copyright 2000-2018 The MPlayer Project"
VIAddVersionKey "LegalTrademarks" "GNU"
VIAddVersionKey "OriginalFilename" "MPUI-Setup.exe"
VIAddVersionKey "ProductName" "MPlayer for Windows"
VIAddVersionKey "ProductVersion" "Build #${MPLAYER_BUILDNO} (${MPLAYER_DATE})"
VIAddVersionKey "Website" "${MPlayerWebSite}"


;--------------------------------------------------------------------------------
; MUI2 INTERFACE SETTINGS
;--------------------------------------------------------------------------------

!define MUI_ABORTWARNING
!define MUI_STARTMENUPAGE_REGISTRY_ROOT HKLM
!define MUI_STARTMENUPAGE_REGISTRY_KEY "${MPlayerRegPath}"
!define MUI_STARTMENUPAGE_REGISTRY_VALUENAME "StartmenuFolder"
!define MUI_LANGDLL_REGISTRY_ROOT HKLM
!define MUI_LANGDLL_REGISTRY_KEY "${MPlayerRegPath}"
!define MUI_LANGDLL_REGISTRY_VALUENAME "SetupLanguage"
!define MUI_STARTMENUPAGE_DEFAULTFOLDER "MPlayer for Windows"
!define MUI_FINISHPAGE_NOAUTOCLOSE
!define MUI_UNFINISHPAGE_NOAUTOCLOSE
!define MUI_FINISHPAGE_RUN
!define MUI_FINISHPAGE_RUN_FUNCTION RunAppFunction
!define MUI_FINISHPAGE_SHOWREADME
!define MUI_FINISHPAGE_SHOWREADME_FUNCTION ShowReadmeFunction
!define MUI_FINISHPAGE_LINK ${MPlayerWebSite}
!define MUI_FINISHPAGE_LINK_LOCATION ${MPlayerWebSite}
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\orange-install.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\orange-uninstall.ico"
!define MUI_WELCOMEFINISHPAGE_BITMAP "Artwork\wizard.bmp"
!define MUI_UNWELCOMEFINISHPAGE_BITMAP "Artwork\wizard-un.bmp"
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_BITMAP "Artwork\header.bmp"
!define MUI_HEADERIMAGE_UNBITMAP "Artwork\header-un.bmp"
!define MUI_LANGDLL_ALLLANGUAGES
!define MUI_CUSTOMFUNCTION_GUIINIT MyGuiInit
!define MUI_CUSTOMFUNCTION_UNGUIINIT un.MyGuiInit
!define MUI_LANGDLL_ALWAYSSHOW
!define MUI_COMPONENTSPAGE_SMALLDESC


;--------------------------------------------------------------------------------
; MUI2 PAGE SETUP
;--------------------------------------------------------------------------------

; Installer
!define MUI_WELCOMEPAGE_TITLE_3LINES
!define MUI_FINISHPAGE_TITLE_3LINES
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "Docs\License.txt"
!define MUI_PAGE_CUSTOMFUNCTION_SHOW CheckForUpdate
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro  MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_STARTMENU Application $StartMenuFolder
Page Custom SelectCPUPage_Show SelectCPUPage_Validate
Page Custom SetTweaksPage_Show
Page Custom LockedListPage_Show
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

; Un-Installer
!define MUI_WELCOMEPAGE_TITLE_3LINES
!define MUI_FINISHPAGE_TITLE_3LINES
!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
UninstPage Custom un.LockedListPage_Show
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH


;--------------------------------------------------------------------------------
; LANGUAGE
;--------------------------------------------------------------------------------
 
!insertmacro MUI_LANGUAGE "English"
!insertmacro MUI_LANGUAGE "German"

; Translation files
!include "Language\MPUI_EN.nsh"
!include "Language\MPUI_DE.nsh"


;--------------------------------------------------------------------------------
; INSTALL TYPES
;--------------------------------------------------------------------------------

InstType "$(MPLAYER_LANG_INSTTYPE_COMPLETE)"
InstType "$(MPLAYER_LANG_INSTTYPE_MINIMAL)"


;--------------------------------------------------------------------------------
; INITIALIZATION
;--------------------------------------------------------------------------------

Function .onInit
	StrCpy $SelectedCPUType 0
	StrCpy $DetectedCPUType 0
	StrCpy $DetectedCPUCores 0
	StrCpy $SelectedTweaks 1
	StrCpy $NotUpdateInstall 1

	InitPluginsDir

	; --------
	
	System::Call 'kernel32::CreateMutexA(i 0, i 0, t "{B800490C-C100-4B12-9F09-1A54DF063049}") i .r1 ?e'
	Pop $0
	${If} $0 <> 0
		MessageBox MB_ICONSTOP|MB_TOPMOST "Oups, the installer is already running!"
		Quit
	${EndIf}

	; --------
	
	# Running on Windows NT family?
	${IfNot} ${IsNT}
		MessageBox MB_TOPMOST|MB_ICONSTOP "Sorry, this application does *not* support Windows 9x or Windows ME!"
		ExecShell "open" "http://windows.microsoft.com/"
		Quit
	${EndIf}

	# Running on Windows XP or later?
	${If} ${AtMostWin2000}
		MessageBox MB_TOPMOST|MB_ICONSTOP "Sorry, but your operating system is *not* supported anymore.$\nInstallation will be aborted!$\n$\nThe minimum required platform is Windows XP."
		ExecShell "open" "http://windows.microsoft.com/"
		Quit
	${EndIf}

	; --------

	UserInfo::GetAccountType
	Pop $0
	${If} $0 != "Admin"
		MessageBox MB_ICONSTOP|MB_TOPMOST "Your system requires administrative permissions in order to install this software."
		SetErrorLevel 740 ;ERROR_ELEVATION_REQUIRED
		Quit
	${EndIf}
	
	; --------
	
	!insertmacro MUI_LANGDLL_DISPLAY
	
	!insertmacro INSTALLOPTIONS_EXTRACT_AS "Dialogs\Page_CPU.ini"    "Page_CPU.ini"
	!insertmacro INSTALLOPTIONS_EXTRACT_AS "Dialogs\Page_Tweaks.ini" "Page_Tweaks.ini"
	
	!ifdef PRE_RELEASE
		${IfCmd} MessageBox MB_TOPMOST|MB_ICONEXCLAMATION|MB_OKCANCEL|MB_DEFBUTTON2 "Note: This is an early pre-release version for test only!" IDCANCEL ${||} Quit ${|}
	!endif
	
	; --------

	${IfNot} ${Silent}
		File "/oname=$PLUGINSDIR\Splash.gif" "Resources\Splash.gif"
		newadvsplash::show 3000 1000 500 -1 /NOCANCEL "$PLUGINSDIR\Splash.gif"
		Delete /REBOOTOK "$PLUGINSDIR\Splash.gif"
	${EndIf}
FunctionEnd

Function un.onInit
	InitPluginsDir

	System::Call 'kernel32::CreateMutexA(i 0, i 0, t "{B800490C-C100-4B12-9F09-1A54DF063049}") i .r1 ?e'
	Pop $0
	${If} $0 <> 0
		MessageBox MB_ICONSTOP|MB_TOPMOST "Sorry, the un-installer is already running!"
		Quit
	${EndIf}

	; --------

	UserInfo::GetAccountType
	Pop $0
	${If} $0 != "Admin"
		MessageBox MB_ICONSTOP|MB_TOPMOST "Your system requires administrative permissions in order to un-install this software."
		SetErrorLevel 740 ;ERROR_ELEVATION_REQUIRED
		Quit
	${EndIf}

	; --------
	
	!insertmacro MUI_LANGDLL_DISPLAY
FunctionEnd


;--------------------------------------------------------------------------------
; GUI INITIALIZATION
;--------------------------------------------------------------------------------

Function MyGuiInit
	StrCpy $0 $HWNDPARENT
	System::Call "user32::SetWindowPos(i r0, i -1, i 0, i 0, i 0, i 0, i 3)"
	Aero::Apply
FunctionEnd

Function un.MyGuiInit
	StrCpy $0 $HWNDPARENT
	System::Call "user32::SetWindowPos(i r0, i -1, i 0, i 0, i 0, i 0, i 3)"
	Aero::Apply
FunctionEnd


;--------------------------------------------------------------------------------
; INSTALL SECTIONS
;--------------------------------------------------------------------------------

Section "-Check Current Version"
	${StdUtils.TestParameter} $0 "Update"
	${IfNot} "$0" == "true"
	${AndIf} ${FileExists} "$INSTDIR\MPlayer.exe"
	${AndIf} ${FileExists} "$INSTDIR\version.tag"
		ReadINIStr $0 "$INSTDIR\version.tag" "mplayer_version" "build_no"
		${If} $0 > ${MPLAYER_BUILDNO}
			MessageBox MB_OK|MB_ICONEXCLAMATION|MB_TOPMOST "$(MPLAYER_LANG_CAN_NOT_UPDATE)"
			Quit
		${EndIf}
	${EndIf}
SectionEnd

Section "-Clean Up"
	${PrintProgress} "$(MPLAYER_LANG_STATUS_INST_CLEAN)"

	SetShellVarContext all
	SetOutPath "$INSTDIR"

	; Uninstall old version (aka "Setup v1")
	ClearErrors
	ReadRegStr $0 HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{DB9E4EAB-2717-499F-8D56-4CC8A644AB60}" "InstallLocation"
	${IfNot} ${Errors}
		MessageBox MB_ICONINFORMATION|MB_OK "$(MPLAYER_LANG_UNINSTALL_OLDVER)"
		File "/oname=$PLUGINSDIR\Uninstall-V1.exe" "Resources\Uninstall-V1.exe"
		HideWindow
		ExecWait '"$PLUGINSDIR\Uninstall-V1.exe" _?=$0'
		Delete /REBOOTOK "$PLUGINSDIR\Uninstall-V1.exe"
		BringToFront
	${EndIf}

	; Clean registry
	DeleteRegKey HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{DB9E4EAB-2717-499F-8D56-4CC8A644AB60}"
	DeleteRegKey HKCU "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{DB9E4EAB-2717-499F-8D56-4CC8A644AB60}"
	DeleteRegValue HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Run" "MPlayerForWindows_UpdateReminder"
	DeleteRegValue HKCU "SOFTWARE\Microsoft\Windows\CurrentVersion\Run" "MPlayerForWindows_UpdateReminder"

	; Make sure MPlayer isn't running
	${Do}
		ClearErrors
		Delete "$INSTDIR\MPlayer.exe"
		Delete "$INSTDIR\SMPlayer.exe"
		Delete "$INSTDIR\MPUI.exe"
		${If} ${Errors}
			${IfCmd} MessageBox MB_TOPMOST|MB_ICONEXCLAMATION|MB_OKCANCEL "$(MPLAYER_LANG_STILL_RUNNING)" IDCANCEL ${||} Abort ${|}
		${Else}
			${Break}
		${EndIf}
	${Loop}

	; Clean the install folder
	Delete "$INSTDIR\*.exe"
	Delete "$INSTDIR\*.dll"
	Delete "$INSTDIR\*.ini"
	Delete "$INSTDIR\*.txt"
	Delete "$INSTDIR\*.html"
	Delete "$INSTDIR\*.htm"
	Delete "$INSTDIR\*.ass"
	Delete "$INSTDIR\*.m3u8"
	Delete "$INSTDIR\*.tag"
	
	RMDir /r "$INSTDIR\codecs"
	RMDir /r "$INSTDIR\fonts"
	RMDir /r "$INSTDIR\imageformats"
	RMDir /r "$INSTDIR\legal_stuff"
	RMDir /r "$INSTDIR\locale"
	RMDir /r "$INSTDIR\mplayer"
	RMDir /r "$INSTDIR\platforms"
	RMDir /r "$INSTDIR\shortcuts"
	RMDir /r "$INSTDIR\themes"
	RMDir /r "$INSTDIR\translations"
	
	; Now deal with Virtual Store
	${GetVirtualStorePath} $0 "$INSTDIR"
	${If} ${FileExists} "$0\*.*"
		RMDir /r "$0"
	${EndIf}
SectionEnd

Section "!MPlayer r${MPLAYER_REVISION}" SECID_MPLAYER
	SectionIn 1 2 RO
	${PrintProgress} "$(MPLAYER_LANG_STATUS_INST_MPLAYER)"
	SetOutPath "$INSTDIR"

	; Detect
	${If} ${Silent}
		Call DetectCPUType
		StrCpy $SelectedCPUType $DetectedCPUType
	${EndIf}

	; MPlayer.exe
	${Select} $SelectedCPUType
		${Case} "2"
			DetailPrint "$(MPLAYER_LANG_SELECTED_TYPE): x64 (x86-64)"
			File "Builds\MPlayer-x86_64\MPlayer.exe"
		${Case} "3"
			DetailPrint "$(MPLAYER_LANG_SELECTED_TYPE): core2"
			File "Builds\MPlayer-core2\MPlayer.exe"
		${Case} "4"
			DetailPrint "$(MPLAYER_LANG_SELECTED_TYPE): corei7"
			File "Builds\MPlayer-corei7\MPlayer.exe"
		${Case} "5"
			DetailPrint "$(MPLAYER_LANG_SELECTED_TYPE): k8-sse3"
			File "Builds\MPlayer-k8-sse3\MPlayer.exe"
		${Case} "6"
			DetailPrint "$(MPLAYER_LANG_SELECTED_TYPE): generic"
			File "Builds\MPlayer-generic\MPlayer.exe"
		${CaseElse}
			MessageBox MB_TOPMOST|MB_ICONEXCLAMATION|MB_OK "Internal error: Invalid CPU type selection detected!"
			Abort
	${EndSelect}

	; Utilities
	File ".Compile\Updater.exe"
	File "Resources\AppRegGUI.exe"

	; Other MPlayer-related files
	File "Builds\MPlayer-generic\*.dll"
	${ExtractSubDir} "Builds\MPlayer-generic" "mplayer"
	${ExtractSubDir} "Builds\MPlayer-generic" "fonts"

	; Documents
	SetOutPath "$INSTDIR"
	File "GPL.txt"
	File "/oname=Manual.html" "Builds\MPlayer-generic\MPlayer.man.html"
	File "Docs\Readme.html"
	SetOutPath "$INSTDIR\legal_stuff"
	File "Docs\legal_stuff\*.txt"

	; Write version tag
	${Do}
		ClearErrors
		Delete "$INSTDIR\version.tag"
		${If} ${Errors}
			${IfCmd} MessageBox MB_TOPMOST|MB_ICONEXCLAMATION|MB_OKCANCEL "$(MPLAYER_LANG_TAG_WRITE)" IDCANCEL ${||} Abort ${|}
		${Else}
			${Break}
		${EndIf}
	${Loop}
	WriteINIStr "$INSTDIR\version.tag" "mplayer_version" "build_no" "${MPLAYER_BUILDNO}"
	WriteINIStr "$INSTDIR\version.tag" "mplayer_version" "pkg_date" "${MPLAYER_DATE}"
	SetFileAttributes "$INSTDIR\version.tag" FILE_ATTRIBUTE_READONLY

	; Set file access rights
	${MakePathPublic} "$INSTDIR"
	${MakeFilePublic} "$INSTDIR\mplayer\config"
	${MakeFilePublic} "$INSTDIR\fonts\fonts.conf"
SectionEnd

Section "!MPUI $(MPLAYER_LANG_FRONT_END) v${MPUI_VERSION}" SECID_MPUI
	SectionIn 1 2
	${PrintProgress} "$(MPLAYER_LANG_STATUS_INST_MPUI)"
	
	; Extract files
	SetOutPath "$INSTDIR"
	File "MPUI\MPUI.exe"

	; Extract locales
	SetOutPath "$INSTDIR\locale"
	File "MPUI\locale\*.txt"

	; Set file access rights
	${MakeFilePublic} "$INSTDIR\MPUI.ini"

	; Setup initial config
	ClearErrors
	WriteINIStr "$INSTDIR\MPUI.ini" "MPUI" "Params" "-vo direct3d -lavdopts threads=$DetectedCPUCores"
	WriteINIStr "$INSTDIR\MPUI.ini" "MPUI" "Locale" "$(MPLAYER_LANG_MPUI_DEFAULT_LANGUAGE)"
	${If} ${Errors}
		${IfCmd} MessageBox MB_TOPMOST|MB_ICONSTOP|MB_DEFBUTTON2|MB_OKCANCEL "$(MPLAYER_LANG_CONFIG_MPUI)" IDCANCEL ${||} Abort ${|}
	${EndIf}
SectionEnd

Section "!SMPlayer $(MPLAYER_LANG_FRONT_END) v${SMPLAYER_VERSION}" SECID_SMPLAYER
	SectionIn 1
	${PrintProgress} "$(MPLAYER_LANG_STATUS_INST_SMPLAYER)"

	; SMPlayer program files
	SetOutPath "$INSTDIR"
	File "SMPlayer\smplayer.exe"
	File "SMPlayer\yt-dlp_x86.exe"
	File "SMPlayer\*.dll"

	; Additional SMPlayer files
	${ExtractSubDir} "SMPlayer" "bearer"
	${ExtractSubDir} "SMPlayer" "iconengines"
	${ExtractSubDir} "SMPlayer" "imageformats"
	${ExtractSubDir} "SMPlayer" "platforms"
	${ExtractSubDir} "SMPlayer" "shortcuts"
	${ExtractSubDir} "SMPlayer" "styles"
	${ExtractSubDir} "SMPlayer" "themes"
	${ExtractSubDir} "SMPlayer" "translations"

	; Set file access rights
	${MakeFilePublic} "$INSTDIR\SMPlayer.ini"
	${MakeFilePublic} "$INSTDIR\SMPlayer_files.ini"
	${MakeFilePublic} "$INSTDIR\player_info.ini"
	${MakeFilePublic} "$INSTDIR\playlist.ini"
	${MakeFilePublic} "$INSTDIR\favorites.m3u8"
	${MakeFilePublic} "$INSTDIR\radio.m3u8"
	${MakeFilePublic} "$INSTDIR\tv.m3u8"
	${MakeFilePublic} "$INSTDIR\styles.ass"
	${MakeFilePublic} "$INSTDIR\shortcuts\default.keys"
	
	; Setup initial config
	${StrRep} $0 "$INSTDIR\MPlayer.exe"    "\" "/"
	${StrRep} $1 "$INSTDIR\yt-dlp_x86.exe" "\" "/"
	ClearErrors
	WriteINIStr "$INSTDIR\SMPlayer.ini" "%General"       "autosync"                      "true"
	WriteINIStr "$INSTDIR\SMPlayer.ini" "%General"       "autosync_factor"               "30"
	WriteINIStr "$INSTDIR\SMPlayer.ini" "%General"       "config_version"                "5"
	WriteINIStr "$INSTDIR\SMPlayer.ini" "%General"       "driver\vo"                     "direct3d"
	WriteINIStr "$INSTDIR\SMPlayer.ini" "%General"       "file_settings_method"          "normal"
	WriteINIStr "$INSTDIR\SMPlayer.ini" "%General"       "mplayer_bin"                   "$0"
	WriteINIStr "$INSTDIR\SMPlayer.ini" "%General"       "osd"                           "1"
	WriteINIStr "$INSTDIR\SMPlayer.ini" "%General"       "use_audio_equalizer"           "false"
	WriteINIStr "$INSTDIR\SMPlayer.ini" "%General"       "use_scaletempo"                "0"
	WriteINIStr "$INSTDIR\SMPlayer.ini" "advanced"       "mplayer_additional_options"    ""
	WriteINIStr "$INSTDIR\SMPlayer.ini" "gui"            "gui"                           "DefaultGUI"
	WriteINIStr "$INSTDIR\SMPlayer.ini" "gui"            "iconset"                       "Numix-remix"
	WriteINIStr "$INSTDIR\SMPlayer.ini" "gui"            "qt_style"                      "WindowsVista"
	WriteINIStr "$INSTDIR\SMPlayer.ini" "mplayer_info"   "is_mplayer2"                   "false"
	WriteINIStr "$INSTDIR\SMPlayer.ini" "mplayer_info"   "mplayer_detected_version"      "${MPLAYER_REVISION}"
	WriteINIStr "$INSTDIR\SMPlayer.ini" "mplayer_info"   "mplayer_user_supplied_version" "-1"
	WriteINIStr "$INSTDIR\SMPlayer.ini" "performance"    "frame_drop"                    "true"
	WriteINIStr "$INSTDIR\SMPlayer.ini" "performance"    "priority"                      "1"
	WriteINIStr "$INSTDIR\SMPlayer.ini" "performance"    "threads"                       "$DetectedCPUCores"
	WriteINIStr "$INSTDIR\SMPlayer.ini" "smplayer"       "check_for_new_version"         "false"
	WriteINIStr "$INSTDIR\SMPlayer.ini" "smplayer"       "check_if_upgraded"             "false"
	WriteINIStr "$INSTDIR\SMPlayer.ini" "streaming"      "streaming\youtube\ytdl_bin"    "$1"
	WriteINIStr "$INSTDIR\SMPlayer.ini" "update_checker" "enabled"                       "false"

	${If} ${Errors}
		${IfCmd} MessageBox MB_TOPMOST|MB_ICONSTOP|MB_DEFBUTTON2|MB_OKCANCEL "$(MPLAYER_LANG_CONFIG_SMPLAYER)" IDCANCEL ${||} Abort ${|}
	${EndIf}
SectionEnd

Section "!$(MPLAYER_LANG_BIN_CODECS) (${CODECS_DATE})"
	SectionIn 1
	${If} $SelectedCPUType > 2
		${PrintProgress} "$(MPLAYER_LANG_STATUS_INST_CODECS)"
		SetOutPath "$INSTDIR\codecs"
		File "Codecs\*.0"
		File "Codecs\*.acm"
		File "Codecs\*.ax"
		File "Codecs\*.dll"
		File "Codecs\*.qtx"
		File "Codecs\*.so"
		File "Codecs\*.vwp"
		File "Codecs\*.xa"
	${EndIf}
SectionEnd

Section "-Write Uninstaller"
	${PrintProgress} "$(MPLAYER_LANG_STATUS_MAKEUNINST)"
	WriteUninstaller "$INSTDIR\Uninstall.exe"
SectionEnd

Section "-Create Shortcuts"
	!insertmacro MUI_STARTMENU_WRITE_BEGIN Application
		${PrintProgress} "$(MPLAYER_LANG_STATUS_SHORTCUTS)"
		CreateDirectory "$SMPROGRAMS\$StartMenuFolder"
		
		SetShellVarContext current
		Delete "$SMPROGRAMS\$StartMenuFolder\*.lnk"
		Delete "$SMPROGRAMS\$StartMenuFolder\*.pif"
		Delete "$SMPROGRAMS\$StartMenuFolder\*.url"
		
		SetShellVarContext all
		Delete "$SMPROGRAMS\$StartMenuFolder\*.lnk"
		Delete "$SMPROGRAMS\$StartMenuFolder\*.pif"
		Delete "$SMPROGRAMS\$StartMenuFolder\*.url"

		${If} ${FileExists} "$INSTDIR\MPUI.exe"
			CreateShortCut "$SMPROGRAMS\$StartMenuFolder\MPUI.lnk" "$INSTDIR\MPUI.exe"
			CreateShortCut "$DESKTOP\MPUI.lnk" "$INSTDIR\MPUI.exe"
		${EndIf}
		${If} ${FileExists} "$INSTDIR\SMPlayer.exe"
			CreateShortCut "$SMPROGRAMS\$StartMenuFolder\SMPlayer.lnk" "$INSTDIR\SMPlayer.exe"
			CreateShortCut "$DESKTOP\SMPlayer.lnk" "$INSTDIR\SMPlayer.exe"
		${EndIf}

		CreateShortCut "$SMPROGRAMS\$StartMenuFolder\$(MPLAYER_LANG_SHORTCUT_UPDATE).lnk" "$INSTDIR\Updater.exe" "/L=$LANGUAGE"
		CreateShortCut "$SMPROGRAMS\$StartMenuFolder\$(MPLAYER_LANG_SHORTCUT_README).lnk" "$INSTDIR\Readme.html"
		CreateShortCut "$SMPROGRAMS\$StartMenuFolder\$(MPLAYER_LANG_SHORTCUT_MANUAL).lnk" "$INSTDIR\Manual.html"

		${If} ${AtLeastWinVista}
			CreateShortCut "$SMPROGRAMS\$StartMenuFolder\$(MPLAYER_LANG_SHORTCUT_APPREG).lnk" "$INSTDIR\AppRegGUI.exe"
		${EndIf}
		
		${CreateWebLink} "$SMPROGRAMS\$StartMenuFolder\$(MPLAYER_LANG_SHORTCUT_SITE_MULDERS).url" "http://muldersoft.com/"
		${CreateWebLink} "$SMPROGRAMS\$StartMenuFolder\$(MPLAYER_LANG_SHORTCUT_SITE_MPWIN32).url" "http://oss.netfarm.it/mplayer-win32.php"
		${CreateWebLink} "$SMPROGRAMS\$StartMenuFolder\$(MPLAYER_LANG_SHORTCUT_SITE_MPLAYER).url" "http://www.mplayerhq.hu/"

		${If} ${FileExists} "$SMPROGRAMS\$StartMenuFolder\SMPlayer.lnk"
			${StdUtils.InvokeShellVerb} $R1 "$SMPROGRAMS\$StartMenuFolder" "SMPlayer.lnk" ${StdUtils.Const.ShellVerb.PinToTaskbar}
			DetailPrint 'Pin: "$SMPROGRAMS\$StartMenuFolder\SMPlayer.lnk" -> $R1'
		${EndIf}
	!insertmacro MUI_STARTMENU_WRITE_END
SectionEnd

Section "-ApplyTweaks"
	${PrintProgress} "$(MPLAYER_LANG_STATUS_TWEAKS)"
	DetailPrint "$(MPLAYER_LANG_APPLYING_TWEAKS)"

	IntOp $0 $SelectedTweaks & 1
	${If} $0 <> 0
	${AndIf} ${FileExists} "$INSTDIR\SMPlayer.ini"
		DetailPrint "SMPlayer: Enable tweak 'gui=SkinGUI'"
		WriteINIStr "$INSTDIR\SMPlayer.ini" "gui" "gui"      "SkinGUI"
		WriteINIStr "$INSTDIR\SMPlayer.ini" "gui" "qt_style" "Fusion"
		WriteINIStr "$INSTDIR\SMPlayer.ini" "gui" "iconset"  "Modern"
	${EndIf}

	IntOp $0 $SelectedTweaks & 2
	${If} $0 <> 0
	${AndIf} ${FileExists} "$INSTDIR\MPUI.ini"
		DetailPrint "MPUI: Enable tweak '-vo gl'"
		WriteINIStr "$INSTDIR\MPUI.ini" "MPUI" "Params" "-vo gl -lavdopts threads=$DetectedCPUCores"
	${EndIf}
	${If} $0 <> 0
	${AndIf} ${FileExists} "$INSTDIR\SMPlayer.ini"
		DetailPrint "SMPlayer: Enable tweak '-vo gl'"
		WriteINIStr "$INSTDIR\SMPlayer.ini" "%General" "driver\vo" "gl"
	${EndIf}

	IntOp $0 $SelectedTweaks & 4
	${If} $0 <> 0
	${AndIf} ${FileExists} "$INSTDIR\MPUI.ini"
		DetailPrint "MPUI: Enable tweak '-af volnorm=2'"
		ReadINIStr $1 "$INSTDIR\MPUI.ini" "MPUI" "Params"
		WriteINIStr "$INSTDIR\MPUI.ini" "MPUI" "Params" "$1 -af volnorm=2"
	${EndIf}
	${If} $0 <> 0
	${AndIf} ${FileExists} "$INSTDIR\SMPlayer.ini"
		DetailPrint "SMPlayer: Enable tweak 'initial_volnorm=true'"
		WriteINIStr "$INSTDIR\SMPlayer.ini" "defaults" "initial_volnorm" "true"
	${EndIf}
SectionEnd

Section "$(MPLAYER_LANG_COMPRESS_FILES)"
	SectionIn 1 2
	${PrintProgress} "$(MPLAYER_LANG_STATUS_INST_COMPRESS)"
	
	File "/oname=$PLUGINSDIR\UPX.exe" "${UPX_PATH}\UPX.exe"
	
	${PackAll} "$INSTDIR" "*.exe"
	${PackAll} "$INSTDIR" "*.dll"
	${PackAll} "$INSTDIR\codecs" "*.acm"
	${PackAll} "$INSTDIR\codecs" "*.ax"
	${PackAll} "$INSTDIR\codecs" "*.dll"
	${PackAll} "$INSTDIR\codecs" "*.qtx"

	Delete "$PLUGINSDIR\UPX.exe"
SectionEnd

Section "-Update Font Cache"
	${PrintProgress} "$(MPLAYER_LANG_STATUS_INST_FONTCACHE)"
	
	SetShellVarContext current
	Delete "$APPDATA\fontconfig\cache\*.*"
	Delete "$LOCALAPPDATA\fontconfig\cache\*.*"
	
	SetShellVarContext all
	Delete "$APPDATA\fontconfig\cache\*.*"
	Delete "$LOCALAPPDATA\fontconfig\cache\*.*"

	File "/oname=$PLUGINSDIR\Sample.avi" "Resources\Sample.avi"
	DetailPrint "$(MPLAYER_LANG_UPDATING_FONTCACHE)"
	NsExec::Exec '"$INSTDIR\MPlayer.exe" -fontconfig -ass -vo null -ao null "$PLUGINSDIR\Sample.avi"'
	Delete "Resources\Sample.avi"
SectionEnd

Section "-Update Registry"
	${PrintProgress} "$(MPLAYER_LANG_STATUS_REGISTRY)"
	DetailPrint "$(MPLAYER_LANG_WRITING_REGISTRY)"

	; Clean up
	DeleteRegKey HKLM "${MPlayerRegPath}"
	DeleteRegKey HKCU "${MPlayerRegPath}"
	DeleteRegValue HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Run" "MPlayerForWindows_AutoUpdateV2"
	DeleteRegValue HKCU "SOFTWARE\Microsoft\Windows\CurrentVersion\Run" "MPlayerForWindows_AutoUpdateV2"

	; Uninstaller
	WriteRegStr HKLM "${MPlayerRegPath}" "InstallLocation" "$INSTDIR"
	WriteRegStr HKLM "${MPlayerRegPath}" "UninstallString" '"$INSTDIR\Uninstall.exe"'
	WriteRegStr HKLM "${MPlayerRegPath}" "DisplayName" "$(MPLAYER_LANG_MPLAYER_WIN32)"
	WriteRegStr HKLM "${MPlayerRegPath}" "DisplayIcon" "$INSTDIR\MPlayer.exe,0"
	WriteRegStr HKLM "${MPlayerRegPath}" "DisplayVersion" "${MPLAYER_DATE}"
	WriteRegStr HKLM "${MPlayerRegPath}" "URLInfoAbout" "http://muldersoft.com/"
	WriteRegStr HKLM "${MPlayerRegPath}" "URLUpdateInfo" "http://muldersoft.com/"
	WriteRegStr HKLM "${MPlayerRegPath}" "Publisher" "The MPlayer Team"
	WriteRegDWORD HKLM "${MPlayerRegPath}" "NoModify" 1
	WriteRegDWORD HKLM "${MPlayerRegPath}" "NoRepair" 1

	; Shell
	DeleteRegKey HKCR "MPlayerForWindowsV2.File"
	DeleteRegKey HKLM "SOFTWARE\Classes\MPlayerForWindowsV2.File"
	DeleteRegKey HKCU "SOFTWARE\Classes\MPlayerForWindowsV2.File"
	${If} ${FileExists} "$INSTDIR\MPUI.exe"
		WriteRegStr HKLM "SOFTWARE\Classes\MPlayerForWindowsV2.File\shell\open\command" "" '"$INSTDIR\MPUI.exe" "%1"'
		WriteRegStr HKLM "SOFTWARE\Classes\MPlayerForWindowsV2.File\DefaultIcon" "" "$INSTDIR\MPUI.exe,0"
	${EndIf}
	${If} ${FileExists} "$INSTDIR\SMPlayer.exe"
		WriteRegStr HKLM "SOFTWARE\Classes\MPlayerForWindowsV2.File\shell\open\command" "" '"$INSTDIR\SMPlayer.exe" "%1"'
		WriteRegStr HKLM "SOFTWARE\Classes\MPlayerForWindowsV2.File\DefaultIcon" "" "$INSTDIR\SMPlayer.exe,1"
	${EndIf}

	; Register App
	DeleteRegValue HKCU "SOFTWARE\RegisteredApplications" "MPlayerForWindowsV2"
	WriteRegStr HKLM "SOFTWARE\RegisteredApplications" "MPlayerForWindowsV2" "${MPlayerRegPath}\Capabilities"

	; Capabilities
	WriteRegStr HKLM "${MPlayerRegPath}\Capabilities" "ApplicationName" "$(MPLAYER_LANG_MPLAYER_WIN32)"
	WriteRegStr HKLM "${MPlayerRegPath}\Capabilities" "ApplicationDescription" "$(MPLAYER_LANG_MPLAYER_WIN32)"
	WriteRegStr HKLM "${MPlayerRegPath}\Capabilities" "ApplicationDescription" "$(MPLAYER_LANG_MPLAYER_WIN32)"

	; File Associations
	${RegisterFileExtCapability} "256"
	${RegisterFileExtCapability} "3GP"
	${RegisterFileExtCapability} "AAC"
	${RegisterFileExtCapability} "ASF"
	${RegisterFileExtCapability} "AVI"
	${RegisterFileExtCapability} "BIN"
	${RegisterFileExtCapability} "DAT"
	${RegisterFileExtCapability} "DIVX"
	${RegisterFileExtCapability} "EVO"
	${RegisterFileExtCapability} "FLV"
	${RegisterFileExtCapability} "M2V"
	${RegisterFileExtCapability} "M2TS"
	${RegisterFileExtCapability} "M4A"
	${RegisterFileExtCapability} "MKA"
	${RegisterFileExtCapability} "MKV"
	${RegisterFileExtCapability} "MOV"
	${RegisterFileExtCapability} "MP2"
	${RegisterFileExtCapability} "MP3"
	${RegisterFileExtCapability} "MP4"
	${RegisterFileExtCapability} "MPEG"
	${RegisterFileExtCapability} "MPG"
	${RegisterFileExtCapability} "MPV"
	${RegisterFileExtCapability} "NSV"
	${RegisterFileExtCapability} "OGG"
	${RegisterFileExtCapability} "OGM"
	${RegisterFileExtCapability} "RM"
	${RegisterFileExtCapability} "RMVB"
	${RegisterFileExtCapability} "TS"
	${RegisterFileExtCapability} "VOB"
	${RegisterFileExtCapability} "WAV"
	${RegisterFileExtCapability} "WEBM"
	${RegisterFileExtCapability} "WMV"

	; Reset auto update interval
	DeleteRegValue HKLM "${MPlayerRegPath}" "LastUpdateCheck"
	DeleteRegValue HKCU "${MPlayerRegPath}" "LastUpdateCheck"
SectionEnd

Section "$(MPLAYER_LANG_INST_AUTOUPDATE)" SECID_AUTOUPDATE
	SectionIn 1 2
	DetailPrint "$(MPLAYER_LANG_SCHEDULE_UPDATE)"
	WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Run" "MPlayerForWindows_AutoUpdateV2" '"$INSTDIR\Updater.exe" /L=$LANGUAGE /AutoCheck'
SectionEnd

Section "-Protect Files"
	SetFileAttributes "$INSTDIR\AppRegGUI.exe"       FILE_ATTRIBUTE_READONLY
	SetFileAttributes "$INSTDIR\mplayer.exe"         FILE_ATTRIBUTE_READONLY
	SetFileAttributes "$INSTDIR\MPUI.exe"            FILE_ATTRIBUTE_READONLY
	SetFileAttributes "$INSTDIR\smplayer.exe"        FILE_ATTRIBUTE_READONLY
	SetFileAttributes "$INSTDIR\Updater.exe"         FILE_ATTRIBUTE_READONLY
	
	SetFileAttributes "$INSTDIR\dsnative.dll"        FILE_ATTRIBUTE_READONLY
	SetFileAttributes "$INSTDIR\libeay32.dll"        FILE_ATTRIBUTE_READONLY
	SetFileAttributes "$INSTDIR\libgcc_s_dw2-1.dll"  FILE_ATTRIBUTE_READONLY
	SetFileAttributes "$INSTDIR\libstdc++-6.dll"     FILE_ATTRIBUTE_READONLY
	SetFileAttributes "$INSTDIR\libwinpthread-1.dll" FILE_ATTRIBUTE_READONLY
	SetFileAttributes "$INSTDIR\Qt5Core.dll"         FILE_ATTRIBUTE_READONLY
	SetFileAttributes "$INSTDIR\Qt5Gui.dll"          FILE_ATTRIBUTE_READONLY
	SetFileAttributes "$INSTDIR\Qt5Network.dll"      FILE_ATTRIBUTE_READONLY
	SetFileAttributes "$INSTDIR\Qt5Script.dll"       FILE_ATTRIBUTE_READONLY
	SetFileAttributes "$INSTDIR\Qt5Widgets.dll"      FILE_ATTRIBUTE_READONLY
	SetFileAttributes "$INSTDIR\Qt5Xml.dll"          FILE_ATTRIBUTE_READONLY
	SetFileAttributes "$INSTDIR\ssleay32.dll"        FILE_ATTRIBUTE_READONLY
	SetFileAttributes "$INSTDIR\zlib1.dll"           FILE_ATTRIBUTE_READONLY
SectionEnd

Section "-Finished"
	${PrintStatus} "$(MUI_TEXT_FINISH_TITLE)"
SectionEnd


;--------------------------------------------------------------------------------
; UN-INSTALL SECTIONS
;--------------------------------------------------------------------------------

Section "Uninstall"
	SetOutPath "$TEMP"
	${PrintProgress} "$(MPLAYER_LANG_STATUS_UNINSTALL)"

	; Validate uninstall path
	${IfThen} "$INSTDIR" == "" ${|} Abort ${|}
	StrCpy $0 "$INSTDIR" "" -2
	${IfThen} $0 == ":\" ${|} Abort ${|}

	; Startmenu
	!insertmacro MUI_STARTMENU_GETFOLDER Application $StartMenuFolder
	${IfNot} "$StartMenuFolder" == ""
		SetShellVarContext current
		${If} ${FileExists} "$SMPROGRAMS\$StartMenuFolder\SMPlayer.lnk"
			${StdUtils.InvokeShellVerb} $R1 "$SMPROGRAMS\$StartMenuFolder" "SMPlayer.lnk" ${StdUtils.Const.ShellVerb.UnpinFromTaskbar}
			DetailPrint 'Unpin: "$SMPROGRAMS\$StartMenuFolder\SMPlayer.lnk" -> $R1'
		${EndIf}
		${If} ${FileExists} "$SMPROGRAMS\$StartMenuFolder\*.*"
			Delete /REBOOTOK "$SMPROGRAMS\$StartMenuFolder\*.lnk"
			Delete /REBOOTOK "$SMPROGRAMS\$StartMenuFolder\*.url"
			Delete /REBOOTOK "$SMPROGRAMS\$StartMenuFolder\*.pif"
			RMDir "$SMPROGRAMS\$StartMenuFolder"
		${EndIf}
		SetShellVarContext all
		${If} ${FileExists} "$SMPROGRAMS\$StartMenuFolder\SMPlayer.lnk"
			${StdUtils.InvokeShellVerb} $R1 "$SMPROGRAMS\$StartMenuFolder" "SMPlayer.lnk" ${StdUtils.Const.ShellVerb.UnpinFromTaskbar}
			DetailPrint 'Unpin: "$SMPROGRAMS\$StartMenuFolder\SMPlayer.lnk" -> $R1'
		${EndIf}
		${If} ${FileExists} "$SMPROGRAMS\$StartMenuFolder\*.*"
			Delete /REBOOTOK "$SMPROGRAMS\$StartMenuFolder\*.lnk"
			Delete /REBOOTOK "$SMPROGRAMS\$StartMenuFolder\*.url"
			Delete /REBOOTOK "$SMPROGRAMS\$StartMenuFolder\*.pif"
			RMDir "$SMPROGRAMS\$StartMenuFolder"
		${EndIf}
	${EndIf}

	; Desktop icons
	Delete /REBOOTOK "$DESKTOP\MPUI.lnk"
	Delete /REBOOTOK "$DESKTOP\SMPlayer.lnk"
	
	; Files
	RMDir /r "$INSTDIR"

	; Virtual Store
	${GetVirtualStorePath} $0 "$INSTDIR"
	${If} ${FileExists} "$0\*.*"
		RMDir /r "$0"
	${EndIf}

	; Registry Keys
	DeleteRegKey HKLM "${MPlayerRegPath}"
	DeleteRegKey HKCU "${MPlayerRegPath}"
	DeleteRegValue HKLM "SOFTWARE\RegisteredApplications" "MPlayerForWindowsV2"
	DeleteRegValue HKCU "SOFTWARE\RegisteredApplications" "MPlayerForWindowsV2"

	; Auto Update
	DeleteRegValue HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Run" "MPlayerForWindows_AutoUpdateV2"
	DeleteRegValue HKCU "SOFTWARE\Microsoft\Windows\CurrentVersion\Run" "MPlayerForWindows_AutoUpdateV2"
	
	; Shell
	DeleteRegKey HKCR "MPlayerForWindowsV2.File"
	DeleteRegKey HKLM "SOFTWARE\Classes\MPlayerForWindowsV2.File"
	DeleteRegKey HKCU "SOFTWARE\Classes\MPlayerForWindowsV2.File"

	${PrintStatus} "$(MUI_UNTEXT_FINISH_TITLE)"
SectionEnd


;--------------------------------------------------------------------------------
; SECTION SELECTION CHANGED
;--------------------------------------------------------------------------------

Function .onSelChange
	${IfNot} ${SectionIsSelected} ${SECID_MPUI}
	${AndIfNot} ${SectionIsSelected} ${SECID_SMPLAYER}
		MessageBox MB_TOPMOST|MB_ICONEXCLAMATION "$(MPLAYER_LANG_SELCHANGE)"
		SectionGetFlags ${SECID_MPUI} $0
		IntOp $0 $0 | ${SF_SELECTED}
		SectionSetFlags ${SECID_MPUI} $0
	${EndIf}

	${IfNot} ${SectionIsSelected} ${SECID_AUTOUPDATE}
		StrCpy $0 "nope"
		${IfCmd} MessageBox MB_TOPMOST|MB_ICONEXCLAMATION|MB_YESNO|MB_DEFBUTTON2 "$(MPLAYER_LANG_SEL_AUTOUPDATE)" IDNO ${||} StrCpy $0 "ok" ${|}
		${If} "$0" == "ok"
			SectionGetFlags ${SECID_AUTOUPDATE} $0
			IntOp $0 $0 | ${SF_SELECTED}
			SectionSetFlags ${SECID_AUTOUPDATE} $0
		${EndIf}
	${EndIf}
FunctionEnd


;--------------------------------------------------------------------------------
; LOCKED-LIST PLUGIN
;--------------------------------------------------------------------------------

!macro LockedListPage_Function
	!insertmacro MUI_HEADER_TEXT "$(MPLAYER_LANG_LOCKEDLIST_HEADER)" "$(MPLAYER_LANG_LOCKEDLIST_TEXT)"
	
	InitPluginsDir
	File /oname=$PLUGINSDIR\LockedList64.dll `${NSISDIR}\Plugins\LockedList64.dll`
	
	LockedList::AddModule "\MPlayer.exe"
	LockedList::AddModule "\SMPlayer.exe"
	LockedList::AddModule "\MPUI.exe"
	LockedList::AddModule "${NSISDIR}\Qt5Core.dll"
	
	LockedList::Dialog /autonext /ignore "$(MPLAYER_LANG_IGNORE)" /heading "$(MPLAYER_LANG_LOCKEDLIST_HEADING)" /noprograms "$(MPLAYER_LANG_LOCKEDLIST_NOPROG)" /searching  "$(MPLAYER_LANG_LOCKEDLIST_SEARCH)" /colheadings "$(MPLAYER_LANG_LOCKEDLIST_COLHDR1)" "$(MPLAYER_LANG_LOCKEDLIST_COLHDR2)"
	Pop $R0
!macroend

Function LockedListPage_Show
	!insertmacro LockedListPage_Function
FunctionEnd

Function un.LockedListPage_Show
	!insertmacro LockedListPage_Function
FunctionEnd


;--------------------------------------------------------------------------------
; CUSTOME PAGE: CPU SELECTOR
;--------------------------------------------------------------------------------

Function SelectCPUPage_Show
	; Detect CPU type, if not detected yet
	${If} $DetectedCPUType < 2
	${OrIf} $DetectedCPUType > 6
		Call DetectCPUType
		!insertmacro INSTALLOPTIONS_READ $0 "Page_CPU.ini" "Field $DetectedCPUType" "Text"
		!insertmacro INSTALLOPTIONS_WRITE   "Page_CPU.ini" "Field $DetectedCPUType" "Text" "$0 <-- recommended"
	${EndIf}

	; Make sure the current selection is valid
	${IfThen} $SelectedCPUType < 2 ${|} StrCpy $SelectedCPUType $DetectedCPUType ${|}
	${IfThen} $SelectedCPUType > 6 ${|} StrCpy $SelectedCPUType $DetectedCPUType ${|}

	; Disable 64-Bit build on the 32-Bit system
	${IfNot} ${RunningX64}
		!insertmacro INSTALLOPTIONS_WRITE "Page_CPU.ini" "Field 2" "Flags" "DISABLED"
		${IfThen} $SelectedCPUType < 3 ${|} StrCpy $SelectedCPUType 3 ${|}
	${EndIf}

	; Translate
	!insertmacro INSTALLOPTIONS_WRITE "Page_CPU.ini" "Field 1" "Text" "$(MPLAYER_LANG_SELECT_CPU_TYPE)"
	!insertmacro INSTALLOPTIONS_WRITE "Page_CPU.ini" "Field 7" "Text" "$(MPLAYER_LANG_SELECT_CPU_HINT)"
	
	; Apply current selection to dialog
	${For} $0 2 6
		${If} $0 == $SelectedCPUType
			!insertmacro INSTALLOPTIONS_WRITE "Page_CPU.ini" "Field $0" "State" "1"
		${Else}
			!insertmacro INSTALLOPTIONS_WRITE "Page_CPU.ini" "Field $0" "State" "0"
		${EndIf}
	${Next}

	; Display dialog
	!insertmacro MUI_HEADER_TEXT "$(MPLAYER_LANG_SELECT_CPU_HEAD)" "$(MPLAYER_LANG_SELECT_CPU_TEXT)"
	!insertmacro INSTALLOPTIONS_DISPLAY "Page_CPU.ini"

	; Read new selection from dialog
	StrCpy $SelectedCPUType 0
	${For} $0 2 6
		!insertmacro INSTALLOPTIONS_READ $1 "Page_CPU.ini" "Field $0" "State"
		${IfThen} $1 == 1 ${|} StrCpy $SelectedCPUType $0 ${|}
	${Next}
FunctionEnd

Function SelectCPUPage_Validate
	; Read new selection from dialog
	StrCpy $2 0
	${For} $0 2 6
		!insertmacro INSTALLOPTIONS_READ $1 "Page_CPU.ini" "Field $0" "State"
		${IfThen} $1 == 1 ${|} StrCpy $2 $0 ${|}
	${Next}

	; Validate selection
	${If} $2 < 2
	${OrIf} $2 > 6
		MessageBox MB_ICONSTOP "Oups, invalid selection detected!"
		Abort
	${EndIf}

	; Make sure we cannot select 64-Bit on the 32-Bit system
	${IfNot} ${RunningX64}
	${AndIf} $2 < 3
		MessageBox MB_ICONSTOP "Oups, invalid selection detected!"
		Abort
	${EndIf}
FunctionEnd

Function DetectCPUType
	StrCpy $DetectedCPUType 6 ;generic
	StrCpy $DetectedCPUCores 2

	${IfNot} ${Silent}
		Banner::show /NOUNLOAD "$(MPLAYER_LANG_DETECTING)"
	${EndIf}

	${CPUFeatures.GetCount} $0
	${IfNot} $0 == "error"
		StrCpy $DetectedCPUCores $0
	${EndIf}

	; Debug Code
	!ifdef CPU_DETECT_DEBUG
		${CPUFeatures.GetVendor} $0
		${CPUFeatures.CheckFeature} "MMX1"   $1
		${CPUFeatures.CheckFeature} "3DNOW"  $2
		${CPUFeatures.CheckFeature} "SSE3"   $3
		${CPUFeatures.CheckFeature} "SSSE3"  $4
		${CPUFeatures.CheckFeature} "SSE4.2" $5
		${CPUFeatures.CheckFeature} "AVX1"   $6
		${CPUFeatures.CheckFeature} "FMA4"   $7
		StrCpy $9 `Vendor = $0`
		StrCpy $9 `$9$\n"MMX1" = $1`
		StrCpy $9 `$9$\n"3DNOW" = $2`
		StrCpy $9 `$9$\n"SSE3" = $3`
		StrCpy $9 `$9$\n"SSSE3" = $4`
		StrCpy $9 `$9$\n"SSE4.2" = $5`
		StrCpy $9 `$9$\n"AVX1" = $6`
		StrCpy $9 `$9$\n"FMA4" = $7`
		MessageBox MB_TOPMOST `$9`
	!endif

	; Make sure we have at least MMX
	${IfNot} ${CPUSupports} "MMX1"
		Banner::destroy
		Return
	${EndIf}

	${If} ${RunningX64}
		; On 64-Bit system we prefer the x64 build
		StrCpy $DetectedCPUType 2
	${Else}
		; Select the "best" model for Intel's
		${If} ${CPUIsIntel}
			; Core2 (SSE3 + SSSE3)
			${If} ${CPUSupportsAll} "SSE3,SSSE3"
				StrCpy $DetectedCPUType 3
			${EndIf}
			; Nehalem (SSE3 + SSSE3 + SSE4.2)
			${If} ${CPUSupportsAll} "SSE3,SSSE3,SSE4.2"
				StrCpy $DetectedCPUType 4
			${EndIf}
		${EndIf}
		; Select the "best" model for AMD's
		${If} ${CPUIsAMD}
			; K8+SSE3 (3DNow! + SSE3)
			${If} ${CPUSupportsAll} "3DNOW,SSE3"
				StrCpy $DetectedCPUType 5
			${EndIf}
		${EndIf}
	${EndIf}

	Banner::destroy
FunctionEnd


;--------------------------------------------------------------------------------
; CUSTOME PAGE: TWEAKS
;--------------------------------------------------------------------------------

Function SetTweaksPage_Show
	; Apply current selection to dialog
	StrCpy $0 1
	${For} $1 2 4
		IntOp $2 $0 & $SelectedTweaks
		${If} $2 <> 0
			!insertmacro INSTALLOPTIONS_WRITE "Page_Tweaks.ini" "Field $1" "State" "1"
		${Else}
			!insertmacro INSTALLOPTIONS_WRITE "Page_Tweaks.ini" "Field $1" "State" "0"
		${EndIf}
		IntOp $0 $0 << 1
	${Next}
	
	; Translate
	!insertmacro INSTALLOPTIONS_WRITE "Page_Tweaks.ini" "Field 1" "Text" "$(MPLAYER_LANG_TWEAKS_HINT)"
	!insertmacro INSTALLOPTIONS_WRITE "Page_Tweaks.ini" "Field 2" "Text" "$(MPLAYER_LANG_TWEAKS_SKINNEDUI)"
	!insertmacro INSTALLOPTIONS_WRITE "Page_Tweaks.ini" "Field 3" "Text" "$(MPLAYER_LANG_TWEAKS_OPENGL)"
	!insertmacro INSTALLOPTIONS_WRITE "Page_Tweaks.ini" "Field 4" "Text" "$(MPLAYER_LANG_TWEAKS_VOLNORM)"

	; Display dialog
	!insertmacro MUI_HEADER_TEXT "$(MPLAYER_LANG_TWEAKS_HEAD)" "$(MPLAYER_LANG_TWEAKS_TEXT)"
	!insertmacro INSTALLOPTIONS_DISPLAY "Page_Tweaks.ini"

	; Read new selection from dialog
	StrCpy $0 1
	StrCpy $SelectedTweaks 0
	${For} $1 2 4
		!insertmacro INSTALLOPTIONS_READ $2 "Page_Tweaks.ini" "Field $1" "State"
		${IfThen} $2 = 1 ${|} IntOp $SelectedTweaks $SelectedTweaks | $0 ${|}
		IntOp $0 $0 << 1
	${Next}
FunctionEnd


;--------------------------------------------------------------------------------
; CHECK FOR UPDATE MODE
;--------------------------------------------------------------------------------

!macro SetControlEnabled item_id enable
	FindWindow $0 "#32770" "" $HWNDPARENT
	${IfNot} $0 == 0
		GetDlgItem $1 $0 ${item_id}
		EnableWindow $1 ${enable}
	${EndIf}
!macroend

!macro SkipToNextPage
	GetDlgItem $0 $HWNDPARENT 1
	System::Call "User32::PostMessage(i $HWNDPARENT, i ${WM_COMMAND}, i 1, i $R0)"
!macroend

!macro EnablePathEditable flag show_msg
	!insertmacro SetControlEnabled 1019 ${flag}
	!insertmacro SetControlEnabled 1001 ${flag}
	${IfNot} $NotUpdateInstall = ${flag}
		!if ${show_msg} == 1
			MessageBox MB_OK|MB_ICONINFORMATION "$(MPLAYER_LANG_FORCE_UPDATE)" /SD IDOK
		!endif
		StrCpy $NotUpdateInstall ${flag}
		!insertmacro SkipToNextPage
	${EndIf}
!macroend

Function CheckForUpdate
	${StdUtils.TestParameter} $0 "Update"
	${If} "$0" == "true"
		!insertmacro EnablePathEditable 0 0
		Return
	${EndIf}
	
	${If} ${FileExists} "$INSTDIR\MPlayer.exe"
		${If} $NotUpdateInstall = 1
		${AndIf} ${FileExists} "$INSTDIR\version.tag"
			ReadINIStr $0 "$INSTDIR\version.tag" "mplayer_version" "build_no"
			${If} $0 > ${MPLAYER_BUILDNO}
				MessageBox MB_OK|MB_ICONEXCLAMATION "$(MPLAYER_LANG_CAN_NOT_UPDATE)"
				Quit
			${EndIf}
			${If} $0 = ${MPLAYER_BUILDNO}
				${IfCmd} MessageBox MB_YESNO|MB_ICONEXCLAMATION "$(MPLAYER_LANG_CONFIRM_UPDATE)" /SD IDYES IDNO ${||} Quit ${|}
			${EndIf}
		${EndIf}
		!insertmacro EnablePathEditable 0 1
		Return
	${EndIf}

	!insertmacro EnablePathEditable 1 0
FunctionEnd


;--------------------------------------------------------------------------------
; FINISHED
;--------------------------------------------------------------------------------

Function RunAppFunction
	!insertmacro DisableNextButton $R0
	${If} ${FileExists} "$INSTDIR\SMPlayer.exe"
		${StdUtils.ExecShellAsUser} $R0 "$INSTDIR\SMPlayer.exe" "open" "https://www.youtube.com/watch?v=SkVqJ1SGeL0"
	${Else}
		${StdUtils.ExecShellAsUser} $R0 "$INSTDIR\MPUI.exe" "open" "http://www.caminandes.com/download/03_caminandes_llamigos_1080p.mp4"
	${EndIf}
FunctionEnd

Function ShowReadmeFunction
	!insertmacro DisableNextButton $R0
	${StdUtils.ExecShellAsUser} $R0 "$INSTDIR\Readme.html" "open" ""
FunctionEnd

Function .onInstSuccess
	${StdUtils.ExecShellAsUser} $R0 "$SMPROGRAMS\$StartMenuFolder" "explore" ""
FunctionEnd


### EOF ###
