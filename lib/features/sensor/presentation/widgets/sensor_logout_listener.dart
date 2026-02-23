import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickpalo/features/auth/presentation/pages/login_page.dart';
import 'package:quickpalo/features/auth/presentation/state/auth_state.dart';
import 'package:quickpalo/features/auth/presentation/view_model/auth_viewmodel.dart';
import 'package:quickpalo/features/sensor/domain/entities/sensor_event.dart';
import 'package:quickpalo/features/sensor/presentation/notifiers/sensor_notifier.dart';
import 'package:quickpalo/features/sensor/presentation/notifiers/shake_refresh_notifier.dart';
import 'package:quickpalo/features/sensor/presentation/providers/proximity_toggle_provider.dart';

class SensorLogoutListener extends ConsumerStatefulWidget {
  final Widget child;

  const SensorLogoutListener({super.key, required this.child});

  @override
  ConsumerState<SensorLogoutListener> createState() =>
      _SensorLogoutListenerState();
}

class _SensorLogoutListenerState extends ConsumerState<SensorLogoutListener> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncProximitySensor();
      _startShakeSensor();
    });
  }

  void _syncProximitySensor() {
    final isEnabled = ref.read(proximityToggleProvider);
    if (isEnabled) {
      ref.read(sensorNotifierProvider.notifier).watch(
            SensorType.proximity,
            onTriggered: () => _handleProximityLogout(),
          );
    } else {
      ref.read(sensorNotifierProvider.notifier).unwatch(SensorType.proximity);
    }
  }

  void _startShakeSensor() {
    ref.read(sensorNotifierProvider.notifier).watch(SensorType.accelerometer,
        onTriggered: () async {
      HapticFeedback.mediumImpact();
      ref.read(shakeRefreshProvider.notifier).trigger();
    });
  }

  Future<void> _handleProximityLogout() async {
    ref.read(sensorNotifierProvider.notifier).unwatch(SensorType.proximity);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.sensors, color: Colors.white),
            SizedBox(width: 10),
            Text('Logging out...'),
          ],
        ),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );

    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    await ref.read(authViewModelProvider.notifier).logout();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<bool>(proximityToggleProvider, (previous, next) {
      if (next) {
        ref.read(sensorNotifierProvider.notifier).watch(
              SensorType.proximity,
              onTriggered: () => _handleProximityLogout(),
            );
      } else {
        ref.read(sensorNotifierProvider.notifier).unwatch(SensorType.proximity);
      }
    });

    ref.listen<AuthState>(authViewModelProvider, (previous, next) {
      if (next.status == AuthStatus.unauthenticated) {
        ref.read(sensorNotifierProvider.notifier).stopAll();
        ScaffoldMessenger.of(context).clearSnackBars();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      }
      if (next.status == AuthStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage ?? 'Something went wrong'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    return widget.child;
  }
}
