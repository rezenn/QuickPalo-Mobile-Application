import 'package:flutter/material.dart';
import 'package:quickpalo/app/theme/app_colors.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
    useMaterial3: true,
    fontFamily: "Inter Regular",
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: lightPurpleColor,
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

// import 'package:flutter/material.dart';
// import 'package:quickpalo/app/theme/app_colors.dart';

// // ── Light theme ───────────────────────────────────────────────────────────────
// ThemeData getApplicationTheme() {
//   return ThemeData(
//     useMaterial3: true,
//     fontFamily: "Inter Regular",
//     bottomNavigationBarTheme: BottomNavigationBarThemeData(
//       backgroundColor: Colors.white,
//       selectedItemColor: lightPurpleColor,
//       unselectedItemColor: textColorGrey,
//       selectedLabelStyle: const TextStyle(
//         fontFamily: "Inter Bold 24",
//         fontWeight: FontWeight.bold,
//         fontSize: 16,
//       ),
//       unselectedLabelStyle: const TextStyle(
//         fontFamily: "Inter Regular",
//         fontSize: 14,
//       ),
//     ),
//     appBarTheme: const AppBarTheme(
//       centerTitle: true,
//       elevation: 4,
//       titleTextStyle: TextStyle(
//         fontFamily: "Inter Bold 24",
//         fontSize: 24,
//         color: Colors.black,
//       ),
//     ),
//   );
// }

// // ── Dark theme ────────────────────────────────────────────────────────────────
// ThemeData getApplicationDarkTheme() {
//   return ThemeData(
//     useMaterial3: true,
//     brightness: Brightness.dark,
//     fontFamily: "Inter Regular",
//     scaffoldBackgroundColor: const Color(0xFF0F172A),
//     colorScheme: ColorScheme.dark(
//       primary: lightPurpleColor,
//       secondary: lightPurpleColor3,
//       surface: const Color(0xFF1E293B),
//     ),
//     bottomNavigationBarTheme: BottomNavigationBarThemeData(
//       backgroundColor: const Color(0xFF1E293B),
//       selectedItemColor: lightPurpleColor,
//       unselectedItemColor: Colors.grey.shade500,
//       selectedLabelStyle: const TextStyle(
//         fontFamily: "Inter Bold 24",
//         fontWeight: FontWeight.bold,
//         fontSize: 16,
//       ),
//       unselectedLabelStyle: const TextStyle(
//         fontFamily: "Inter Regular",
//         fontSize: 14,
//       ),
//     ),
//     appBarTheme: const AppBarTheme(
//       centerTitle: true,
//       elevation: 4,
//       backgroundColor: Color(0xFF1E293B),
//       foregroundColor: Colors.white,
//       titleTextStyle: TextStyle(
//         fontFamily: "Inter Bold 24",
//         fontSize: 24,
//         color: Colors.white,
//       ),
//     ),
//     // cardTheme: CardTheme(
//     //   color: const Color(0xFF1E293B),
//     //   elevation: 2,
//     //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//     // ),
//     inputDecorationTheme: InputDecorationTheme(
//       filled: true,
//       fillColor: const Color(0xFF1E293B),
//       hintStyle: TextStyle(color: Colors.grey.shade500),
//       labelStyle: const TextStyle(color: Colors.white70),
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: BorderSide.none,
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: const BorderSide(color: Color(0xFF334155)),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: BorderSide(color: lightPurpleColor),
//       ),
//     ),
//     textTheme: const TextTheme(
//       bodyLarge: TextStyle(color: Colors.white, fontFamily: "Inter Regular"),
//       bodyMedium: TextStyle(color: Colors.white70, fontFamily: "Inter Regular"),
//       bodySmall: TextStyle(color: Colors.white60, fontFamily: "Inter Regular"),
//       titleLarge: TextStyle(
//           color: Colors.white,
//           fontWeight: FontWeight.bold,
//           fontFamily: "Inter Bold 24"),
//       titleMedium: TextStyle(color: Colors.white, fontFamily: "Inter Bold 24"),
//       titleSmall: TextStyle(color: Colors.white70, fontFamily: "Inter Regular"),
//       labelLarge: TextStyle(color: Colors.white, fontFamily: "Inter Regular"),
//     ),
//     iconTheme: const IconThemeData(color: Colors.white70),
//     dividerColor: const Color(0xFF334155),
//     // dialogTheme: const DialogTheme(
//     //   backgroundColor: Color(0xFF1E293B),
//     //   titleTextStyle: TextStyle(
//     //     color: Colors.white,
//     //     fontSize: 18,
//     //     fontWeight: FontWeight.bold,
//     //     fontFamily: "Inter Bold 24",
//     //   ),
//     //   contentTextStyle: TextStyle(
//     //     color: Colors.white70,
//     //     fontFamily: "Inter Regular",
//     //   ),
//     // ),

//     listTileTheme: const ListTileThemeData(
//       textColor: Colors.white,
//       iconColor: Colors.white70,
//     ),
//     switchTheme: SwitchThemeData(
//       thumbColor: WidgetStateProperty.resolveWith((states) {
//         if (states.contains(WidgetState.selected)) return lightPurpleColor3;
//         return Colors.grey;
//       }),
//       trackColor: WidgetStateProperty.resolveWith((states) {
//         if (states.contains(WidgetState.selected)) {
//           return lightPurpleColor3.withOpacity(0.4);
//         }
//         return Colors.grey.withOpacity(0.3);
//       }),
//     ),
//     elevatedButtonTheme: ElevatedButtonThemeData(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: lightPurpleColor,
//         foregroundColor: Colors.white,
//         textStyle: const TextStyle(
//           fontFamily: "Inter Bold 24",
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     ),
//     outlinedButtonTheme: OutlinedButtonThemeData(
//       style: OutlinedButton.styleFrom(
//         foregroundColor: lightPurpleColor,
//         side: BorderSide(color: lightPurpleColor),
//       ),
//     ),
//     snackBarTheme: const SnackBarThemeData(
//       backgroundColor: Color(0xFF334155),
//       contentTextStyle: TextStyle(color: Colors.white),
//     ),
//     floatingActionButtonTheme: FloatingActionButtonThemeData(
//       backgroundColor: lightPurpleColor,
//       foregroundColor: Colors.white,
//     ),
//   );
// }
