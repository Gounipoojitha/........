import 'package:json_annotation/json_annotation.dart';
part 'nutrition_data.g.dart';

@JsonSerializable()
class NutritionData {
  String foodName;
  double calories;
  Map<String, double> nutrients;

  NutritionData({required this.foodName, required this.calories, required this.nutrients});

  factory NutritionData.fromJson(Map<String, dynamic> json) => _$NutritionDataFromJson(json);
  Map<String, dynamic> toJson() => _$NutritionDataToJson(this);
}