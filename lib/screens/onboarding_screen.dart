import 'package:flutter/material.dart';
import 'package:quickpalo/constant/colors.dart';
import 'package:quickpalo/screens/login_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final controller = PageController();
  bool isLastPage = false;
  // final showLogin = false;

  // @override
  // void initState() {
  //   super.initState();
  //   _loadPrefs();
  // }

  // Future<void> _loadPrefs() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final loggedIn = prefs.getBool('showLogin') ?? false;

  //   if (loggedIn) {
  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (_) => const LoginScreen()),
  //       );
  //     });
  //   }
  // }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(bottom: 80),
          child: PageView(
            controller: controller,
            onPageChanged: (value) {
              setState(() => isLastPage = value == 2);
            },
            children: [
              Container(
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/onboarding_one.png",
                      width: 380,
                      fit: BoxFit.contain,
                    ),
                    Text(
                      "Book Appointments Without the Hassle",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 15),

                    Text(
                      "Skip long queues and confusing phone calls. Schedule your visit anytime from anywhere instantly.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Inter Italic",
                        height: 1.5,
                        color: Colors.black.withAlpha(150),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/oneboarding_three.png",
                      width: 450,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Fast, Reliable and Organized",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 15),

                    Text(
                      "Choose your institution, pick a time slot and confirm. Receive reminders and manage all your bookings in one place.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Inter Italic",
                        height: 1.5,
                        color: Colors.black.withAlpha(150),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/onboarding_two.png",
                      width: 450,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Your Time Matters",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 15),

                    Text(
                      "Whether it’s a hospital, school or service center arrive prepared and right on schedule. Make every visit smoother.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Inter Italic",
                        height: 1.5,
                        color: Colors.black.withAlpha(150),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: isLastPage
          ? TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                foregroundColor: Colors.white,
                backgroundColor: LightPurpleColor,
                minimumSize: const Size.fromHeight(80),
              ),
              onPressed: () async {
                // final prefs = await SharedPreferences.getInstance();
                // await prefs.setBool('showLogin', true);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: const Text("Get Started", style: TextStyle(fontSize: 20)),
            )
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => controller.jumpToPage(2),
                    child: Text("Skip"),
                  ),
                  Center(
                    child: SmoothPageIndicator(
                      controller: controller,
                      count: 3,
                      effect: WormEffect(
                        spacing: 16,
                        dotColor: LightBlueColor,
                        activeDotColor: LightPurpleColor3,
                      ),
                      onDotClicked: (index) => controller.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => controller.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    ),
                    child: Text("Next"),
                  ),
                ],
              ),
            ),
    );
  }
}
