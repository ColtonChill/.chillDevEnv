# SDL-TENSORRT notes
## Add `libsdl-tensorrt.so` to path
```
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/chill/work/sigma/_build-deb-cuda/dist/libs/libsdl-tensorrt.so

./install/sigma/Utilities/inferenceBenchmarker -h
```

## Run Inference Test
```
./Utilities/inferenceBenchmarker/inferenceBenchmarker -h
```
Directory
```
./Utilities/inferenceBenchmarker/inferenceBenchmarker \
    -m ~/Downloads/models/TMX/20250903_TMX_Updated_Detect_detect.onnx \
    -d ~/Downloads/dataset/TMX/images/test \
    -T ~/Downloads/dataset/TMX/labels/test \
    -o ~/Downloads/tempOutputs
```
Video File
```
./modules/inferenceBenchmarker/inferenceBenchmarker \
    ~/Downloads/models/ultralytics/yolo11n.onnx \
    ~/Downloads/TrimmedVids/1000_meters.ts \
    -o ~/Downloads/tempOutputs/vid.avi \
    -c 0.3
```
Rubric
```
./Utilities/inferenceBenchmarker/inferenceBenchmarker \
    --model ~/Downloads/models/TMX/20250605_IR_Detector.onnx \
    --data ~/Downloads/dataset/TMX/images/train/ \
    --truth ~/Downloads/dataset/TMX/labels/train \
    --output ~/Downloads/tempOutputs \
    --rubric ~/Downloads/dataset/TMX/rubrics/train.txt \
    --jenkinsXml ~/Downloads/tempOutputs/TMX_report.xml
```
Single Image:
```
./modules/sdl-tensorrt/bin/TestInference \
    -m ~/Downloads/models/TMX/20250605_IR_Detector.onnx \
    -d ~/Downloads/dataset/images/train/planeIr01_20231023_frame_0000102.jpg \
    -T ~/Downloads/dataset/labels/train/planeIr01_20231023_frame_0000102.txt \
    -o ~/Downloads/tempOutputs
```
