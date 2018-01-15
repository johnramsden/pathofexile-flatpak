#!/bin/bash

export WINEPREFIX="${HOME}/.local/share/pathofexile"
export WINEDEBUG=-all

POE_INSTALLER_NAME="pathofexile_setup.exe"
POE_SETUP="${WINEPREFIX}/${POE_INSTALLER_NAME}"
POE_DOWNLOAD_URL='https://www.pathofexile.com/downloads/PathOfExileInstaller.exe'

WINE_CMD="/app/bin/wine"

# Set video memory
if [ -f "/var/log/Xorg.0.log" ]; then
  VIDEO_MEMORY=$(($(sed -rn 's/.*memory: ([0-9]*).*kbytes/\1/gpI' /var/log/Xorg.0.log) / 1024))
  if [ ${VIDEO_MEMORY} -gt 2048 ]; then
    VIDEO_MEMORY_SETTING=2048
  else
    VIDEO_MEMORY_SETTING=${VIDEO_MEMORY}
  fi
  echo "Setting video memory to ${VIDEO_MEMORY_SETTING}"
  winetricks --unattended videomemorysize=${VIDEO_MEMORY_SETTING}
fi

winetricks --unattended vd=1920x1080

if grep -q 'Software\\\\GrindingGearGames\\\\Path of Exile' ${WINEPREFIX}/user.reg; then
  echo "Path of Exile installed, running..."
  ${WINE_CMD} "${WINEPREFIX}/drive_c/Program Files/Grinding Gear Games/Path of Exile/PathOfExile.exe" \
    dbox  -no-dwrite -noasync
else
  echo "Path of Exile not installed."
  if [ ! -f "${POE_SETUP}" ]; then
    echo "Downloading Path of Exile installer."
    wget --output-document="${WINEPREFIX}/${POE_INSTALLER_NAME}" ${POE_DOWNLOAD_URL}
  fi
  echo "Running Path of Exile installer."
  "${WINE_CMD}" "${POE_SETUP}"
fi
