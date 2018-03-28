# Path of Exile Flatpak

This [Flatpak](https://flatpak.org) installs Path of Exile in a 32bit wine prefix.

## Installing

If you want to try my flatpak without having to build it yourself, add my Flatpak repository.

```
flatpak --user remote-add \
    --if-not-exists johnramsden http://flatpakrepo.johnramsden.ca/johnramsden.flatpakrepo
```

Now you should be able to install my flatpaks.

```
flatpak --user install johnramsden ca.johnramsden.pathofexile
```

If you are missing the GNOME platform you may need to add the flathub or gnome repository and install it.

```
flatpak --user remote-add \
    --if-not-exists flathub \
    https://flathub.org/repo/flathub.flatpakrepo
flatpak --user install flathub org.gnome.Platform//3.28
```

To change the virtual desktop resolution, set the environment variable `WINE_RESOLUTION` in the run command. 

It defaults to 1920x1080, to set it to 720x480 for example you would change the run command to: 

```
flatpak run --env=WINE_RESOLUTION=720x480 ca.johnramsden.pathofexile
```

To make it permenant edit the `~/.local/share/flatpak/exports/share/applications/ca.johnramsden.pathofexile.desktop` file.

On first run it will download and install the wine requirements. Then it will download the [Path of Exile installer](https://www.pathofexile.com/downloads/PathOfExileInstaller.exe) and ask you to agree to the EULA. It will then proceed to download and install Path of Exile. Once finished it will run Path of Exile. On proceeding runs it will launch Path of Exile as expected.
