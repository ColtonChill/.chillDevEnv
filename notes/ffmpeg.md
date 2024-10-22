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
