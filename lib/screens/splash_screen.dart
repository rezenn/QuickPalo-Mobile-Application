import 'package:flutter/material.dart';
import 'package:quickpalo/constant/colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              LightBlueColor,
              LightBlueColor2,
              LightPurpleColor,
              LightPurpleColor2,
              LightPurpleColor3,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.13, 0.5, 0.78, 1.0],
          ),
        ),
        child: Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.height * 0.4,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(300),
              child: Image.asset('assets/images/quickpalo_logo.png'),
            ),
          ),
        ),
      ),
    );
  }
}
