; ///////////////////////////////////////////////////////////////////////////////
; // MPlayer for Windows - Install Script
; // Copyright (C) 2004-2020 LoRd_MuldeR <MuldeR2@GMX.de>
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


!define PrintProgress "!insertmacro _PrintProgress"
!define PrintStatus "!insertmacro _PrintStatus"

!macro _PrintProgress Text
	SetDetailsPrint textonly
	DetailPrint '${Text}, $(MPLAYER_LANG_STATUS_WAIT)...'
	SetDetailsPrint listonly
	DetailPrint '--- ${Text} ---'
	Sleep 333
!macroend

!macro _PrintStatus Text
	SetDetailsPrint textonly
	DetailPrint '${Text}.'
	SetDetailsPrint listonly
	DetailPrint '--- ${Text} ---'
	Sleep 333
!macroend

; ----------------------------------------------------------------------------

!define ExtractSubDir "!insertmacro _ExtractSubDir"

!macro _ExtractSubDir BaseDir SubDir
	SetOutPath "$INSTDIR\${SubDir}"
	File /r "${BaseDir}\${SubDir}\*.*"
!macroend

; ----------------------------------------------------------------------------

!define CreateWebLink "!insertmacro _CreateWebLink"

!macro _CreateWebLink ShortcutFile TargetURL
	Push $0
	Push $1
	StrCpy $0 "${ShortcutFile}"
	StrCpy $1 "${TargetURL}"
	Call _Imp_CreateWebLink
	Pop $1
	Pop $0
!macroend

Function _Imp_CreateWebLink
	FlushINI "$0"
	SetFileAttributes "$0" FILE_ATTRIBUTE_NORMAL
	DeleteINISec "$0" "DEFAULT"
	DeleteINISec "$0" "InternetShortcut"
	WriteINIStr "$0" "DEFAULT" "BASEURL" "$1"
	WriteINIStr "$0" "InternetShortcut" "ORIGURL" "$1"
	WriteINIStr "$0" "InternetShortcut" "URL" "$1"
	WriteINIStr "$0" "InternetShortcut" "IconFile" "$SYSDIR\SHELL32.dll"
	WriteINIStr "$0" "InternetShortcut" "IconIndex" "150"
	FlushINI "$0"
	SetFileAttributes "$0" FILE_ATTRIBUTE_READONLY
FunctionEnd

!macro DisableNextButton TmpVar
	GetDlgItem ${TmpVar} $HWNDPARENT 1
	EnableWindow ${TmpVar} 0
!macroend

; ----------------------------------------------------------------------------

!define PackAll "!insertmacro _PackAll"

!macro _PackAll path filter
	Push "${filter}"
	Push "${path}"
	Call _Imp_PackAll
!macroend

Function _Imp_PackAll
	Exch $0
	Exch
	Exch $1
	Push $2

	ClearErrors
	FindFirst $1 $2 "$0\$1"

	${IfNot} ${Errors}
		${DoUntil} ${Errors}
			${IfNot} "$2" == "Uninstall.exe"
			${AndIfNot} "$2" == "Updater.exe"
				DetailPrint "$(MPLAYER_LANG_COMPRESSING): $2"
				NsExec::Exec '"$PLUGINSDIR\UPX.exe" --compress-icons=0 "$0\$2"'
			${EndIf}
			FindNext $1 $2
		${Loop}
		FindClose $1
	${EndIf}

	Pop $2
	Pop $1
	Pop $0
FunctionEnd
  
; ----------------------------------------------------------------------------
  
!define MakeFilePublic "!insertmacro _MakeFilePublic"
!define MakePathPublic "!insertmacro _MakePathPublic"

!macro _MakeFilePublic filename
	${IfNot} ${FileExists} "${filename}"
		Push $R0
		FileOpen $R0 "${filename}" w
		FileClose $R0
		Pop $R0
	${EndIf}
	AccessControl::GrantOnFile "${filename}" "(BU)" "FullAccess"
!macroend

!macro _MakePathPublic path
	AccessControl::GrantOnFile "${path}" "(BU)" "GenericRead + GenericWrite"
!macroend

; ----------------------------------------------------------------------------

!define GetVirtualStorePath "!insertmacro _GetVirtualStorePath"

!macro _GetVirtualStorePath out path
	StrCpy ${out} '${path}' "" 3
	StrCpy ${out} '$LOCALAPPDATA\VirtualStore\${out}'
!macroend

; ----------------------------------------------------------------------------

!define RegisterFileExtCapability "!insertmacro _RegisterFileExtCapability"

!macro _RegisterFileExtCapability ext
	WriteRegStr HKLM "${MPlayerRegPath}\Capabilities\FileAssociations" ".${ext}"  "MPlayerForWindowsV2.File"
!macroend
