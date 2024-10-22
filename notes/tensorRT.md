## Export a .py file to .onnx
```
yolo export model=yolo11n.pt format=onnx
```

## Generate an .onnx file from .pt (pytorch) file using scripts
```
cd work/yolo_train_scripts
python train_scripts/export_yolov8_to_trt_onnx.py --weights ~/Downloads/tensorRT/weights/best.pt --iou-thres 0.65 --conf-thres 0.25 --topk 100 --opset 17 --sim --input-shape 1 3 640 640 --device cuda:0
```

## Building Engine files

Build an engine file from scratch
```
/usr/src/tensorrt/bin/trtexec --onnx=./model_trt.onnx --saveEngine=model_trt_exec.engine --verbose
```
Build an engine with sigma utility
```
./EngineBuilder /home/chill/work/yolo_train_scripts/model_trt.onnx torch
```

### Examine a Network/model
`netron`

