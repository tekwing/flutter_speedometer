import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app.dart';

void main() async {
  // 1. Ensure Flutter bindings are initialized before calling native APIs (like GPS or Storage)
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Lock screen orientation
  // Note: Speedometers usually support landscape for dashboard mounting.
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // 3. Initialize Local Storage (Uncomment when you add Hive, Isar, or SharedPreferences)
  // await DatabaseHelper.init();

  // 4. Initialize Background Services (If you want tracking to work while screen is off)
  // await BackgroundService.initialize();

  // 5. Run the application
  runApp(const SpeedometerApp());
}
