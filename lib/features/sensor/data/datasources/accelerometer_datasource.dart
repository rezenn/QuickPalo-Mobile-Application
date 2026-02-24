import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:quickpalo/features/sensor/domain/entities/sensor_event.dart';
import 'i_sensor_datasource.dart';

final accelerometerDatasourceProvider = Provider<AccelerometerDatasource>(
  (_) => AccelerometerDatasource(),
);

class AccelerometerDatasource implements ISensorDatasource {
  static const double _shakeThreshold = 13.0;

  final _controller = StreamController<SensorEvent>.broadcast();
  StreamSubscription? _sub;
  DateTime? _lastShake;

  @override
  SensorType get sensorType => SensorType.accelerometer;

  @override
  Stream<SensorEvent> get eventStream => _controller.stream;

  @override
  void start() {
    _sub ??= accelerometerEventStream().listen((event) {
      final magnitude = sqrt(
        event.x * event.x + event.y * event.y + event.z * event.z,
      );

      final isShake = magnitude > _shakeThreshold;

      if (isShake) {
        final now = DateTime.now();
        if (_lastShake == null ||
            now.difference(_lastShake!) > const Duration(seconds: 2)) {
          _lastShake = now;
          _controller.add(SensorEvent(
            type: SensorType.accelerometer,
            isTriggered: true,
            rawData: {'x': event.x, 'y': event.y, 'z': event.z},
          ));
        }
        return;
      }

      _controller.add(SensorEvent(
        type: SensorType.accelerometer,
        isTriggered: false,
        rawData: {'x': event.x, 'y': event.y, 'z': event.z},
      ));
    });
  }

  @override
  void stop() {
    _sub?.cancel();
    _sub = null;
    _lastShake = null;
  }
}
