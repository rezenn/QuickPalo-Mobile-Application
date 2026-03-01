import 'package:flutter_test/flutter_test.dart';
import 'package:quickpalo/features/sensor/domain/entities/sensor_event.dart';

void main() {
  group('SensorEvent', () {

    test('should create proximity event correctly', () {
      final event = SensorEvent(
        type: SensorType.proximity,
        isTriggered: true,
        rawData: {'distance': 5.0},
     
      );

      expect(event.type, SensorType.proximity);
      expect(event.isTriggered, true);
      expect(event.rawData, {'distance': 5.0});
    });

    test('should create accelerometer event correctly', () {
      final event = SensorEvent(
        type: SensorType.accelerometer,
        isTriggered: false,
        rawData: {'x': 0.1, 'y': 0.2, 'z': 9.8},
      
      );

      expect(event.type, SensorType.accelerometer);
      expect(event.isTriggered, false);
      expect(event.rawData, {'x': 0.1, 'y': 0.2, 'z': 9.8});
     
    });

    test('should handle different trigger states', () {
      final triggeredEvent = SensorEvent(
        type: SensorType.proximity,
        isTriggered: true,
        rawData: {},
      
      );
      
      final notTriggeredEvent = SensorEvent(
        type: SensorType.proximity,
        isTriggered: false,
        rawData: {},
      
      );

      expect(triggeredEvent.isTriggered, true);
      expect(notTriggeredEvent.isTriggered, false);
    });
  });
}