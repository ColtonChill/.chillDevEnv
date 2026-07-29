
## Data Preparation
```bash
data:
SWAAMII:
shares/C4ISR_SAB_Data/SWAAMII/AI/1_data/2_To_Train/
shares/C4ISR_SAB_Data/SWAAMII/AI/1_data/3_Finished

Shaheed:
shares/C4ISR_SAB_Data/SIFT/SIFT-D/AI/EO/Shaheed/4_Datasets/GoldenDataset/20250603_YOLODataset/
shares/C4ISR_SAB_Data/SIFT/SIFT-D/AI/EO/Shaheed/4_Datasets/GoldenDataset/20250528_YOLODataset/
shares/C4ISR_SAB_Data/SIFT/SIFT-D/AI/EO/Shaheed/4_Datasets/GoldenDataset/Base_YOLODataset/
```

```bash
ssh train-server1
mkdir /opt/ai_data/swaamii_raw
mkdir /opt/ai_data/shaheed_golden
# on host
cd shares/C4ISR_SAB_Data/SWAAMII/AI/1_data/2_To_Train/
rsync -azv * train-server1:/opt/ai_data/swaamii_raw/

cd shares/C4ISR_SAB_Data/SWAAMII/AI/1_data/3_Finished
rsync -azv * train-server1:/opt/ai_data/swaamii_raw/

cd shares/C4ISR_SAB_Data/SIFT/SIFT-D/AI/EO/Shaheed/4_Datasets/GoldenDataset
rsync -azv * train-server1:/opt/ai_data/shaheed_golden/

# back on server
cd /opt/ai_data/shaheed_golden
mkdir 20250528
mv 20250528_YOLODataset 20250528/YOLODataset
mkdir 20250603
mv 20250603_YOLODataset 20250603/YOLODataset
mkdir Base
mv Base_YOLODataset Base/YOLODataset
```

1. Compress the file
```bash
mkdir /opt/ai_data/20260728_swaamii_temp
source ~/Dev/yolo_train_scripts/env/bin/activate
python ~/Dev/dataprephelper/DATASET_MANIPULATION/compress_dir.py -i /opt/ai_data/swaamii_raw -o /opt/ai_data/20260728_swaamii_temp
```
2. augment the data
```bash
python ~/Dev/dataprephelper/AUGMENTER/augmenter.py -d /opt/ai_data/20260728_swaamii_temp -n 2 -fb -ma 120 -mv 0.01
```
3. Partition_yolo_data.py
```bash
cd ~/Dev/dataprephelper/
python ~/Dev/dataprephelper/DATASET_MANIPULATION/partition_yolo_data.py -i /opt/ai_data/20260728_swaamii_temp -o /opt/ai_data/20260728_Swaamii_Data
```
4. copy_to_server and fold to dataset together combine_partition_dataset.py
```bash
cd ~/Dev/dataprephelper/DATASET_MANIPULATION
python ~/Dev/dataprephelper/DATASET_MANIPULATION/combine_partitioned_data.py \
    -d /opt/ai_data/20260728_Swaamii_Data/YOLODataset \
    -d /opt/ai_data/shaheed_golden/20250528/YOLODataset \
    -d /opt/ai_data/shaheed_golden/20250603/YOLODataset \
    -d /opt/ai_data/shaheed_golden/Base/YOLODataset \
    -o /opt/ai_data/Swaamii_Shaheed_merge_20260728
```
5. update `cfg.yaml` and `dataset.yaml`
6. Train with tmux/screen
```bash
python ~/Dev/yolo_train_scripts/train_scripts/yolo_train.py \
    --config_file /opt/ai_data/Swaamii_Opterra_Shaheed_merge/YOLODataset/cfg.yaml
```

## Testing results
```bash
./Utilities/inferenceBenchmarker/inferenceBenchmarker \
  -s ~/work/ai/models/SWAAMII/SWAAMII_EO_yolo11n_swaamii_shaheed_v2_20260715_detect.onnx_spec.json \
  -d ~/work/ai/dataset/AtrVideo_20260715_174919_543/AtrVideo_20260715_174919_543.ts \
  -o ~/Downloads/AI_output/SWAAMII/ \
  -c 0.01
# MERGE
./Utilities/inferenceBenchmarker/inferenceBenchmarker \
  -s ~/Downloads/models/SWAAMII/SWAAMII_EO_yolo11n_total_20260623_detect_trt.onnx_spec.json \
  -d ~/Downloads/dataset/SWAAMII/images/test/ \
  -t ~/Downloads/dataset/SWAAMII/labels/test/ \
  -o ~/Downloads/AI_output/SWAAMII/ \
  -c 0.01
```
