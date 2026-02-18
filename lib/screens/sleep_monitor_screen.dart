import 'package:flutter/material.dart';
import '../services/sensor_service.dart';
import '../widgets/sleep_chart_widget.dart';

class SleepMonitorScreen extends StatefulWidget {
  @override
  _SleepMonitorScreenState createState() => _SleepMonitorScreenState();
}

class _SleepMonitorScreenState extends State<SleepMonitorScreen> {
  final SensorService _sensorService = SensorService();
  List<double> _readings = [];

  @override
  void initState() {
    super.initState();
    _sensorService.startListening((data) => setState(() => _readings = data));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sleep Monitor')),
      body: Column(
        children: [
          SleepChartWidget(data: _readings),
          Text('Total Readings: ${_readings.length}'),
        ],
      ),
    );
  }
}