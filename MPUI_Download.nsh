; ///////////////////////////////////////////////////////////////////////////////
; // MPlayer for Windows - Install Script
; // Copyright (C) 2004-2015 LoRd_MuldeR <MuldeR2@GMX.de>
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


!include "LogicLib.nsh"
!include "WinMessages.nsh"
!include "StdUtils.nsh"

!define HWND_TOPMOST -1

Var errors
Var dl_tmp

; ----------------------------------------------------------------------------

!define SetStatus "!insertmacro _SetStatus"

!macro _SetStatus text
	SetDetailsPrint textonly
	DetailPrint '${text}'
	SetDetailsPrint listonly
	Sleep 333
!macroend

; ----------------------------------------------------------------------------

!define DownloadFile.Get   '!insertmacro _DownloadFile "get"'
!define DownloadFile.Popup '!insertmacro _DownloadFile "popup"'

!define user_agent "Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20111106 IceCat/7.0.1"

!macro _DownloadFile action status_txt dl_url destfile
	StrCpy $errors 0

	!if "${action}" != "get"
		!if "${action}" != "popup"
			!error "Invalid 'action' value has been specified!"
		!endif
	!endif

	${Do}
		${SetStatus} "${status_txt}"
		DetailPrint "$(MPLAYER_LANG_DL_PROGRESS)"
		!if "${action}" == "get"
			inetc::get /CONNECTTIMEOUT 30 /RECEIVETIMEOUT 30 /CANCELTEXT "$(^CancelBtn)" /USERAGENT "${user_agent}" /SILENT "${dl_url}" "${destfile}" /END
		!endif
		!if "${action}" == "popup"
			inetc::get /CONNECTTIMEOUT 30 /RECEIVETIMEOUT 30 /CANCELTEXT "$(^CancelBtn)" /USERAGENT "${user_agent}" /CAPTION "${status_txt}" /POPUP "" "${dl_url}" "${destfile}" /END
		!endif
		Pop $dl_tmp

		${IfThen} "$dl_tmp" == "OK" ${|} ${Break} ${|}

		${If} "$dl_tmp" == "File Open Error"
			${SetStatus} "$(MPLAYER_LANG_DL_FAILED)"
			DetailPrint "Error: $dl_tmp"
			MessageBox MB_TOPMOST|MB_ICONSTOP "$(MPLAYER_LANG_DL_UPDATE_FAILED)"
			Abort "$(MPLAYER_LANG_DL_FAILED)"
		${EndIf}

		${If} "$dl_tmp" == "Cancelled"
			${SetStatus} "$(MPLAYER_LANG_DL_ABORTED)"
			DetailPrint "$(MPLAYER_LANG_DL_ERROR): $dl_tmp"
			${IfCmd} MessageBox MB_TOPMOST|MB_RETRYCANCEL|MB_ICONSTOP "$(MPLAYER_LANG_DL_USER_ABORTED)" IDRETRY ${||} ${Continue} ${|}
			Abort "$(MPLAYER_LANG_DL_FAILED)"
		${EndIf}

		IntOp $errors $errors + 3
		DetailPrint "$(MPLAYER_LANG_DL_ERROR): $dl_tmp"

		${If} $errors > 5
			${SetStatus} "$(MPLAYER_LANG_DL_FAILED)"
			StrCpy $errors 0
			MessageBox MB_TOPMOST|MB_ICONSTOP "$(MPLAYER_LANG_DL_FAILED_MSG) $dl_tmp$\n$\n$(MPLAYER_LANG_DL_RETRY)"
			Abort "$(MPLAYER_LANG_DL_FAILED)"
		${Else}
			${SetStatus} "$(MPLAYER_LANG_DL_RESTARTING)"
			Sleep 333
		${EndIf}
	${Loop}

	DetailPrint "$(MPLAYER_LANG_DL_SUCCESSFULL)"
	${SetStatus} "$(MPLAYER_LANG_DL_COMPELETED)"
!macroend
