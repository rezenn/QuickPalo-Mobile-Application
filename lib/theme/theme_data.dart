import 'package:flutter/material.dart';
import 'package:quickpalo/constant/colors.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
    useMaterial3: true,
    fontFamily: "Inter Regular",

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: LightPurpleColor,
      unselectedItemColor: textColorGrey,
      selectedLabelStyle: TextStyle(
        fontFamily: "Inter Bold 24",
        fontWeight: FontWeight.bold,
      ),
      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
    ),
  );
}
