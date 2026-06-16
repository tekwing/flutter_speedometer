import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

// You will import your themes here:
import '../speedometer_themes/neon_theme.dart';
import '../speedometer_themes/classic_theme.dart';
import '../speedometer_themes/dashboard_theme.dart';
import '../speedometer_themes/minimal_theme.dart';
import '../speedometer_themes/cyber_hud_theme.dart';
import '../speedometer_themes/f1_racing_theme.dart';
import '../speedometer_themes/aircraft_hud_theme.dart';

// Your new extracted menu widget
import '../../widgets/settings_menu.dart';
import '../../core/speedometer_theme_type.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isDarkMode = true;
  // --- CORE APP STATE ---
  final double _currentSpeed = 84.0;
  final int _gpsSignalStrength = 3;

  // --- SETTINGS STATE ---
  bool _isHudMode = false;
  bool _isFullScreen = false;
  String _speedUnit = "KM/H";
  SpeedometerThemeType _currentTheme = SpeedometerThemeType.neon;

  // --- NAVIGATION STATE ---
  int _currentNavIndex = 0;

  // Dynamic color helpers based on mode
  Color get _scaffoldBgColor =>
      _isDarkMode ? const Color(0xFF050816) : const Color(0xFFE5E9F0);
  Color get _navBarBgColor =>
      _isDarkMode ? const Color(0xFF0A0E17) : Colors.white;
  Color get _navBarUnselectedColor =>
      _isDarkMode ? Colors.white54 : Colors.black45;
  @override
  Widget build(BuildContext context) {
    // HUD Transformation applies to the entire Scaffold so the reflection is perfect
    return Transform(
      alignment: Alignment.center,
      transform: _isHudMode ? Matrix4.rotationX(math.pi) : Matrix4.identity(),
      child: Scaffold(
        backgroundColor: _scaffoldBgColor,
        body: SafeArea(
          child: Column(
            children: [
              // 1. The Global Top Bar
              _buildTopBar(),

              // 2. The Dynamic Speedometer Theme
              Expanded(child: _buildActiveThemeScreen()),
            ],
          ),
        ),

        // 3. The Global Bottom Navigation Bar
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  // --- GLOBAL TOP BAR ---
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left Side: Dot-based GPS Signal
          Row(
            children: [
              const Icon(Icons.gps_fixed, color: Colors.white70, size: 18),
              const SizedBox(width: 8),
              Row(
                children: List.generate(5, (index) {
                  return Container(
                    margin: const EdgeInsets.only(right: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      // Colors dots green if index is less than signal strength, otherwise dull grey
                      color: index < _gpsSignalStrength
                          ? Colors.greenAccent
                          : Colors.white24,
                      boxShadow: index < _gpsSignalStrength
                          ? [
                              BoxShadow(
                                color: Colors.greenAccent.withOpacity(0.5),
                                blurRadius: 4,
                                spreadRadius: 1,
                              ),
                            ]
                          : [],
                    ),
                  );
                }),
              ),
            ],
          ),

          // Right Side: Start Trip Button
          ElevatedButton.icon(
            onPressed: () {
              // TODO: Implement Start Trip Logic
            },
            icon: const Icon(Icons.play_arrow_rounded, size: 20),
            label: const Text(
              "START TRIP",
              style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- GLOBAL BOTTOM NAVIGATION ---
  Widget _buildBottomNavigationBar() {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: BottomNavigationBar(
        backgroundColor: _navBarBgColor,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentNavIndex,
        selectedItemColor: Colors.cyanAccent.shade400,
        unselectedItemColor: _navBarUnselectedColor,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        onTap: (index) {
          if (index == 3) {
            // INTERCEPT MENU TAP: Open the settings bottom sheet
            _showSettingsMenu();
          } else {
            // SWITCH TABS: Update navigation state for other icons
            setState(() {
              _currentNavIndex = index;
            });
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.route), label: 'Trip'),
          BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: 'Map'),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_rounded),
            label: 'Menu',
          ),
        ],
      ),
    );
  }

  // --- SETTINGS MENU BOTTOM SHEET ---
  void _showSettingsMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled:
          true, // Crucial: Allows the 0.55 height constraint in SettingsMenu to work
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (context) {
        return SettingsMenu(
          initialHudMode: _isHudMode,
          initialFullScreen: _isFullScreen,
          initialSpeedUnit: _speedUnit,
          currentTheme: _currentTheme, // Pass current theme
          initialDarkMode: _isDarkMode,
          onHudModeChanged: (value) => setState(() => _isHudMode = value),
          onFullScreenChanged: (value) => setState(() => _isFullScreen = value),
          onSpeedUnitChanged: (value) => setState(() => _speedUnit = value),
          onThemeChanged: (value) =>
              setState(() => _currentTheme = value), // Update theme
          onDarkModeChanged: (value) => setState(() => _isDarkMode = value),
        );
      },
    );
  }

  // --- FULL SCREEN ROUTER ---
  Widget _buildActiveThemeScreen() {
    switch (_currentTheme) {
      case SpeedometerThemeType.neon:
        return NeonThemeScreen(
          currentSpeed: _currentSpeed,
          isDarkMode: _isDarkMode,
        );
      case SpeedometerThemeType.dashboard:
        return DashboardThemeScreen(
          currentSpeed: _currentSpeed,
          isHudMode: _isHudMode,
          gpsSignalStrength: _gpsSignalStrength,
          onToggleHud: () => setState(() => _isHudMode = !_isHudMode),
          onOpenThemeSelector: _showThemeSelector,
        );
      case SpeedometerThemeType.minimal:
        return MinimalThemeScreen(
          currentSpeed: _currentSpeed,
          isHudMode: _isHudMode,
          gpsSignalStrength: _gpsSignalStrength,
          onToggleHud: () => setState(() => _isHudMode = !_isHudMode),
          onOpenThemeSelector: _showThemeSelector,
        );
      case SpeedometerThemeType.cyberHud:
        return CyberHudThemeScreen(
          currentSpeed: _currentSpeed,
          isHudMode: _isHudMode,
          gpsSignalStrength: _gpsSignalStrength,
          onToggleHud: () => setState(() => _isHudMode = !_isHudMode),
          onOpenThemeSelector: _showThemeSelector,
        );
      case SpeedometerThemeType.f1:
        return F1RacingThemeScreen(
          currentSpeed: _currentSpeed,
          isHudMode: _isHudMode,
          gpsSignalStrength: _gpsSignalStrength,
          onToggleHud: () => setState(() => _isHudMode = !_isHudMode),
          onOpenThemeSelector: _showThemeSelector,
        );
      case SpeedometerThemeType.aircraftHud:
        return AircraftHudThemeScreen(
          currentSpeed: _currentSpeed,
          isHudMode: _isHudMode,
          gpsSignalStrength: _gpsSignalStrength,
          onToggleHud: () => setState(() => _isHudMode = !_isHudMode),
          onOpenThemeSelector: _showThemeSelector,
        );
      case SpeedometerThemeType.classic:
        return ClassicThemeScreen(
          currentSpeed: _currentSpeed,
          isHudMode: _isHudMode,
          gpsSignalStrength: _gpsSignalStrength,
          onToggleHud: () => setState(() => _isHudMode = !_isHudMode),
          onOpenThemeSelector: _showThemeSelector,
        );
    }
  }

  // --- THEME SELECTOR BOTTOM SHEET ---
  void _showThemeSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0A0E17),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          height: MediaQuery.of(context).size.height * 0.55,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: SizedBox(
                  width: 50,
                  child: Divider(thickness: 4, color: Colors.white24),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Choose Theme",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Customize your speedometer experience",
                style: TextStyle(color: Colors.white54),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final screenWidth = constraints.maxWidth;

                    int crossAxisCount = 2;
                    if (screenWidth > 900) {
                      crossAxisCount = 4;
                    } else if (screenWidth > 600) {
                      crossAxisCount = 3;
                    }

                    double aspectRatio = screenWidth > 600 ? 2.5 : 1.8;

                    return GridView.builder(
                      itemCount: SpeedometerThemeType.values.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: aspectRatio,
                      ),
                      itemBuilder: (context, index) {
                        final theme = SpeedometerThemeType.values[index];
                        String title;
                        IconData icon;
                        Color color;

                        switch (theme) {
                          case SpeedometerThemeType.neon:
                            title = "NEON";
                            icon = Icons.bolt;
                            color = Colors.cyanAccent;
                            break;
                          case SpeedometerThemeType.classic:
                            title = "CLASSIC";
                            icon = Icons.speed;
                            color = Colors.orange;
                            break;
                          case SpeedometerThemeType.minimal:
                            title = "MINIMAL";
                            icon = Icons.circle_outlined;
                            color = Colors.white;
                            break;
                          case SpeedometerThemeType.dashboard:
                            title = "DASHBOARD";
                            icon = Icons.dashboard;
                            color = Colors.blueAccent;
                            break;
                          case SpeedometerThemeType.cyberHud:
                            title = "CYBER HUD";
                            icon = Icons.memory;
                            color = Colors.purpleAccent;
                            break;
                          case SpeedometerThemeType.f1:
                            title = "F1 RACING";
                            icon = Icons.sports_score;
                            color = Colors.redAccent;
                            break;
                          case SpeedometerThemeType.aircraftHud:
                            title = "AIRCRAFT";
                            icon = Icons.airplanemode_active;
                            color = Colors.greenAccent;
                            break;
                        }

                        return _themeCard(
                          theme: theme,
                          title: title,
                          icon: icon,
                          color: color,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _themeCard({
    required SpeedometerThemeType theme,
    required String title,
    required IconData icon,
    required Color color,
  }) {
    final bool selected = _currentTheme == theme;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentTheme = theme;
        });
        Navigator.pop(context);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          color: const Color(0xFF121826),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: selected ? color : Colors.white10,
            width: selected ? 2.5 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: color.withOpacity(.4),
                    blurRadius: 25,
                    spreadRadius: 2,
                  ),
                ]
              : [],
        ),
        child: Stack(
          children: [
            if (selected)
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, size: 14, color: Colors.black),
                ),
              ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 28, color: color),
                  const SizedBox(width: 12),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
