import 'package:flutter/material.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SafeArea(
          child: Column(
            children: [
              Center(
                child: Text(
                  "Calendar",
                  style: const TextStyle(
                    fontFamily: "Inter Bold 24",
                    fontSize: 24,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text("Calendar Screen"),
            ],
          ),
        ),
      ),
    );
  }
}
