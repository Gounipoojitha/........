import tensorflow as tf
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import LSTM, Dense, Dropout
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.metrics import classification_report

# Load processed data
data = pd.read_csv('../datasets/sleep_edf_dataset/processed_sleep.csv')
X = data[['accelerometer_x']].values.reshape(-1, 100, 1)  # Window size 100
y = tf.keras.utils.to_categorical(data['stage'], num_classes=5)  # 5 stages

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

model = Sequential([
    LSTM(64, input_shape=(100, 1), return_sequences=True),
    Dropout(0.2),
    LSTM(32),
    Dense(5, activation='softmax')
])
model.compile(optimizer='adam', loss='categorical_crossentropy', metrics=['accuracy'])
history = model.fit(X_train, y_train, epochs=50, validation_data=(X_test, y_test), 
                    callbacks=[tf.keras.callbacks.EarlyStopping(patience=5)], batch_size=32)

# Evaluate
loss, acc = model.evaluate(X_test, y_test)
print(f'Accuracy: {acc}')
y_pred = model.predict(X_test)
print(classification_report(y_test.argmax(axis=1), y_pred.argmax(axis=1)))

# Convert to TFLite with quantization for mobile
converter = tf.lite.TFLiteConverter.from_keras_model(model)
converter.optimizations = [tf.lite.Optimize.DEFAULT]
tflite_model = converter.convert()
with open('../models/sleep_classifier.tflite', 'wb') as f:
    f.write(tflite_model)