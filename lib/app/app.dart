import 'package:flutter/material.dart';
import 'package:quickpalo/screens/splash_screen.dart';
import 'package:quickpalo/theme/theme_data.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      theme: getApplicationTheme(),
    );
  }
}
