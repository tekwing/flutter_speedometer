import 'package:flutter/material.dart';
import 'features/screen/home_screen.dart';

// If using a state manager, you might wrap MaterialApp here.
class SpeedometerApp extends StatelessWidget {
  const SpeedometerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GPS Speedometer',
      debugShowCheckedModeBanner: false,

      // --- THEME CONFIGURATION ---
      // This will eventually connect to your lib/theme/app_themes.dart
      theme: ThemeData.light(useMaterial3: true).copyWith(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.grey.shade100,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
      ),

      // Dark theme is highly recommended as the default for driving apps
      // because it reduces eye strain at night and saves battery on OLED screens.
      darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
        primaryColor: Colors.blueAccent,
        scaffoldBackgroundColor: const Color(
          0xFF121212,
        ), // Deep dark, almost black
        cardColor: const Color(0xFF1E1E1E),
      ),

      // Let the app follow the user's system settings (Light/Dark mode)
      themeMode: ThemeMode.system,

      // --- ROUTING ---
      // For a utility app, setting a direct 'home' is usually fine.
      // If the app gets complex, you can switch to a router package like GoRouter.
      home: const HomeScreen(),
    );
  }
}
