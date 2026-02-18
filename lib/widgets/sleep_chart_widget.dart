import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class SleepChartWidget extends StatelessWidget {
  final List<double> data;

  SleepChartWidget({required this.data});

  @override
  Widget build(BuildContext context) {
    final series = [
      charts.Series<double, int>(
        id: 'Readings',
        data: data.asMap().entries.map((e) => e.value).toList(),
        domainFn: (value, index) => index ?? 0,
        measureFn: (value, index) => value,
      ),
    ];
    return Container(
      height: 200,
      child: charts.LineChart(series),
    );
  }
}