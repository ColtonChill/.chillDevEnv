# Ripping audio playback

### Make virtual
```
pactl load-module module-null-sink sink_name=spotify_sink sink_properties=device.description=SpotifySink
```

### Redirect output to virtual sink
```
pavucontrol
```
1. Go to the Playback tab
2. Find Spotify
3. Change its output from your normal speakers to SpotifySink

### Listen to audio
```
ffmpeg -f pulse -i spotify_sink.monitor -t 240 -acodec libmp3lame -b:a 320k "song.mp3"
```

### Clean up virtual sink
```
pactl list short modules | grep null-sink
pactl unload-module [module_index]
```
