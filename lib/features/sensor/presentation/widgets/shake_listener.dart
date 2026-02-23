import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickpalo/features/sensor/domain/entities/sensor_event.dart';
import 'package:quickpalo/features/sensor/presentation/notifiers/sensor_notifier.dart';
import 'package:quickpalo/features/sensor/presentation/notifiers/shake_refresh_notifier.dart';

class ShakeListener extends ConsumerStatefulWidget {
  final Widget child;

  const ShakeListener({super.key, required this.child});

  @override
  ConsumerState<ShakeListener> createState() => _ShakeListenerState();
}

class _ShakeListenerState extends ConsumerState<ShakeListener> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(sensorNotifierProvider.notifier).watch(
        SensorType.accelerometer,
        onTriggered: () async {
          ref.read(shakeRefreshProvider.notifier).trigger();
        },
      );
    });
  }

  @override
  void dispose() {
    ref.read(sensorNotifierProvider.notifier).unwatch(SensorType.accelerometer);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
