import pandas as pd
import numpy as np
from sklearn.preprocessing import StandardScaler
import cv2
import os

# Sleep Data Preprocessing
def preprocess_sleep(data_path='../datasets/sleep_edf_dataset/'):
    annotations = pd.read_csv(os.path.join(data_path, 'annotations.csv'))
    # Assume columns: 'timestamp', 'accelerometer_x', 'stage'
    annotations.dropna(inplace=True)
    scaler = StandardScaler()
    annotations[['accelerometer_x']] = scaler.fit_transform(annotations[['accelerometer_x']])
    annotations.to_csv(os.path.join(data_path, 'processed_sleep.csv'), index=False)
    return annotations

# Stress Data Preprocessing
def preprocess_stress(data_path='../datasets/mimic_iii_dataset/'):
    data = pd.read_csv(os.path.join(data_path, 'hrv_data.csv'))  # Assume HRV values
    data.fillna(data.mean(), inplace=True)
    data['stress_label'] = (data['hrv'] < 50).astype(int)  # Binary stress
    data.to_csv(os.path.join(data_path, 'processed_stress.csv'), index=False)
    return data

# Nutrition Data Preprocessing
def preprocess_nutrition(data_path='../datasets/food_101_dataset/'):
    images = []
    labels = []
    meta = pd.read_csv(os.path.join(data_path, 'meta/train.txt'), sep='/', header=None, names=['class', 'file'])
    for _, row in meta.iterrows():
        img_path = os.path.join(data_path, 'images', row['class'], f"{row['file']}.jpg")
        img = cv2.imread(img_path)
        if img is not None:
            img = cv2.resize(img, (224, 224)) / 255.0
            images.append(img)
            labels.append(row['class'])
    np.save(os.path.join(data_path, 'processed_images.npy'), np.array(images))
    pd.DataFrame({'label': labels}).to_csv(os.path.join(data_path, 'processed_labels.csv'), index=False)
    return images, labels

if __name__ == '__main__':
    preprocess_sleep()
    preprocess_stress()
    preprocess_nutrition()