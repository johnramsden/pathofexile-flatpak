#!/bin/bash

export WINEPREFIX="${HOME}/.local/share/pathofexile"
export WINEDEBUG=-all

POE_INSTALLER_NAME="pathofexile_setup.exe"
POE_SETUP="${WINEPREFIX}/${POE_INSTALLER_NAME}"
POE_DOWNLOAD_URL='https://www.pathofexile.com/downloads/PathOfExileInstaller.exe'

WINE_CMD="/app/bin/wine"

if grep -q 'Software\\\\GrindingGearGames\\\\Path of Exile' ${WINEPREFIX}/user.reg; then
  echo "Path of Exile installed, running..."
  ${WINE_CMD} "${WINEPREFIX}/drive_c/Program Files/Grinding Gear Games/Path of Exile/PathOfExile.exe" \
    dbox  -no-dwrite -noasync
else
  echo "Path of Exile not installed, Installing first run wine requirements."

  winetricks --unattended directx9 usp10 msls31 corefonts tahoma win7

  echo "Running first run settings."
  
  winetricks --unattended csmt=on vd=1920x1080 glsl=disabled

  # Set video memory 
  if [ -f "/var/log/Xorg.0.log" ]; then 
    VIDEO_MEMORY=$(($(sed -rn 's/.*memory: ([0-9]*).*kbytes/\1/gpI' /var/log/Xorg.0.log) / 1024))

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
  fi 

  if [ ! -f "${POE_SETUP}" ]; then
    echo "Downloading Path of Exile installer."
    wget --output-document="${POE_SETUP}" ${POE_DOWNLOAD_URL}
  fi
  echo "Running Path of Exile installer."
  "${WINE_CMD}" "${POE_SETUP}"

  echo "Running Path of Exile"
  ${WINE_CMD} "${WINEPREFIX}/drive_c/Program Files/Grinding Gear Games/Path of Exile/PathOfExile.exe" \
    dbox  -no-dwrite -noasync
fi
