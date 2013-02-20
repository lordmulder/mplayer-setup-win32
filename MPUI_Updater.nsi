; ///////////////////////////////////////////////////////////////////////////////
; // MPlayer for Windows - Install Script
; // Copyright (C) 2004-2013 LoRd_MuldeR <MuldeR2@GMX.de>
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


!ifndef MPLAYER_DATE
  !error "MPLAYER_DATE is not defined !!!"
!endif

!ifndef MPLAYER_OUTFILE
  !error "MPLAYER_OUTFILE is not defined !!!"
!endif

!ifndef UPX_PATH
  !error "UPX_PATH is not defined !!!"
!endif

; ----------------------------------------------------------------------------

!define /date BUILD_DATE "%Y%m%d"
!packhdr "exehead.tmp" '"${UPX_PATH}\upx.exe" --brute exehead.tmp'

; ----------------------------------------------------------------------------

XPStyle on
RequestExecutionLevel user
InstallColors /windows
AutoCloseWindow true
ShowInstDetails show
SetCompressor LZMA

; ----------------------------------------------------------------------------

LoadLanguageFile "${NSISDIR}\Contrib\Language files\English.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\German.nlf"

!include "Language\MPUI_EN.nsh"
!include "Language\MPUI_DE.nsh"

; ----------------------------------------------------------------------------

Name "$(MPLAYER_LANG_MPLAYER_WIN32) $(MPLAYER_LANG_AUTO_UPDATE)"
Caption "$(MPLAYER_LANG_MPLAYER_WIN32) Auto-Update"
BrandingText "MPlayer Update [${MPLAYER_DATE}]"
Icon "Artwork\update.ico"
OutFile "${MPLAYER_OUTFILE}"

; ----------------------------------------------------------------------------

; Includes
!include "MPUI_Download.nsh"

; ----------------------------------------------------------------------------

SubCaption 0 " "
SubCaption 1 " "
SubCaption 2 " "
SubCaption 3 " "
SubCaption 4 " "

; ----------------------------------------------------------------------------

ReserveFile "${NSISDIR}\Plugins\Aero.dll"
ReserveFile "${NSISDIR}\Plugins\System.dll"
ReserveFile "${NSISDIR}\Plugins\inetc.dll"
ReserveFile "${NSISDIR}\Plugins\nsExec.dll"

; ----------------------------------------------------------------------------

Function .onGuiInit
	StrCpy $0 $HWNDPARENT
	System::Call "user32::SetWindowPos(i r0, i -1, i 0, i 0, i 0, i 0, i 3)"
	Aero::Apply
FunctionEnd

; ----------------------------------------------------------------------------

Section "-Download Update"
	; !insertmacro SetStatus "Initializing web-update, please wait..."

	;---------------------

	; InitPluginsDir
	; SetOutPath $PLUGINSDIR

	;---------------------

	; ${StdUtils.GetParameter} $0 "Location" "?"
	; ${StdUtils.GetParameter} $1 "Filename" "?"
	; ${StdUtils.GetParameter} $2 "TicketID" "?"
	; ${StdUtils.GetParameter} $3 "ToFolder" "?"
	; ${StdUtils.GetParameter} $4 "AppTitle" "?"
	; ${StdUtils.GetParameter} $5 "ToExFile" "?"

	;---------------------

	; ${If} "$0" == "?"
	; ${OrIf} "$1" == "?"
	; ${OrIf} "$2" == "?"
	; DetailPrint "Update parameters not found. Nothing to do!"
	; MessageBox MB_TOPMOST|MB_ICONINFORMATION "There currently are no updates available. Program will exit now!"
	; Quit
	; ${EndIf}

	; DetailPrint "Update server: $0"
	; DetailPrint "Download file name: $1"

	;---------------------

	; ${IfNot} "$4" == "?"
	; !insertmacro SetCaption "Web Update: $4"
	; ${EndIf}

	;---------------------

	; !insertmacro SetStatus "Downloading updates, please be patient..."

	; !insertmacro DownloadFilePost "$0" "file_name=$1&file_code=$2" "$PLUGINSDIR\$1"

	; !insertmacro DownloadFilePost "$0" "sign_name=$1" "$PLUGINSDIR\$1.sig"

	;---------------------

	; !insertmacro SetStatus "Download complete, verifying signature..."

	; File "/oname=$PLUGINSDIR\gpgv.exe" "bin\gpgv.exe"
	; File "/oname=$PLUGINSDIR\pubring.gpg" "bin\pubring.gpg"

	; SetOutPath $PLUGINSDIR
	; nsExec::ExecToLog '"$PLUGINSDIR\gpgv.exe" --homedir . --keyring pubring.gpg "$1.sig" "$1"'
	; Pop $9

	; Delete "$PLUGINSDIR\myring.gpg"
	; Delete "$PLUGINSDIR\$1.sig"
	; Delete "$PLUGINSDIR\gpgv.exe"

	;---------------------

	; ${If} "$9" == "error"
	; ${OrIf} "$9" == "timeout"
	; Delete "$PLUGINSDIR\$1"
	; MessageBox MB_ICONSTOP|MB_TOPMOST "Failed to verify signature. GnuPG encountered an error. Aborting!"
	; Abort "Failed to verify signature!"
	; ${EndIf}

	; ${IfNot} "$9" == "0"
	; Delete "$PLUGINSDIR\$1"
	; MessageBox MB_ICONSTOP|MB_TOPMOST "Failed to verify signature. Download may be malicious. Aborting!"
	; Abort "Failed to verify signature!"
	; ${EndIf}

	; !insertmacro SetStatus "Download is authentic, launching installer..."

	;---------------------

	; StrCpy $9 ""

	; ${IfNot} "$5" == "@"
	; ${IfNot} "$5" == "?"
	; StrCpy $9 '"/Update=$5"'
	; ${Else}
	; StrCpy $9 '/Update'
	; ${EndIf}
	; ${EndIf}

	; ${IfNot} "$3" == "?"
	; StrCpy $9 '$9 /D=$3'
	; ${EndIf}

	; SetOutPath $PLUGINSDIR

	;---------------------

	; ${Do}
	; ClearErrors
	; ExecShell "open" "$PLUGINSDIR\$1" '$9' SW_SHOWNORMAL
	; ${IfNotThen} ${Errors} ${|} ${Break} ${|}

	; ClearErrors
	; ExecShell "" "$PLUGINSDIR\$1" '$9' SW_SHOWNORMAL
	; ${IfNotThen} ${Errors} ${|} ${Break} ${|}

	; ClearErrors
	; Exec '"$PLUGINSDIR\$1" $9'
	; ${IfNotThen} ${Errors} ${|} ${Break} ${|}

	; ${IfCmd} MessageBox MB_ICONSTOP|MB_TOPMOST|MB_RETRYCANCEL "Failed to launch the installer:$\n$PLUGINSDIR\$1$\n$\nMake sure you have the required access rights and try again!" IDCANCEL ${||} ${Break} ${|}
	; ${Loop}

	; Delete /REBOOTOK "$PLUGINSDIR\$1"
SectionEnd

; ----------------------------------------------------------------------------
