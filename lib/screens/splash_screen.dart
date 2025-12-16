import 'package:flutter/material.dart';
import 'package:quickpalo/constant/colors.dart';
import 'dart:async';
import 'package:quickpalo/screens/onboarding_screen.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: ClipRRect(
                borderRadius: BorderRadiusGeometry.only(
                  topRight: Radius.circular(25),
                  bottomLeft: Radius.circular(25),
                ),
                child: Image.asset("assets/images/quickpalo_logo.png"),
              ),
            ),
            const SizedBox(height: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Welcome to ",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        shadows: [
                          Shadow(
                            offset: Offset(2, 2),
                            blurRadius: 6,
                            color: Colors.black.withAlpha(80),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      "QuickPalo",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: LightPurpleColor3,
                        shadows: [
                          Shadow(
                            offset: Offset(2, 2),
                            blurRadius: 6,
                            color: Colors.black.withOpacity(0.2),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Text(
                  "Where Booking ",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    shadows: [
                      Shadow(
                        offset: Offset(2, 2),
                        blurRadius: 6,
                        color: Colors.black.withOpacity(0.2),
                      ),
                    ],
                  ),
                ),
                Text(
                  "Meets Efficiency.",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    shadows: [
                      Shadow(
                        offset: Offset(2, 2),
                        blurRadius: 6,
                        color: Colors.black.withOpacity(0.2),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // SizedBox(height: 30),
            // const CircularProgressIndicator(),
            SizedBox(
              child: Center(
                child: Lottie.asset(
                  "assets/lottie/loading.json",
                  width: 400,
                  repeat: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
