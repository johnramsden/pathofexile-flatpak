#!/bin/bash

export WINEPREFIX="${HOME}/.local/share/pathofexile"
export WINEDEBUG=-all

POE_INSTALLER_NAME="pathofexile_setup.exe"
POE_SETUP="${WINEPREFIX}/${POE_INSTALLER_NAME}"
POE_DOWNLOAD_URL='https://www.pathofexile.com/downloads/PathOfExileInstaller.exe'

WINE_RESOLUTION="${WINE_RESOLUTION:-1920x1080}"

WINE_CMD="/app/bin/wine"

XORG_LOG="/var/log/Xorg.0.log"

echo "Path of Exile Unofficial Flatpak"
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

     echo "Setting registry key:"
     cat ${tmpfile}

     wine regedit ${tmpfile}
     rm ${tmpfile}
  else
    echo "Unable to read Xorg logs from ${XORG_LOG}."
    echo "Leaving video card memory at default settings."
  fi 
}

# Run only if POE isn't installed
first_run(){
  echo "Path of Exile not installed, Installing first run wine requirements."
  winetricks --unattended directx9 usp10 msls31 corefonts tahoma win7

  echo "Running first run settings."
  winetricks --unattended csmt=on glsl=disabled

  if [ ! -f "${POE_SETUP}" ]; then
    echo "Downloading Path of Exile installer."
    wget --output-document="${POE_SETUP}" ${POE_DOWNLOAD_URL}
  fi
  echo "Running Path of Exile installer."
  "${WINE_CMD}" "${POE_SETUP}"
}

# Main function
startup(){
  echo "Setting resolution to ${WINE_RESOLUTION}, if changed from default may need restart to take effect"
  winetricks --unattended vd=${WINE_RESOLUTION}

  set_video_memory

  if ! grep -q 'Software\\\\GrindingGearGames\\\\Path of Exile' ${WINEPREFIX}/user.reg; then
    first_run 
  fi

  echo "Starting Path of Exile..."
  ${WINE_CMD} "${WINEPREFIX}/drive_c/Program Files/Grinding Gear Games/Path of Exile/PathOfExile.exe" \
    dbox  -no-dwrite -noasync
}

startup
