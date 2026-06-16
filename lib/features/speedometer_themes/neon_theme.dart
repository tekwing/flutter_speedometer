import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NeonThemeScreen extends StatelessWidget {
  final double currentSpeed;
  final bool isDarkMode; // <-- NEW: Added dark mode toggle

  const NeonThemeScreen({
    super.key,
    required this.currentSpeed,
    required this.isDarkMode, // <-- NEW
  });

  static const Color neonBlue = Color(0xFF00E5FF);
  static const Color neonPurple = Color(0xFF7B61FF);

  // --- DYNAMIC COLORS BASED ON THEME ---
  Color get primaryText => isDarkMode ? Colors.white : Colors.black87;
  Color get secondaryText => isDarkMode ? Colors.white54 : Colors.black54;
  Color get dialCenter =>
      isDarkMode ? const Color(0xFF0D1322) : const Color(0xFFF5F8FA);
  Color get dialBackground => isDarkMode ? Colors.white10 : Colors.black12;
  Color get glassBackground => isDarkMode
      ? Colors.white.withValues(alpha: 0.04)
      : Colors.black.withValues(alpha: 0.03);

  Color get glassBorder => isDarkMode
      ? Colors.white.withValues(alpha: 0.08)
      : Colors.black.withValues(alpha: 0.08);

  Color get cardBackground => isDarkMode
      ? Colors.white.withValues(alpha: 0.05)
      : Colors.black.withValues(alpha: 0.03);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Grid Background (Now passes isDarkMode to the painter)
        Positioned.fill(
          child: CustomPaint(painter: CyberGridPainter(isDarkMode: isDarkMode)),
        ),

        // Top Right Glow
        Positioned(
          top: -100,
          right: -100,
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: neonBlue.withValues(
                alpha: isDarkMode ? .08 : .15,
              ), // Slightly stronger in light mode
            ),
          ),
        ),

        // Bottom Left Glow
        Positioned(
          bottom: -100,
          left: -100,
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: neonPurple.withValues(alpha: isDarkMode ? .08 : .15),
            ),
          ),
        ),

        // Main Content
        Column(
          children: [
            Expanded(child: Center(child: _buildSpeedDial())),
            _buildBottomPanel(),
          ],
        ),
      ],
    );
  }

  Widget _buildSpeedDial() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer glow
        Container(
          width: 340,
          height: 340,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: neonBlue.withValues(alpha: isDarkMode ? .15 : .25),
                blurRadius: 80,
                spreadRadius: 10,
              ),
            ],
          ),
        ),

        // Progress Arc
        SizedBox(
          width: 320,
          height: 320,
          child: CircularProgressIndicator(
            value: (currentSpeed / 240).clamp(0.0, 1.0),
            strokeWidth: 10,
            backgroundColor: dialBackground, // Dynamic
            valueColor: const AlwaysStoppedAnimation(neonBlue),
          ),
        ),

        // Inner Dial Center
        Container(
          width: 250,
          height: 250,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: dialCenter, // Dynamic
            border: Border.all(color: neonBlue.withValues(alpha: .2), width: 2),
          ),
        ),

        // Inner Purple Ring
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: neonPurple.withValues(alpha: .15)),
          ),
        ),

        // Speed Text
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              currentSpeed.toStringAsFixed(0),
              style: GoogleFonts.orbitron(
                fontSize: 96,
                fontWeight: FontWeight.w900,
                color: primaryText, // Dynamic
                height: 1,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "KM/H",
              style: TextStyle(
                color: neonBlue,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 6,
              ),
            ),

            const SizedBox(height: 15),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: neonBlue.withValues(alpha: .1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "LIVE TRACKING",
                style: TextStyle(
                  color: neonBlue,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomPanel() {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: glassBackground, // Dynamic
            border: Border(
              top: BorderSide(color: glassBorder), // Dynamic
            ),
          ),
          child: Row(
            children: [
              Expanded(child: _statCard(Icons.route, "TRIP", "14.2 km")),
              const SizedBox(width: 12),
              Expanded(child: _statCard(Icons.speed, "MAX", "128")),
              const SizedBox(width: 12),
              Expanded(child: _statCard(Icons.location_on, "GPS", "±5m")),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statCard(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBackground, // Dynamic
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: neonBlue.withValues(alpha: .15)),
      ),
      child: Column(
        children: [
          Icon(icon, color: neonBlue, size: 22),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: secondaryText, // Dynamic
              fontSize: 11,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              color: primaryText, // Dynamic
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class CyberGridPainter extends CustomPainter {
  final bool isDarkMode;

  const CyberGridPainter({required this.isDarkMode});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      // Make the grid slightly more visible in light mode so it doesn't wash out
      ..color = isDarkMode
          ? Colors.cyanAccent.withValues(alpha: .04)
          : Colors.cyan.withValues(alpha: .12)
      ..strokeWidth = 1;

    for (double x = 0; x < size.width; x += 30) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (double y = 0; y < size.height; y += 30) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // Only repaint if the theme mode actually changes
    if (oldDelegate is CyberGridPainter) {
      return oldDelegate.isDarkMode != isDarkMode;
    }
    return false;
  }
}
