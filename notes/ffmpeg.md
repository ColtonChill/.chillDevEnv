# To convert using h264
ffmpeg -i plume_2023-03-07_09-49-50.avi -vcodec libx264 plume.ts

# Stream to capture
ffmpeg -re -i ./plume.ts -c copy -f mpegts -map 0:v -map 0:d? udp://10.42.0.150:5601

