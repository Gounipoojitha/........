import tensorflow as tf
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Conv1D, MaxPooling1D, Flatten, Dense
import pandas as pd
from sklearn.model_selection import train_test_split

data = pd.read_csv('../datasets/mimic_iii_dataset/processed_stress.csv')
X = data[['hrv']].values.reshape(-1, 50, 1)  # Window HRV
y = data['stress_label'].values

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

model = Sequential([
    Conv1D(32, 3, activation='relu', input_shape=(50, 1)),
    MaxPooling1D(2),
    Flatten(),
    Dense(1, activation='sigmoid')
])
model.compile(optimizer='adam', loss='binary_crossentropy', metrics=['accuracy'])
model.fit(X_train, y_train, epochs=30, validation_data=(X_test, y_test), batch_size=32)

converter = tf.lite.TFLiteConverter.from_keras_model(model)
converter.optimizations = [tf.lite.Optimize.DEFAULT]
tflite_model = converter.convert()
with open('../models/stress_predictor.tflite', 'wb') as f:
    f.write(tflite_model)