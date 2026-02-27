import 'package:flutter/material.dart';
import 'package:quickpalo/features/splash/presentation/pages/splash_screen.dart';
import 'package:quickpalo/app/theme/theme_data.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuickPalo',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      theme: getApplicationTheme(),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:quickpalo/features/splash/presentation/pages/splash_screen.dart';
// import 'package:quickpalo/app/theme/theme_data.dart';
// import 'package:quickpalo/app/theme/theme_provider.dart';

// class App extends ConsumerStatefulWidget {
//   const App({super.key});

//   @override
//   ConsumerState<App> createState() => _AppState();
// }

// class _AppState extends ConsumerState<App> {
//   @override
//   Widget build(BuildContext context) {
//     final isDark = ref.watch(themeModeProvider);

//     return MaterialApp(
//       title: 'QuickPalo',
//       debugShowCheckedModeBanner: false,
//       home: SplashScreen(),
//       theme: getApplicationTheme(),
//       darkTheme: getApplicationDarkTheme(),
//       themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
//     );
//   }
// }
