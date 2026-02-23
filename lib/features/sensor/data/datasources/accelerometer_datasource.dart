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
  static const double _shakeThreshold = 5.0;
  final _controller = StreamController<SensorEvent>.broadcast();
  StreamSubscription? _sub;

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
      _controller.add(SensorEvent(
        type: SensorType.accelerometer,
        isTriggered: isShake,
        rawData: {'x': event.x, 'y': event.y, 'z': event.z},
      ));
    });
  }

  @override
  void stop() {
    _sub?.cancel();
    _sub = null;
  }
}
