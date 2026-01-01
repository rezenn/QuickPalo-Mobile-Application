import 'package:flutter/material.dart';
import 'package:quickpalo/screens/navbar_screen/calendar_screen.dart';
import 'package:quickpalo/screens/navbar_screen/history_screen.dart';
import 'package:quickpalo/screens/navbar_screen/home_screen.dart';
import 'package:quickpalo/screens/navbar_screen/profile_screen.dart';
import 'package:quickpalo/widgets/custom_nav_bar.dart';

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
    return Scaffold(
      body: screenList[_selectedIndex],
      bottomNavigationBar: CustomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
