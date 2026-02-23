import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickpalo/features/auth/presentation/pages/login_page.dart';
import 'package:quickpalo/features/auth/presentation/state/auth_state.dart';
import 'package:quickpalo/features/auth/presentation/view_model/auth_viewmodel.dart';
import 'package:quickpalo/features/sensor/domain/entities/sensor_event.dart';
import 'package:quickpalo/features/sensor/presentation/notifiers/sensor_notifier.dart';
import 'package:quickpalo/features/sensor/presentation/providers/proximity_toggle_provider.dart';

class SensorLogoutListener extends ConsumerStatefulWidget {
  final Widget child;

  const SensorLogoutListener({super.key, required this.child});

  @override
  ConsumerState<SensorLogoutListener> createState() =>
      _SensorLogoutListenerState();
}

// class _SensorLogoutListenerState extends ConsumerState<SensorLogoutListener> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       ref.read(sensorNotifierProvider.notifier).watch(
//             SensorType.proximity,
//             onTriggered: () => _handleProximityLogout(),
//           );
//     });
//   }

//   Future<void> _handleProximityLogout() async {
//     // Stop sensor immediately to prevent multiple triggers
//     ref.read(sensorNotifierProvider.notifier).stopAll();

//     // Show snackbar warning
//     if (!mounted) return;
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             Icon(Icons.warning_amber_rounded, color: Colors.white),
//             SizedBox(width: 10),
//             Text('Logging out...'),
//           ],
//         ),
//         duration: Duration(seconds: 3),
//         backgroundColor: Colors.red,
//         behavior: SnackBarBehavior.floating,
//       ),
//     );

//     await Future.delayed(const Duration(seconds: 2));

//     if (!mounted) return;
//     await ref.read(authViewModelProvider.notifier).logout();
//   }

//   @override
//   Widget build(BuildContext context) {
//     ref.listen<AuthState>(authViewModelProvider, (previous, next) {
//       if (next.status == AuthStatus.unauthenticated) {
//         ref.read(sensorNotifierProvider.notifier).stopAll();
//         ScaffoldMessenger.of(context).clearSnackBars();
//         Navigator.of(context).pushAndRemoveUntil(
//           MaterialPageRoute(builder: (_) => const LoginScreen()),
//           (route) => false,
//         );
//       }

//       if (next.status == AuthStatus.error) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(next.errorMessage ?? 'Something went wrong'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     });

//     return widget.child;
//   }
// }

// sensor_logout_listener.dart
class _SensorLogoutListenerState extends ConsumerState<SensorLogoutListener> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncSensor();
    });
  }

  void _syncSensor() {
    final isEnabled = ref.read(proximityToggleProvider);
    if (isEnabled) {
      ref.read(sensorNotifierProvider.notifier).watch(
            SensorType.proximity,
            onTriggered: () => _handleProximityLogout(),
          );
    } else {
      ref.read(sensorNotifierProvider.notifier).stopAll();
    }
  }

  Future<void> _handleProximityLogout() async {
    ref.read(sensorNotifierProvider.notifier).stopAll();

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
    // React to toggle changes globally
    ref.listen<bool>(proximityToggleProvider, (previous, next) {
      if (next) {
        ref.read(sensorNotifierProvider.notifier).watch(
              SensorType.proximity,
              onTriggered: () => _handleProximityLogout(),
            );
      } else {
        ref.read(sensorNotifierProvider.notifier).stopAll();
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
