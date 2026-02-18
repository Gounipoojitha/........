import 'package:json_annotation/json_annotation.dart';
part 'stress_data.g.dart';

@JsonSerializable()
class StressData {
  double heartRateVariability;
  int phoneInteractions;

  StressData({required this.heartRateVariability, required this.phoneInteractions});

  factory StressData.fromJson(Map<String, dynamic> json) => _$StressDataFromJson(json);
  Map<String, dynamic> toJson() => _$StressDataToJson(this);
}