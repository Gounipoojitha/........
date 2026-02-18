from sklearn.ensemble import IsolationForest
import pandas as pd
import joblib

# Combine datasets
sleep = pd.read_csv('../datasets/sleep_edf_dataset/processed_sleep.csv')
stress = pd.read_csv('../datasets/mimic_iii_dataset/processed_stress.csv')
combined = pd.concat([sleep[['accelerometer_x']], stress[['hrv']]], axis=1).fillna(0)

model = IsolationForest(contamination=0.1, random_state=42)
model.fit(combined)

joblib.dump(model, '../models/anomaly_detector.pkl')