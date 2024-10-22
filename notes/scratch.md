# SDL-TENSORRT notes

## Run Inference Test
```
./modules/sdl-tensorrt/bin/TestInference -h
```
Directory
```
./modules/sdl-tensorrt/bin/TestInference \
    ~/Downloads/models/TMX/20250605_IR_Detector.onnx \
    ~/Downloads/Dataset_Balance_Test/images/train/ \
    -T ~/Downloads/Dataset_Balance_Test/labels/train \
    -o ~/Downloads/tempOutputs
```
Video File
```
./modules/sdl-tensorrt/bin/TestInference \
    ~/Downloads/models/ultralytics/yolo11n.onnx \
    ~/Downloads/TrimmedVids/1000_meters.ts \
    -o ~/Downloads/tempOutputs/vid.avi \
    -c 0.3
```
Rubric
```
# ./install/sigma/Utilities/TestInference \
./modules/sdl-tensorrt/bin/TestInference \
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
