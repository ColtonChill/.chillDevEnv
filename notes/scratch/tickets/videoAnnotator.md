
How to view measurement/track messagePack file:
```
./measurementTrackJsonPrint -i
```


### Preforming replay
1. Run sigma

2. Run remoteSub utility
```
/sigma/Utilities/remoteSub 127.0.0.1 output_video chill 10.137.134.1 10004
/sigma/Utilities/measurementReplay 127.0.0.1 
```
3. Replay Data

```bash
source:
shares/C4ISR_SAB_Data/SWAAMII/20260819_DEMO/vtol/MEASUREMENTS

# Oak Cam
cat /root/replay_data/20260929/Oak/OakEncodedVideo_20260929_170221_733.ts | pv -L 516k | nc -u 10.137.134.210 10001 

# Event Camera
/sigma/Utilities/measurementReplay --originalTimestamp 127.0.0.1 /root/replay_data/MEASUREMENTS/MEASUREMENTS_MSGPACK_20260929_170209_889.pck
cat /root/replay_data/20260929/EstimatedBlob/AtrVideo_20260929_170217_915.ts | pv -L 516k | nc -u 10.137.134.210 10001 

# Custom BS (DON'T)
/sigma/Utilities/measurementReplay --originalTimestamp 127.0.0.1 replay_data/mock_measurements/test_measurements.json 100
cat /root/replay_data/20260929/EstimatedBlob/AtrVideo_20260929_170217_915.ts | pv -L 80k | nc -u 10.137.134.210 10001 
# ffmpeg -re -i /root/replay_data/20260929/EstimatedBlob/AtrVideo_20260929_170217_915.ts \
#   -c copy \
#   -f mpegts \
#   udp://10.137.134.210:10001?pkt_size=1316

Vtol demo (bad measurements)
/sigma/Utilities/measurementReplay --originalTimestamp 127.0.0.1 /root/replay_data/20260819_demo/MEASUREMENTS/MEASUREMENTS_MSGPACK_20240617_203942_981.pck
cat root/replay_data/20260819_demo/VideoEncDragoneye/captureVidAngelA_20240617_203950_697.ts | pv -L 516k | nc -u 10.137.134.210 10001 
```


## klvdisplay
klvdisplay to show frames

```bash
/sigma/Utilities/KlvDisplay replay_data/20260929/EstimatedBlob/AtrVideo_20260929_170217_915.ts > event_cam.txt
/sigma/Utilities/KlvDisplay replay_data/20260929/Oak/OakEncodedVideo_20260929_170221_733.ts > oak_cam.txt
/sigma/Utilities/KlvDisplay replay_data/20260819_demo/VideoEncDragoneye/captureVidAngelA_20240617_203950_697.ts > demo_cam.txt

```

## Generate Synthetic Test data
```

python3 ~/work/sigma/Interfaces/videoAnnotator/tools/test_data_generator.py \
    --output test_measurements.json \
    --start-timestamp 1790701347.53511691 \
    --duration-seconds 150 \
    --num-measurements 3000 \
    --moving-target \
    --target-start-lat 41.7875599 --target-start-lon -111.9810899 \
    --target-end-lat 41.7876599 --target-end-lon -111.9809899 \
    --target-start-alt 1335.75 --target-end-alt 1335.75 \
    --camera-lat 41.7875599 --camera-lon -111.9810899 --camera-alt 1335.75 \
    --sensor-pan 340.62 --sensor-tilt 45.0 --sensor-alpha 0.0 \
    --width 1280 --height 720 --focal-length 0.00858 --pixel-pitch 4.86e-06 \
    --pixel-cov-std 2.0 \
    --size-cov-std 2.0 \
    --range-error-std-m 0.5 \
    --cam-pos-std-m 0.1 \
    --cam-att-std-deg 0.01 \
    --sensor-att-std-deg 0.01 \
    --position-variance-m 2.0 \
    --altitude-variance-m 2.0

    --target-start-alt 1285.75 --target-end-alt 1285.75 \

python3 ~/work/sigma/Interfaces/videoAnnotator/tools/test_data_generator.py \
    --output test_measurements.json \
    --start-timestamp 1790701347.53511691 \
    --duration-seconds 300 \
    --num-measurements 3000 \
    --moving-target \
    --target-start-lat 41.7875599 --target-start-lon -111.9810899 \
    --target-end-lat 41.7876599 --target-end-lon -111.9809899 \
    --target-start-alt 1335.75 --target-end-alt 1335.75 \
    --camera-lat 41.7875599 --camera-lon -111.9810899 --camera-alt 1335.75 \
    --camera-hdg 351.39 --camera-pitch 0.06 --camera-roll 0.07 \
    --sensor-pan 340.62 --sensor-tilt 45.0 --sensor-alpha 0.0 \
    --width 1280 --height 720 --focal-length 0.00858 --pixel-pitch 4.86e-06 \
    --pixel-cov-std 2.0 --size-cov-std 2.0 --range-error-std-m 0.5 \
    --cam-pos-std-m 0.1 --cam-att-std-deg 0.01 --sensor-att-std-deg 0.01 \
    --position-variance-m 2.0 --altitude-variance-m 2.0

```
```bash
python3 ~/work/sigma/Interfaces/videoAnnotator/tools/verify_measurements.py \
      --measurements test_measurements.json \
      --start-time "2026-09-29T17:02:17" \
      --video-duration-seconds 30 \
      --fps 30
```

use the measurementTrackJsonPrint utiltiy without input to act like a consoleReader

 
Beware of ProcessingVindowSecs in the sigma json. Make it big or else it might ignore your replay data 
