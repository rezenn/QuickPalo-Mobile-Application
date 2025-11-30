import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(),
          child: Column(
            children: [Image.asset("assets/images/quickpalo_logo.png")],
          ),
        ),
      ),
    );
  }
}
