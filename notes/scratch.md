# SDL-TENSORRT notes

## Cmake code

Fake a CLI11 header

```cmake
if(NOT DEFINED tsb-extern_location)
  message(STATUS "Building standalone. Using system OpenCV.")
  find_package(OpenCV 4.7 REQUIRED)
  # Find CLI11.hpp manually
  #   CLI11 doesn’t ship a CMake config in Ubuntu
  #   so we create an INTERFACE target manually.
  find_path(CLI11_INCLUDE_DIR CLI/CLI.hpp REQUIRED)
  # Generate a symlink or copy CLI11.hpp (amalgamated form) into build tree
  file(WRITE "${CMAKE_BINARY_DIR}/CLI11.hpp"
      "#pragma once
      #include <CLI/CLI.hpp>
      ")
  # Paste it to the system the same as how tsb-extern does it
  include_directories(SYSTEM
      ${CLI11_INCLUDE_DIR}
      ${CMAKE_BINARY_DIR}
  )
endif()
```


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
