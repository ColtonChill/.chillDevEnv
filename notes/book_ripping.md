# Rip from audible
## Set up
`pip install audible-cli`

## Get AAX files
audible -P chris download --aax -t book 

## Get Authcode
`audible manage profile list`
`audible -P <user> activation-bytes`

## Convert to m4b
* git@github.com:KrumpetPirate/AAXtoMP3.git
* `ffmpeg -activation_bytes XXXXXXXX -i book.aax -c copy book.m4b`

## Helper Tools
* [m4b-tool](https://github.com/sandreas/m4b-tool)<br>
Helps to merge multi-part files into a single file
    * m4b-tool merge -v --jobs=4 --output-file="output/" "input/file.m4b"

## Info
Username:         Christinahill
Password:         Rootbeer1*
authcode:         c88e7701

Username:         ctj.cchill@gmail.com
authcode:         d5fdb229

# Rip from Libby
## Firefox addon
[Libby Download](https://addons.mozilla.org/en-US/firefox/addon/libby-download/)

## Convert mp3 to m4b
`ffmpeg -i book.mp3 -vn book.m4b`

# Ebooks 
## Libby cli
[odmpy](https://github.com/ping/odmpy)
    * Ignore the urllib3 error
odmpy libby -k --ebooks
odmpy dl book.odm -m --mergeformat m4b --mergecodec aac

## Adobe Digital Edisions
```
winetricks corefonts dotnet40
wine ADE_4.5_Installer.exe

WINEPREFIX=~/.adewine WINEARCH=win32 wineboot
export WINEPREFIX=$HOME/.adewine/
winetricks -q corefonts && winetricks -q windowscodecs
winecfg
winetricks dotnet35sp1
wine ~/Downloads/ADE_2.0_Installer.exe
```

## Calibre
* 2 plugins are required
    * DeACSM
    * DeDRM

## Silly Redit
[link](https://www.reddit.com/r/Calibre/comments/flf2hf/finally_found_a_way_to_download_library_books_how/)
[Online Converter?](https://www.acsmconverter.com/)

