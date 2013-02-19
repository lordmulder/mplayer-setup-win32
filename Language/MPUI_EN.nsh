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

LangString MPLAYER_LANG_MPLAYER_WIN32            ${LANG_ENGLISH} "MPlayer for Windows"
LangString MPLAYER_LANG_BIN_CODECS               ${LANG_ENGLISH} "Binary Codecs"
LangString MPLAYER_LANG_FRONT_END                ${LANG_ENGLISH} "front-end"
LangString MPLAYER_LANG_COMPRESS_FILES           ${LANG_ENGLISH} "Optimize program files"
LangString MPLAYER_LANG_DETECTING                ${LANG_ENGLISH} "Detetcing CPU type..."
LangString MPLAYER_LANG_SELECT_CPU_HEAD          ${LANG_ENGLISH} "CPU Type Selection"
LangString MPLAYER_LANG_SELECT_CPU_TEXT          ${LANG_ENGLISH} "Selecting the optimal MPlayer build for your system can improve the playback performance!"
LangString MPLAYER_LANG_SELECT_CPU_TYPE          ${LANG_ENGLISH} "Select your CPU type:"
LangString MPLAYER_LANG_SELECT_CPU_HINT          ${LANG_ENGLISH} "Note: Selecting an incompatible CPU type may lead to a crash on your computer. Please select the 'Generic' type, if you don't know what to choose!"
LangString MPLAYER_LANG_TWEAKS_HEAD              ${LANG_ENGLISH} "MPlayer Tweaks"
LangString MPLAYER_LANG_TWEAKS_TEXT              ${LANG_ENGLISH} "Setup the initial configuration for MPlayer here!"
LangString MPLAYER_LANG_TWEAKS_HINT              ${LANG_ENGLISH} "Choose your tweaks:"
LangString MPLAYER_LANG_TWEAKS_SKINNEDUI         ${LANG_ENGLISH} "Enable the new 'skinned' user interface (SMPlayer only)"
LangString MPLAYER_LANG_TWEAKS_OPENGL            ${LANG_ENGLISH} "Enable the OpenGL-based video renderer, instead of Direct3D"
LangString MPLAYER_LANG_TWEAKS_VOLNORM           ${LANG_ENGLISH} "Enable volume normalization by default"
LangString MPLAYER_LANG_COMPRESSING              ${LANG_ENGLISH} "Compressing"
LangString MPLAYER_LANG_WRITING_REGISTRY         ${LANG_ENGLISH} "Registry information are being updated..."
LangString MPLAYER_LANG_APPLYING_TWEAKS          ${LANG_ENGLISH} "Tweaks are being applied..."
LangString MPLAYER_LANG_STATUS_WAIT              ${LANG_ENGLISH} "please wait"
LangString MPLAYER_LANG_STATUS_INST_CLEAN        ${LANG_ENGLISH} "Cleaning up old files"
LangString MPLAYER_LANG_STATUS_INST_MPLAYER      ${LANG_ENGLISH} "Installing MPlayer"
LangString MPLAYER_LANG_STATUS_INST_SMPLAYER     ${LANG_ENGLISH} "Installing SMPlayer"
LangString MPLAYER_LANG_STATUS_INST_MPUI         ${LANG_ENGLISH} "Installing MPUI"
LangString MPLAYER_LANG_STATUS_INST_CODECS       ${LANG_ENGLISH} "Installing binary Codecs"
LangString MPLAYER_LANG_STATUS_MAKEUNINST        ${LANG_ENGLISH} "Createing uninstaller"
LangString MPLAYER_LANG_STATUS_INST_FONTCACHE    ${LANG_ENGLISH} "Updating font cache"
LangString MPLAYER_LANG_STATUS_INST_COMPRESS     ${LANG_ENGLISH} "Optimizing program files"
LangString MPLAYER_LANG_STATUS_REGISTRY          ${LANG_ENGLISH} "Updating registry"
LangString MPLAYER_LANG_STATUS_TWEAKS            ${LANG_ENGLISH} "Applying tweaks"
LangString MPLAYER_LANG_STATUS_SHORTCUTS         ${LANG_ENGLISH} "Creating shortcuts"
LangString MPLAYER_LANG_STATUS_UNINSTALL         ${LANG_ENGLISH} "Uninstalling MPlayer"
LangString MPLAYER_LANG_SELECTED_TYPE            ${LANG_ENGLISH} "Selected CPU type"
LangString MPLAYER_LANG_UPDATING_FONTCACHE       ${LANG_ENGLISH} "The font-cache is being updated..."
LangString MPLAYER_LANG_STILL_RUNNING            ${LANG_ENGLISH} "Could not delete old MPlayer. Is MPlayer still running?$\nPlease close MPlayer and try again!"
LangString MPLAYER_LANG_LOCKEDLIST_HEADER        ${LANG_ENGLISH} "Running Instances"
LangString MPLAYER_LANG_LOCKEDLIST_TEXT          ${LANG_ENGLISH} "Checking for running instances of LameXP."
LangString MPLAYER_LANG_LOCKEDLIST_HEADING       ${LANG_ENGLISH} "Please close the following programs before continuing with setup..."
LangString MPLAYER_LANG_LOCKEDLIST_NOPROG        ${LANG_ENGLISH} "No programs that have to be closed are running."
LangString MPLAYER_LANG_LOCKEDLIST_SEARCH        ${LANG_ENGLISH} "Searching, please wait..."
LangString MPLAYER_LANG_LOCKEDLIST_COLHDR1       ${LANG_ENGLISH} "Anwendung"
LangString MPLAYER_LANG_LOCKEDLIST_COLHDR2       ${LANG_ENGLISH} "Prozess"
LangString MPLAYER_LANG_SHORTCUT_README          ${LANG_ENGLISH} "Readme File"
LangString MPLAYER_LANG_SHORTCUT_MANUAL          ${LANG_ENGLISH} "Manual"
LangString MPLAYER_LANG_SHORTCUT_SITE_MULDERS    ${LANG_ENGLISH} "MuldeR's Web-Site"
LangString MPLAYER_LANG_SHORTCUT_SITE_MPWIN32    ${LANG_ENGLISH} "MPlayer on Win32 Web-Site"
LangString MPLAYER_LANG_SHORTCUT_SITE_MPLAYER    ${LANG_ENGLISH} "Official MPlayer Web-Site"
LangString MPLAYER_LANG_INSTTYPE_COMPLETE        ${LANG_ENGLISH} "Complete Installation"
LangString MPLAYER_LANG_INSTTYPE_MINIMAL         ${LANG_ENGLISH} "Minimal Installation"
LangString MPLAYER_LANG_SELCHANGE                ${LANG_ENGLISH} "You must select either MPUI or SMPlayer!"
LangString MPLAYER_LANG_UNINSTALL_OLDVER         ${LANG_ENGLISH} "An old version of MPlayer for Windows has to be uninstalled first!$\nClick 'OK' in order to launch the uninstaller..."
