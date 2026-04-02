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
For a single mp3
```
ffmpeg -i input.mp3 \
  -map 0:a \
  -map 0:v? \
  -c:a libfdk_aac -vbr 3 \
  -c:v copy \
  -disposition:v attached_pic \
  output.m4b
```
For multiple, make a text file of mp3's
```
file 'input1.mp3'
file 'input2.mp3'
file 'input3.mp3'
...
```
Then use that for the ffmpeg cmd
```
ffmpeg \
  -f concat -safe 0 -i inputs.txt \
  -i "first_input.mp3" \
  -map 0:a:0 \
  -map 1:v:0 \
  -c:a libfdk_aac -vbr 3 \
  -c:v copy \
  -disposition:v attached_pic \
  -fflags +genpts \
  -movflags +faststart \         # needed for phones to play nice
  output.m4b
```

## Extra stuff
### Add chapter information
Extract any existing metadata
```bash
ffmpeg -i input.mp4 -f ffmetadata metadata.txt
```
Add to metadata file with chapter info
```txt
;FFMETADATA1
[CHAPTER]
TIMEBASE=1/1000
START=0
END=149999
title=Chapter 1
[CHAPTER]
TIMEBASE=1/1000
START=150000
END=284999
title=Chapter 2
```
Then you can add that metadata to the m4b
```bash
ffmpeg -i input_video.m4b -i metadata.txt -map_metadata 1 -codec copy output_video.m4b
```

### De-mangle mp3
If individual mp3 are mangled, re-encode them.
```
for f in *.mp3; do
  ffmpeg -i "$f" -map 0:a "fixed_${f%.mp3}.wav"
done
```

### Extract a cover from an m4b
```
ffmpeg -i "input.m4b" -map 0:2 -c copy "cover.jpg"
```

### Remux to fast start
```
ffmpeg -i broken.m4b -c copy -movflags +faststart fixed.m4b
```


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

