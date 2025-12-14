## To convert using h264
ffmpeg -i plume_2023-03-07_09-49-50.avi -vcodec libx264 plume.ts

## Stream to capture
ffmpeg -re -i ./plume.ts -c copy -f mpegts -map 0:v -map 0:d? udp://10.42.0.150:5601

## Stream from remote
1. ssh root@192.168.0.9 "ffmpeg  -r 14 -s 640x480 -f video4linux2 -i /dev/video0 -f matroska -" | mplayer - -idle

    **(favorite ^^^)**

2. ssh USERNAME@REMOTEHOST ffmpeg -an -f video4linux2 -s 640x480 -i /dev/video0 -r 10 -b:v 500k -f matroska - | mpv --demuxer=mkv /dev/stdin

3. ssh USERNAME@REMOTEHOST ffmpeg -an -f video4linux2 -s 640x480 -i /dev/video0 -r 10 -b:v 500k -f matroska - | ffplay -f matroska /dev/stdin

## Capture stream from sigma
ffmpeg -i udp://@:10002 -f mpegts -c copy -f nut - | ffplay -


## Trim .ts video
### Extract pts timestaps 
ffprobe -select_streams v -show_packets -show_entries packet=pts_time -of csv captureVidIR_20260114_150503_215.ts | less

Scroll to top and bottom
27268.516033 --> 30868.494044

ffmpeg -copyts -i long.ts \
  -ss 27268.516033 \
  -to 30868.494044 \
  -map v \
  -c copy \
  overlap.ts

ffmpeg -ss 5368.859 -i large.ts \
     -t 3600 \
     -map 0 \
     -c copy \
     overlap.ts


### Trim video (.ts)
ffmpeg -ss 0 -i full.ts -c copy -t 600 small.ts


nighthawk EO:
27268.568356 --> 30868.544422

nighthawk IR:
27268.516033 --> 30868.494044
2026-01-14 16:34:29

mx15 IR:
360.832578   --> 38494.617411
2026-01-14 15:05:00

7:28:28
