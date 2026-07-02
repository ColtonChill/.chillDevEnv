## Initial Results
```bash
# SWAAMII
./Utilities/inferenceBenchmarker/inferenceBenchmarker \
  -s ~/Downloads/models/ultralytics/yolo26n.onnx_spec.json \
  -d ~/Downloads/dataset/SWAAMII/captureVidAngelA_20260520_183841_244/imgs \
  -t ~/Downloads/dataset/SWAAMII/captureVidAngelA_20260520_183841_244/labels \
  -o ~/Downloads/AI_output/SWAAMII/ \
  -c 0.1
```

### Yolo26n (vanilla)
---BenchMarks---
Time: 5.0551
Detections: 141
Frames: 753
detections/frame: 0.1873
detections/sec: 27.8928
frames/sec: 148.9596

---Grades---
TP: 0
FP: 141
FN: 148
Precision: 0.0000
Recall: 0.0000
F1: 0.0000

### Yolo26s (vanilla)
---BenchMarks---
Time: 7.2540
Detections: 1
Frames: 753
detections/frame: 0.0013
detections/sec: 0.1379
frames/sec: 103.8048

---Grades---
TP: 0
FP: 1
FN: 148
Precision: 0.0000
Recall: 0.0000
F1: 0.0000

## Training Preparation
Old data:
Opterra: 
shares/C4ISR_SAB_Data/SIFT/SIFT-D/AI/EO/Opterra/4_Datasets

Shaheed: 
shares/C4ISR_SAB_Data/SIFT/SIFT-D/AI/EO/Shaheed/4_Datasets/GoldenDataset/20250603_YOLODataset

Swaamii:
shares/C4ISR_SAB_Data/SWAAMII/AI/1_data/2_To_Train


1. Compress the file
```bash
mkdir /opt/ai_data/20250622_swaamii_temp
python ~/Dev/dataprephelper/DATASET_MANIPULATION/compress_dir.py -i /opt/ai_data/swaamii_raw -o /opt/ai_data/20250622_swaamii_temp
```
2. augment the data
```bash
python ~/Dev/dataprephelper/AUGMENTER/augmenter.py -d /opt/ai_data/20250622_swaamii_temp -n 2 -fb -ma 120 -mv 0.01
```
3. Partition_yolo_data.py
```bash
cd ~/Dev/dataprephelper/
python ~/Dev/dataprephelper/DATASET_MANIPULATION/partition_yolo_data.py -i /opt/ai_data/20250622_swaamii_temp -o /opt/ai_data/20250622_Swaamii_Data
```
4. copy_to_server and fold to dataset together combine_partition_dataset.py
```bash
# cd shares/C4ISR_SAB_Data/SIFT/SIFT-D/AI/EO/Shaheed/4_Datasets/GoldenDataset/
rsync -azPv 20250603_YOLODataset/* train-server1:/opt/ai_data/20250603_Shaheed_Data/YOLODataset/
cd ~/Dev/dataprephelper/DATASET_MANIPULATION
python ~/Dev/dataprephelper/DATASET_MANIPULATION/combine_partitioned_data.py \
       -d /opt/ai_data/20250622_Swaamii_Data/YOLODataset \
       -d /opt/ai_data/20250603_Shaheed_Data/YOLODataset \
       -d /opt/ai_data/20250613_Opterra_Data/YOLODataset \
       -o /opt/ai_data/Swaamii_Opterra_Shaheed_merge
```
5. update `cfg.yaml` and `dataset.yaml`
6. Train with tmux/screen
```bash
python ~/Dev/yolo_train_scripts/train_scripts/yolo_train.py \
    --config_file /opt/ai_data/Swaamii_Opterra_Shaheed_merge/YOLODataset/cfg11_total.yaml

python ~/Dev/yolo_train_scripts/train_scripts/yolo_train.py \
    --config_file /opt/ai_data/20250622_Swaamii_Data/YOLODataset/cfg11_raw.yaml
```

## Testing results
```bash
# RAW
./Utilities/inferenceBenchmarker/inferenceBenchmarker \
  -s ~/Downloads/models/SWAAMII/SWAAMII_EO_yolo11n_raw_20260623_detect_trt.onnx_spec.json \
  -d ~/Downloads/dataset/SWAAMII/images/test/ \
  -t ~/Downloads/dataset/SWAAMII/labels/test/ \
  -o ~/Downloads/AI_output/SWAAMII/ \
  -c 0.01
# MERGE
./Utilities/inferenceBenchmarker/inferenceBenchmarker \
  -s ~/Downloads/models/SWAAMII/SWAAMII_EO_yolo11n_total_20260623_detect_trt.onnx_spec.json \
  -d ~/Downloads/dataset/SWAAMII/images/test/ \
  -t ~/Downloads/dataset/SWAAMII/labels/test/ \
  -o ~/Downloads/AI_output/SWAAMII/ \
  -c 0.01
# MINI NON TRT
./Utilities/inferenceBenchmarker/inferenceBenchmarker \
  -s ~/Downloads/models/SWAAMII/SWAAMII_EO_yolo11n_total_20260623_detect.onnx_spec.json \
  -d ~/Downloads/dataset/captureVidAngelA_20260527_175243_437/images/ \
  -t ~/Downloads/dataset/captureVidAngelA_20260527_175243_437/labels/ \
  -o ~/Downloads/AI_output/SWAAMII/ \
  -c 0.01
# MIN TRT_VERSION
./Utilities/inferenceBenchmarker/inferenceBenchmarker \
  -s ~/Downloads/models/SWAAMII/total_trt.onnx_spec.json \
  -d ~/Downloads/dataset/captureVidAngelA_20260527_175243_437/images/ \
  -t ~/Downloads/dataset/captureVidAngelA_20260527_175243_437/labels/ \
  -o ~/Downloads/AI_output/SWAAMII/ \
  -c 0.01
```
