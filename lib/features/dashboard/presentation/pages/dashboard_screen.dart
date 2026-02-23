import 'package:flutter/material.dart';
import 'package:quickpalo/features/dashboard/presentation/pages/calendar_screen.dart';
import 'package:quickpalo/features/dashboard/presentation/pages/history_screen.dart';
import 'package:quickpalo/features/organizations/presentation/pages/home_screen.dart';
import 'package:quickpalo/features/dashboard/presentation/widgets/custom_nav_bar.dart';
import 'package:quickpalo/features/profile/presentation/pages/profile_screen.dart';
import 'package:quickpalo/features/sensor/presentation/widgets/sensor_logout_listener.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
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
  Widget build(BuildContext context) {
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
