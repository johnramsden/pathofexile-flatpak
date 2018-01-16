#!/bin/sh

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

  winetricks --unattended directx9 usp10 msls31 corefonts tahoma

  echo "Running first run settings."
  
  winetricks --unattended win7 csmt=on vd=1920x1080 glsl=disabled

  if [ ! -f "${POE_SETUP}" ]; then
    echo "Downloading Path of Exile installer."
    wget --output-document="${WINEPREFIX}/${POE_INSTALLER_NAME}" ${POE_DOWNLOAD_URL}
  fi
  echo "Running Path of Exile installer."
  "${WINE_CMD}" "${POE_SETUP}"

  echo "Running Path of Exile"
  ${WINE_CMD} "${WINEPREFIX}/drive_c/Program Files/Grinding Gear Games/Path of Exile/PathOfExile.exe" \
    dbox  -no-dwrite -noasync
fi
