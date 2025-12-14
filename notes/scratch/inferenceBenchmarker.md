# SDL-TENSORRT notes
## Add `libsdl-tensorrt.so` to path
```
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/chill/work/sigma/_build-deb-cuda/dist/libs/libsdl-tensorrt.so

./install/sigma/Utilities/inferenceBenchmarker -h
```

## Run Inference Test
```
./inferenceBenchmarker/inferenceBenchmarker \
  -m ~/Downloads/models/TMX/20250605_TMX_powers_IR_Detector_trt.onnx \
  -d ~/Downloads/dataset/TMX_report/mx15_IR_trim.ts \
  -o ~/Downloads/AI_output/TMX_report/20250605_TMX_powers_IR_Detector_trt_mx15_trim \
  -l ~/Downloads/dataset/TMX/classes.txt \
  -c 0.1 \
  --csvNullRows
```
