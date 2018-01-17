# Path of Exile Flatpak

This [Flatpak](https://flatpak.org) installs Path of Exile in a 32bit wine prefix.

## Installing

With Flatpak installed, add [my Flatpak repository](http://flatpakrepo.johnramsden.ca). 

``` 
flatpak --user remote-add --if-not-exists johnramsden http://flatpakrepo.johnramsden.ca/johnramsden.flatpakrepo 
``` 

Install the Path of Exile Flatpak 

``` 
flatpak --user install johnramsden ca.johnramsden.pathofexile 
``` 

Next run Path of Exile. 

``` 
flatpak run ca.johnramsden.pathofexile 
``` 

On first run it will download and install the wine requirements. Then it will download the [Path of Exile installer](https://www.pathofexile.com/downloads/PathOfExileInstaller.exe) and ask you to agree to the EULA. It will then proceed to download and install Path of Exile. Once finished it will run Path of Exile. On proceeding runs it will launch Path of Exile as expected.
