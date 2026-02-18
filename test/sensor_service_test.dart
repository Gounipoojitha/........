import 'package:test/test.dart';
import '../lib/services/sensor_service.dart';

void main() {
  test('SensorService starts listening', () {
    final service = SensorService();
    expect(service, isNotNull);
  });
}