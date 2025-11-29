import 'package:flutter/material.dart';
import 'package:quickpalo/screens/login_screen.dart';
import 'package:quickpalo/screens/splash_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: LoginScreen());
  }
}
