import 'package:sensors_plus/sensors_plus.dart';
import '../models/sleep_data.dart';

class SensorService {
  List<double> _readings = [];

  void startListening(Function(List<double>) onData) {
    accelerometerEvents.listen((event) {
      _readings.add(event.x); // Example: Store x-axis
      if (_readings.length > 100) _readings.removeAt(0); // Limit size
      onData(_readings);
    });
  }
}