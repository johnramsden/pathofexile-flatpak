#!/bin/bash

export WINEPREFIX="${HOME}/.local/share/pathofexile"
export WINEDEBUG=-all

POE_INSTALLER_NAME="pathofexile_setup.exe"
POE_SETUP="${WINEPREFIX}/${POE_INSTALLER_NAME}"
POE_DOWNLOAD_URL='https://www.pathofexile.com/downloads/PathOfExileInstaller.exe'

WINE_RESOLUTION="${WINE_RESOLUTION:-1920x1080}"

WINE_CMD="/app/bin/wine"

XORG_LOG="/var/log/Xorg.0.log"

VERSION_NUM="0.1.1"
VERSION_FILE="${WINEPREFIX}/ca.johnramsden.pathofexile.version"

echo "#############################################"
echo "## Path of Exile Unofficial Flatpak v${VERSION_NUM} ##"
echo "#############################################"
echo

# Set video memory by checking xorg
set_video_memory(){
  if [ -f "${XORG_LOG}" ]; then 
    VIDEO_MEMORY=$(($(sed -rn 's/.*memory: ([0-9]*).*kbytes/\1/gpI' ${XORG_LOG}) / 1024))

    echo "Setting video memory to ${VIDEO_MEMORY}" 
    tmpfile=$(mktemp VideoMemory.XXXXX.reg)

    cat <<EOF > "${tmpfile}"
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\\Software\\Wine\\Direct3D]
"VideoMemorySize"="${VIDEO_MEMORY}"

EOF
     wine regedit ${tmpfile} >/dev/null 2>&1
     rm ${tmpfile}
  else
    echo "Unable to read Xorg logs from ${XORG_LOG}."
    echo "Leaving video card memory at default settings."
  fi 
}

set_wine_settings(){
  local my_documents="${WINEPREFIX}/drive_c/users/${USER}/My Documents"

  echo "Installing wine requirements."
  winetricks --unattended directx9 usp10 msls31 corefonts tahoma win7

  echo "Setting wine settings."
  winetricks --unattended csmt=on glsl=disabled

  # Symlink points to wrong location, fix it
  if [[ "$(readlink "${my_documents}")" != "${XDG_DOCUMENTS_DIR}" ]]; then
    echo "Setting game directory to ${XDG_DOCUMENTS_DIR}"
    mv "${my_documents}" "${my_documents}.bak.$(date +%F)"
    ln -s "${XDG_DOCUMENTS_DIR}" "${my_documents}"
  fi

  echo
}

# Run only if POE isn't installed
first_run(){
  set_wine_settings

  echo "${VERSION_NUM}" > "${VERSION_FILE}"

  if [ ! -f "${POE_SETUP}" ]; then
    echo "Downloading Path of Exile installer."
    wget --output-document="${POE_SETUP}" "${POE_DOWNLOAD_URL}"
  fi
  echo "Running Path of Exile installer."
  "${WINE_CMD}" "${POE_SETUP}"
}

is_updated(){
  if [ -f "${VERSION_FILE}" ]; then
    last_version="$(cat ${VERSION_FILE})"
  else
    last_version="0"
  fi

  echo "${VERSION_NUM}" > "${VERSION_FILE}"
  
  if [[ "${VERSION_NUM}" == "${last_version}" ]]; then
    return 0
  else
    return 1
  fi
}

# Main function
startup(){

  set_video_memory

  if ! grep -q 'Software\\\\GrindingGearGames\\\\Path of Exile' "${WINEPREFIX}/user.reg" >/dev/null; then
    echo "Path of Exile not installed."
    first_run
  else
    if ! is_updated; then
      echo "Not up to date, re-run wine settings"
      set_wine_settings
    fi
  fi
    
  echo "Setting resolution to ${WINE_RESOLUTION}"
  echo "If resolution was changed from default, game may need restarting"
  winetricks --unattended vd=${WINE_RESOLUTION} >/dev/null

  echo ; echo "Starting Path of Exile..."
  ${WINE_CMD} "${WINEPREFIX}/drive_c/Program Files/Grinding Gear Games/Path of Exile/PathOfExile.exe" \
    dbox  -no-dwrite -noasync
}

startup
