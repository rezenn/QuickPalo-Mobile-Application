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
        fontSize: 16,
      ),
      unselectedLabelStyle: TextStyle(
        fontFamily: "Inter Regular",
        fontSize: 14,
      ),
    ),
    appBarTheme: AppBarThemeData(
      centerTitle: true,
      elevation: 4,
      titleTextStyle: TextStyle(
        fontFamily: "Inter Bold 24",
        fontSize: 24,
        color: Colors.black,
      ),
    ),
  );
}
