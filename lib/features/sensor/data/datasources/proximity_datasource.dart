import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proximity_sensor/proximity_sensor.dart';

import 'package:quickpalo/features/sensor/domain/entities/sensor_event.dart';
import 'i_sensor_datasource.dart';

final proximityDatasourceProvider = Provider<ProximityDatasource>((ref) {
  final ds = ProximityDatasource();
  ref.onDispose(() => ds.stop());
  return ds;
});

class ProximityDatasource implements ISensorDatasource {
  StreamSubscription<int>? _subscription;
  final _controller = StreamController<SensorEvent>.broadcast();
  bool _isFirstEvent = true;
  Timer? _holdTimer;

  @override
  SensorType get sensorType => SensorType.proximity;

  @override
  Stream<SensorEvent> get eventStream => _controller.stream;

  @override
  void start() {
    _isFirstEvent = true;
    _subscription ??= ProximitySensor.events.listen((int value) {
      if (_isFirstEvent) {
        _isFirstEvent = false;
        return;
      }
      final isNear = value < 4;
      if (isNear) {
        _holdTimer ??= Timer(const Duration(seconds: 3), () {
          _controller.add(SensorEvent(
            type: SensorType.proximity,
            isTriggered: true,
            rawData: {'value': value},
          ));
        });
      } else {
        _holdTimer?.cancel();
        _holdTimer = null;
      }
    });
  }

  @override
  void stop() {
    _holdTimer?.cancel();
    _holdTimer = null;
    _subscription?.cancel();
    _subscription = null;
    _isFirstEvent = true;
  }
}
