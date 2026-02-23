// core/sensors/presentation/notifiers/sensor_notifier.dart
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:quickpalo/features/sensor/domain/entities/sensor_event.dart';
import 'package:quickpalo/features/sensor/domain/usecases/watch_sensor_usecase.dart';

final sensorNotifierProvider =
    NotifierProvider<SensorNotifier, AsyncValue<SensorEvent?>>(
  SensorNotifier.new,
);

class SensorNotifier extends Notifier<AsyncValue<SensorEvent?>> {
  final Map<SensorType, StreamSubscription<SensorEvent>> _subscriptions = {};

  @override
  AsyncValue<SensorEvent?> build() {
    ref.onDispose(_cancelAll);
    return const AsyncValue.data(null);
  }

  // Call this for each sensor you want to watch
  void watch(SensorType type, {required Future<void> Function() onTriggered}) {
    if (_subscriptions.containsKey(type)) return;

    final usecase = ref.read(watchSensorUsecaseProvider);
    _subscriptions[type] = usecase.call(type).listen((event) async {
      if (event.isTriggered) {
        await onTriggered();
      }
    });
  }

  void unwatch(SensorType type) {
    _subscriptions[type]?.cancel();
    _subscriptions.remove(type);
    ref.read(watchSensorUsecaseProvider).stop(type);
  }

  void stopAll() => _cancelAll();
  void _cancelAll() {
    for (final sub in _subscriptions.values) {
      sub.cancel();
    }
    _subscriptions.clear();
    ref.read(watchSensorUsecaseProvider).stopAll();
  }
}
