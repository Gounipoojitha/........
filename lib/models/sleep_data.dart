import 'package:json_annotation/json_annotation.dart';
part 'sleep_data.g.dart';

@JsonSerializable()
class SleepData {
  double totalSleepTime;
  double sleepEfficiency;
  List<double> accelerometerReadings;

  SleepData({required this.totalSleepTime, required this.sleepEfficiency, required this.accelerometerReadings});

  factory SleepData.fromJson(Map<String, dynamic> json) => _$SleepDataFromJson(json);
  Map<String, dynamic> toJson() => _$SleepDataToJson(this);
}