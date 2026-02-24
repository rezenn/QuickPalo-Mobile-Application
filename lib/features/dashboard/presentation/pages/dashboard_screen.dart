import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickpalo/features/dashboard/presentation/pages/calendar_screen.dart';
import 'package:quickpalo/features/dashboard/presentation/pages/history_screen.dart';
import 'package:quickpalo/features/organizations/presentation/pages/home_screen.dart';
import 'package:quickpalo/features/dashboard/presentation/widgets/custom_nav_bar.dart';
import 'package:quickpalo/features/profile/presentation/pages/profile_screen.dart';
import 'package:quickpalo/features/sensor/domain/entities/sensor_event.dart';
import 'package:quickpalo/features/sensor/presentation/notifiers/sensor_notifier.dart';
import 'package:quickpalo/features/sensor/presentation/notifiers/shake_refresh_notifier.dart';
import 'package:quickpalo/features/sensor/presentation/widgets/sensor_logout_listener.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> screenList = const [
    HomeScreen(),
    CalendarScreen(),
    HistoryScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   ref.read(sensorNotifierProvider.notifier).watch(
    //     SensorType.accelerometer,
    //     onTriggered: () async {
    //       ref.read(shakeRefreshProvider.notifier).trigger();
    //     },
    //   );
    // });
  }

  @override
  void dispose() {
    // ref.read(sensorNotifierProvider.notifier).unwatch(SensorType.accelerometer);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<int>(shakeRefreshProvider, (previous, next) {
      if (previous != next) {
        if (_selectedIndex == 0) return;
        setState(() {
          _selectedIndex = 0;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(children: [
              Icon(Icons.home, color: Colors.white),
              SizedBox(width: 8),
              Text('Back to Dashboard'),
            ]),
            duration: Duration(seconds: 1),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
    return SensorLogoutListener(
      child: Scaffold(
        body: screenList[_selectedIndex],
        bottomNavigationBar: CustomNavBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
