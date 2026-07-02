# SDL-TENSORRT notes

## Add `libsdl-tensorrt.so` to path

```
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/chill/work/sigma/_build_deb_cuda/modules/sdl-tensorrt/libsdl-tensorrt.so

./Utilities/inferenceBenchmarker/inferenceBenchmarker
```

## Run Inference Test

```bash
#TMX
./Utilities/inferenceBenchmarker/inferenceBenchmarker \
  -s ~/work/sigma/modules/sdl-tensorrt/Tests/sdl-tensorrt-testdata/models/yolo11n_engine.onnx_spec.json \
  -d ~/work/sigma/modules/sdl-tensorrt/Tests/sdl-tensorrt-testdata/COCO/val/images/ \
  -t ~/work/sigma/modules/sdl-tensorrt/Tests/sdl-tensorrt-testdata/COCO/val/labels/ \
  -r ~/work/sigma/modules/sdl-tensorrt/Tests/sdl-tensorrt-testdata/COCO/rubrics/val.txt \
  -o ~/Downloads/AI_output/TMX_report/unit_test \
  -c 0.1

# COCO
./Utilities/inferenceBenchmarker/inferenceBenchmarker \
  -s ~/work/sigma/modules/sdl-tensorrt/Tests/sdl-tensorrt-testdata/models/yolo11n.onnx_spec.json \
  -d ~/work/sigma/modules/sdl-tensorrt/Tests/sdl-tensorrt-testdata/COCO/val/images/ \
  -t ~/work/sigma/modules/sdl-tensorrt/Tests/sdl-tensorrt-testdata/COCO/val/labels/ \
  -r ~/work/sigma/modules/sdl-tensorrt/Tests/sdl-tensorrt-testdata/COCO/rubrics/val.txt \
  -o ~/Downloads/AI_output/TMX_report/unit_test \
  -c 0.1 \
  --lineThickness 2 \
  --fontThickness 2 \
  --fontScale 300

# SWAAMII
./Utilities/inferenceBenchmarker/inferenceBenchmarker \
  -s ~/Downloads/models/ultralytics/yolo26n.onnx_spec.json \
  -d ~/Downloads/dataset/SWAAMII/captureVidAngelA_20260520_183841_244/imgs \
  -t ~/Downloads/dataset/SWAAMII/captureVidAngelA_20260520_183841_244/labels \
  -o ~/Downloads/AI_output/SWAAMII/ \
  -c 0.1
```

## Run ctest

```
ctest -L --output-on-failure --rerun-failed
```

## Sigma testing

```bash
# push data up
cat ./captureVidAngelA_20260527_175243_437.ts | pv -L 516k | nc -u 192.168.37.2 44444
# send data down
/sigma/Utilities/remoteSub 192.168.37.2 atrVid atrVid 192.168.37.234 55555
```




## Task output visitor:

```cpp
if (!m_truthPath.empty()) // grade the detections
{
  std::cout << "Pred:" << std::endl;
  for (auto pred : predictions)
  {
    std::visit(overloaded{[](std::vector<float>& /*arg*/) {},
                          [](ClassificationResult& arg)
                          {
                            std::cout << "  ->" << arg.m_labelIdx << ","
                                      << arg.m_label << std::endl;
                          },
                          [](DetectionResult& arg)
                          {
                            std::cout << "  ->" << arg.m_labelIdx << ","
                                      << arg.m_label << std::endl;
                          },
                          [](SegmentationResult& arg)
                          {
                            std::cout << "  ->" << arg.m_labelIdx << ","
                                      << arg.m_label << std::endl;
                          }},
               pred);
  }
  auto truths = m_model->readTruthFacade(m_truthPaths[i]);
  m_grades += m_model->evaluateFacade(predictions, truths);
}
```


mkdir -p COCO
cd COCO 

# 1) validation images
curl -kL -o val2017.zip https://images.cocodataset.org/zips/val2017.zip
unzip -q val2017.zip -d rawCOCO

# 2) annotation JSONs (only need instances_*.json for bounding boxes)
curl -kL -o annotations_trainval2017.zip https://images.cocodataset.org/annotations/annotations_trainval2017.zip
unzip -q annotations_trainval2017.zip -d rawCOCO
