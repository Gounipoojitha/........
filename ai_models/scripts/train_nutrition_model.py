import tensorflow as tf
import numpy as np
import pandas as pd
from sklearn.model_selection import train_test_split

images = np.load('../datasets/food_101_dataset/processed_images.npy')
labels_df = pd.read_csv('../datasets/food_101_dataset/processed_labels.csv')
labels = tf.keras.utils.to_categorical(labels_df['label'].factorize()[0], num_classes=101)

X_train, X_test, y_train, y_test = train_test_split(images, labels, test_size=0.2, random_state=42)

base_model = tf.keras.applications.MobileNetV2(input_shape=(224, 224, 3), include_top=False)
base_model.trainable = False
model = tf.keras.Sequential([
    base_model,
    tf.keras.layers.GlobalAveragePooling2D(),
    Dense(101, activation='softmax')
])
model.compile(optimizer='adam', loss='categorical_crossentropy', metrics=['accuracy'])
model.fit(X_train, y_train, epochs=20, validation_data=(X_test, y_test), batch_size=32)

converter = tf.lite.TFLiteConverter.from_keras_model(model)
converter.optimizations = [tf.lite.Optimize.DEFAULT]
tflite_model = converter.convert()
with open('../models/nutrition_estimator.tflite', 'wb') as f:
    f.write(tflite_model)