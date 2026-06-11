import 'package:flutter/material.dart';
import 'dart:math' as math;
// You will import your themes here:
import '../../../../theme/speedometer_themes/neon_theme.dart';
import '../../../../theme/speedometer_themes/classic_theme.dart';
import '../../../../theme/speedometer_themes/dashboard_theme.dart';
import '../../../../theme/speedometer_themes/minimal_theme.dart';
import '../../../../theme/speedometer_themes/cyber_hud_theme.dart';
import '../../../../theme/speedometer_themes/f1_racing_theme.dart';
import '../../../../theme/speedometer_themes/aircraft_hud_theme.dart';

enum SpeedometerThemeType {
  classic,
  dashboard,
  minimal,
  neon,
  cyberHud,
  f1,
  aircraftHud,
}

class SpeedometerScreen extends StatefulWidget {
  const SpeedometerScreen({super.key});
  @override
  State<SpeedometerScreen> createState() => _SpeedometerScreenState();
}

class _SpeedometerScreenState extends State<SpeedometerScreen> {
  // --- CORE APP STATE ---
  final double _currentSpeed = 84.0;
  bool _isHudMode = false;
  final int _gpsSignalStrength = 3;
  SpeedometerThemeType _currentTheme =
      SpeedometerThemeType.neon; // Defaulting to neon for testing

  @override
  Widget build(BuildContext context) {
    // HUD Transformation applies to ALL themes automatically
    return Transform(
      alignment: Alignment.center,
      transform: _isHudMode ? Matrix4.rotationX(math.pi) : Matrix4.identity(),
      child: _buildActiveThemeScreen(),
    );
  }

  // --- FULL SCREEN ROUTER ---

  Widget _buildActiveThemeScreen() {
    switch (_currentTheme) {
      case SpeedometerThemeType.neon:
        return NeonThemeScreen(
          currentSpeed: _currentSpeed,
          isHudMode: _isHudMode,
          gpsSignalStrength: _gpsSignalStrength,
          onToggleHud: () => setState(() => _isHudMode = !_isHudMode),
          onOpenThemeSelector: _showThemeSelector,
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
  // This logic stays here so it can update the _currentTheme state
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

                    // 1. Dynamically calculate columns based on screen width
                    int crossAxisCount = 2; // Default for mobile
                    if (screenWidth > 900) {
                      crossAxisCount = 4; // Large tablets / Desktop
                    } else if (screenWidth > 600) {
                      crossAxisCount = 3; // Small tablets / Landscape
                    }

                    // 2. Adjust aspect ratio to keep cards looking like nice rectangles
                    // Higher number = shorter, wider cards. Lower number = taller, squarer cards.
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
        // Triggers rebuild on the main screen to show the new theme
        setState(() {
          _currentTheme = theme;
        });

        // Closes the bottom sheet
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
