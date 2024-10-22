# SDL-TENSORRT notes

## Run Inference Test
```
./modules/sdl-tensorrt/bin/TestInference -h
```
```
./modules/sdl-tensorrt/bin/TestInference \
    ~/Downloads/models/TMX/20250605_IR_Detector.onnx \
    ~/Downloads/Dataset_Balance_Test/images/train/ \
    -T ~/Downloads/Dataset_Balance_Test/labels/train \
    -o ~/Downloads/tempOutputs
```
```
./modules/sdl-tensorrt/bin/TestInference \
    ~/Downloads/models/ultralytics/yolo11n.onnx \
    ~/Downloads/TrimmedVids/1000_meters.ts \
    -o ~/Downloads/tempOutputs/vid.avi \
    -c 0.3
```
```
./modules/sdl-tensorrt/bin/TestInference \
    ~/Downloads/models/TMX/20250605_IR_Detector.onnx \
    ~/Downloads/dataset/images/train/ \
    -T ~/Downloads/dataset/labels/train \
    -o ~/Downloads/tempOutputs \
    -R ~/Downloads/dataset/rubrics/train.txt
```


## TODO
### Files to remove & Fold into `TestInference.cpp`
* `TestDataInference.cpp`
* `InferenceTimer.cpp`
* `nonVisualInferencer.cpp`

## Ideas

* 
