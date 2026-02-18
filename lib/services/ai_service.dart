import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:cloud_functions/cloud_functions.dart';

class AIService {
  Interpreter? _sleepInterpreter;
  Interpreter? _stressInterpreter;
  Interpreter? _nutritionInterpreter;

  Future<void> loadModels() async {
    _sleepInterpreter = await Interpreter.fromAsset('assets/models/sleep_classifier.tflite');
    _stressInterpreter = await Interpreter.fromAsset('assets/models/stress_predictor.tflite');
    _nutritionInterpreter = await Interpreter.fromAsset('assets/models/nutrition_estimator.tflite');
  }

  List<double> predictSleep(List<double> accelerometerData) {
    if (_sleepInterpreter == null || accelerometerData.length < 100) return [];
    var input = Float32List.fromList(accelerometerData.sublist(0, 100).map((e) => e.toDouble()).toList()).reshape([1, 100, 1]);
    var output = List.filled(5, 0.0).reshape([1, 5]);
    _sleepInterpreter!.run(input, output);
    return output[0];
  }

  double predictStress(List<double> hrvData) {
    if (_stressInterpreter == null || hrvData.length < 50) return 0.5;
    var input = Float32List.fromList(hrvData.sublist(0, 50).map((e) => e.toDouble()).toList()).reshape([1, 50, 1]);
    var output = List.filled(1, 0.0).reshape([1, 1]);
    _stressInterpreter!.run(input, output);
    return output[0][0];
  }

  String estimateNutrition(Uint8List imageBytes) {
    if (_nutritionInterpreter == null) return 'Unknown';
    var input = Float32List.fromList(imageBytes.map((e) => e / 255.0).toList()).reshape([1, 224, 224, 3]);
    var output = List.filled(101, 0.0).reshape([1, 101]);
    _nutritionInterpreter!.run(input, output);
    int classIndex = output[0].indexOf(output[0].reduce((a, b) => a > b ? a : b));
    List<String> foodClasses = ['apple_pie', 'pizza'];
    return foodClasses[classIndex];
  }

  Future<bool> detectAnomalyCloud(List<double> combinedData) async {
    final callable = FirebaseFunctions.instance.httpsCallable('detectAnomaly');
    final result = await callable.call({'combinedData': combinedData});
    return result.data['isAnomaly'];
  }

  Future<Map<String, dynamic>> processNutritionCloud(String imageUrl) async {
    final callable = FirebaseFunctions.instance.httpsCallable('processNutrition');
    final result = await callable.call({'imageUrl': imageUrl});
    return result.data;
  }

  bool detectAnomaly(List<double> combinedData) {
    double avg = combinedData.reduce((a, b) => a + b) / combinedData.length;
    return avg < 0.1;
  }

  String generateRecommendation(double sleepEff, double stressLevel, String food) {
    if (sleepEff < 0.8 && stressLevel > 0.7) return 'Reduce caffeine, eat more $food, and meditate.';
    if (sleepEff > 0.9) return 'Great sleep! Maintain with $food.';
    return 'Monitor stress and nutrition closely.';
  }
}