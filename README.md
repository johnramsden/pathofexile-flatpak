# Path of Exile Flatpak

This [Flatpak](https://flatpak.org) installs Path of Exile in a 32bit wine prefix.

*UPDATE: Since I created this flatpak, the [winepak](www.winepak.org) project has appeared. While the information in this post s still useful if you are looking to build a flatpak, if you are looking to install the flatpak, installing Path of Exile from there probably a better option since it supports 64-bit, and Is updated more frequently.*

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

If you are missing the freedesktop platform you may need to add the flathub repository and install it. It should install itself, but you can also explicitly install it.

```
flatpak --user remote-add \
    --if-not-exists flathub \
    https://flathub.org/repo/flathub.flatpakrepo
flatpak --user install flathub org.freedesktop.Platform//1.6
```

To change the virtual desktop resolution, set the environment variable `WINE_RESOLUTION` in the run command. 

It defaults to 1920x1080, to set it to 720x480 for example you would change the run command to: 

```
flatpak run --env=WINE_RESOLUTION=720x480 ca.johnramsden.pathofexile
```

To change the video memory if it's not detected properly at run time, use the `VIDEO_MEMORY` environment variable

```
flatpak run --env=VIDEO_MEMORY=1024 ca.johnramsden.pathofexile 
```

To make it permenant edit the `~/.local/share/flatpak/exports/share/applications/ca.johnramsden.pathofexile.desktop` file.

On first run it will download and install the wine requirements. Then it will download the [Path of Exile installer](https://www.pathofexile.com/downloads/PathOfExileInstaller.exe) and ask you to agree to the EULA. It will then proceed to download and install Path of Exile. Once finished it will run Path of Exile. On proceeding runs it will launch Path of Exile as expected.
