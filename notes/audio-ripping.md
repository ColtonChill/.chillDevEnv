1. Make a virtual sink
    ```
    pactl load-module module-null-sink sink_name=spotify_sink sink_properties=device.description=SpotifySink
    ```
2. Open audio control GUI
    ```
    pavucontrol
    ```
3. Record from the monitor of virtual sink
    ```
    ffmpeg -f pulse -i spotify_sink.monitor -acodec libmp3lame -b:a 320k "my_ripped.mp3"
    ```
4. Clean up virtual sink
    ```
    pactl list short modules | grep null-sink
    
    pactl unload-module [module_index]
    ```
