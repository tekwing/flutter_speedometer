import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/speedometer_theme_type.dart';

class SettingsMenu extends StatefulWidget {
  final bool initialHudMode;
  final bool initialFullScreen;
  final String initialSpeedUnit;
  final SpeedometerThemeType currentTheme;
  final bool initialDarkMode; // <-- NEW

  final ValueChanged<bool> onHudModeChanged;
  final ValueChanged<bool> onFullScreenChanged;
  final ValueChanged<String> onSpeedUnitChanged;
  final ValueChanged<SpeedometerThemeType> onThemeChanged;
  final ValueChanged<bool> onDarkModeChanged; // <-- NEW

  const SettingsMenu({
    super.key,
    required this.initialHudMode,
    required this.initialFullScreen,
    required this.initialSpeedUnit,
    required this.currentTheme,
    required this.initialDarkMode,
    required this.onHudModeChanged,
    required this.onFullScreenChanged,
    required this.onSpeedUnitChanged,
    required this.onThemeChanged,
    required this.onDarkModeChanged,
  });

  @override
  State<SettingsMenu> createState() => _SettingsMenuState();
}

class _SettingsMenuState extends State<SettingsMenu> {
  late bool _isHudMode;
  late bool _isFullScreen;
  late String _speedUnit;
  late SpeedometerThemeType _activeTheme;
  late bool _isDarkMode; // <-- NEW

  bool _isSelectingTheme = false;

  @override
  void initState() {
    super.initState();
    _isHudMode = widget.initialHudMode;
    _isFullScreen = widget.initialFullScreen;
    _speedUnit = widget.initialSpeedUnit;
    _activeTheme = widget.currentTheme;
    _isDarkMode = widget.initialDarkMode;
  }

  // Dynamic color helpers based on mode
  Color get bgColor => _isDarkMode ? const Color(0xFF0A0E17) : Colors.white;
  Color get cardColor =>
      _isDarkMode ? const Color(0xFF121826) : const Color(0xFFF5F7FA);
  Color get textColor => _isDarkMode ? Colors.white : Colors.black87;
  Color get subTextColor => _isDarkMode ? Colors.white54 : Colors.black54;
  Color get dividerColor => _isDarkMode ? Colors.white24 : Colors.black12;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.55,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        child: _isSelectingTheme
            ? _buildThemeSelector(key: const ValueKey('ThemeGrid'))
            : _buildSettingsList(key: const ValueKey('SettingsList')),
      ),
    );
  }

  Widget _buildSettingsList({required Key key}) {
    return SingleChildScrollView(
      key: key,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: SizedBox(
              width: 50,
              child: Divider(thickness: 4, color: dividerColor),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Settings",
            style: TextStyle(
              color: textColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),

          // NEW: Dark Mode Toggle
          _menuSwitchTile(
            icon: _isDarkMode ? Icons.dark_mode : Icons.light_mode,
            title: "Dark Mode",
            subtitle: "Toggle app appearance",
            value: _isDarkMode,
            onChanged: (bool value) {
              setState(() => _isDarkMode = value);
              widget.onDarkModeChanged(value);
            },
          ),

          _menuSwitchTile(
            icon: Icons.flip,
            title: "HUD Reflection Mode",
            subtitle: "Mirrors screen for windshield viewing",
            value: _isHudMode,
            onChanged: (bool value) {
              setState(() => _isHudMode = value);
              widget.onHudModeChanged(value);
            },
          ),

          _menuSwitchTile(
            icon: Icons.fullscreen,
            title: "Full Screen Mode",
            subtitle: "Hide device status and navigation bars",
            value: _isFullScreen,
            onChanged: (bool value) {
              setState(() => _isFullScreen = value);
              widget.onFullScreenChanged(value);
              if (value) {
                SystemChrome.setEnabledSystemUIMode(
                  SystemUiMode.immersiveSticky,
                );
              } else {
                SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
              }
            },
          ),

          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.speed, color: subTextColor),
            title: Text(
              "Speed Unit",
              style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
            ),
            trailing: DropdownButton<String>(
              value: _speedUnit,
              dropdownColor: cardColor,
              style: const TextStyle(
                color: Colors.cyanAccent,
                fontWeight: FontWeight.bold,
              ),
              underline: const SizedBox(),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.cyanAccent),
              items: ["KM/H", "MPH", "KNOTS"].map((String unit) {
                return DropdownMenuItem<String>(value: unit, child: Text(unit));
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() => _speedUnit = newValue);
                  widget.onSpeedUnitChanged(newValue);
                }
              },
            ),
          ),

          Divider(color: dividerColor.withOpacity(0.1), height: 32),

          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.palette, color: subTextColor),
            title: Text(
              "Change Theme",
              style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
            ),
            trailing: Icon(Icons.chevron_right, color: subTextColor),
            onTap: () => setState(() => _isSelectingTheme = true),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeSelector({required Key key}) {
    return Padding(
      key: key,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back, color: textColor),
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
                onPressed: () => setState(() => _isSelectingTheme = false),
              ),
              Text(
                "Choose Theme",
                style: TextStyle(
                  color: textColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 48, bottom: 24),
            child: Text(
              "Customize your speedometer experience",
              style: TextStyle(color: subTextColor),
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final screenWidth = constraints.maxWidth;
                int crossAxisCount = screenWidth > 900
                    ? 4
                    : (screenWidth > 600 ? 3 : 2);
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
                        color = _isDarkMode ? Colors.white : Colors.black87;
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
  }

  Widget _themeCard({
    required SpeedometerThemeType theme,
    required String title,
    required IconData icon,
    required Color color,
  }) {
    final bool selected = _activeTheme == theme;

    return GestureDetector(
      onTap: () {
        setState(() => _activeTheme = theme);
        widget.onThemeChanged(theme);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: selected ? color : dividerColor,
            width: selected ? 2.5 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: color.withOpacity(.3),
                    blurRadius: 20,
                    spreadRadius: 1,
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
                  child: const Icon(Icons.check, size: 14, color: Colors.white),
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
                    style: TextStyle(
                      color: textColor,
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

  Widget _menuSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: SwitchListTile(
        contentPadding: EdgeInsets.zero,
        activeColor: Colors.cyanAccent,
        secondary: Icon(icon, color: subTextColor),
        title: Text(
          title,
          style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: subTextColor, fontSize: 12),
        ),
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
