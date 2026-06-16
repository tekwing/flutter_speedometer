import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PlasmaWaveThemeScreen extends StatelessWidget {
  final double currentSpeed;
  final bool isHudMode;
  final int gpsSignalStrength;
  final double tripDistanceKm;
  final double heading;
  final double altitude;
  final VoidCallback onToggleHud;
  final VoidCallback onOpenThemeSelector;

  const PlasmaWaveThemeScreen({
    super.key,
    required this.currentSpeed,
    required this.isHudMode,
    required this.gpsSignalStrength,
    required this.heading,
    required this.altitude,
    required this.tripDistanceKm,
    required this.onToggleHud,
    required this.onOpenThemeSelector,
  });

  // --- THEME COLORS ---
  // Using the Amber/Orange from the center reference image
  static const Color themeColor = Color(0xFFFFB300);
  static const Color bgDark = Color(0xFF1E2130); // Deep navy/gray
  static const Color textMuted = Color(0xFF8A8D9F);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgDark,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopHeader(),

            // Flexible space for the main gauge
            Expanded(flex: 5, child: Center(child: _buildMainGauge())),

            // The glowing wave separator
            SizedBox(
              height: 40,
              width: double.infinity,
              child: CustomPaint(
                painter: GlowingWavePainter(color: themeColor),
              ),
            ),

            // Bottom Telemetry Stats
            Expanded(flex: 2, child: _buildBottomStats()),
          ],
        ),
      ),
    );
  }

  Widget _buildTopHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: GPS Indicator (styled to match the minimal aesthetic)
          Row(
            children: [
              Icon(
                Icons.navigation_rounded,
                size: 16,
                color: gpsSignalStrength > 2 ? themeColor : Colors.redAccent,
              ),
              const SizedBox(width: 4),
              Text(
                "GPS",
                style: GoogleFonts.oswald(
                  color: textMuted,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          // Center: Main Title from the reference image
          Text(
            "HOW FAST?",
            style: GoogleFonts.oswald(
              color: themeColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
            ),
          ),

          // Right: Controls
          Row(
            children: [
              IconButton(
                icon: Icon(
                  isHudMode
                      ? Icons.flip_to_back_rounded
                      : Icons.flip_to_front_rounded,
                  color: textMuted,
                  size: 20,
                ),
                onPressed: onToggleHud,
              ),
              IconButton(
                icon: const Icon(
                  Icons.palette_rounded,
                  color: textMuted,
                  size: 20,
                ),
                onPressed: onOpenThemeSelector,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMainGauge() {
    // Smooth animation for the speed updates
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: currentSpeed),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      builder: (context, animatedSpeed, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // The Gauge Custom Painter
            SizedBox(
              width: 300,
              height: 300,
              child: CustomPaint(
                painter: PlasmaGaugePainter(
                  speed: animatedSpeed,
                  maxSpeed: 240, // Adjust based on your app's needs
                  themeColor: themeColor,
                ),
              ),
            ),

            // The Center Text
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  animatedSpeed.toStringAsFixed(0),
                  style: GoogleFonts.oswald(
                    color: Colors.white,
                    fontSize: 84,
                    height: 1.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "kmh",
                  style: GoogleFonts.oswald(
                    color: textMuted,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildBottomStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatColumn(
            "${tripDistanceKm.toStringAsFixed(1)} km",
            "DISTANCE",
          ),
          _buildStatColumn("${altitude.toStringAsFixed(0)} m", "ALTITUDE"),
          _buildStatColumn("${heading.toStringAsFixed(0)}°", "HEADING"),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: GoogleFonts.oswald(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.oswald(
            color: themeColor, // Colored tiny labels just like the reference
            fontSize: 9,
            letterSpacing: 1.2,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

// ==========================================
// CUSTOM PAINTERS
// ==========================================

class PlasmaGaugePainter extends CustomPainter {
  final double speed;
  final double maxSpeed;
  final Color themeColor;

  PlasmaGaugePainter({
    required this.speed,
    required this.maxSpeed,
    required this.themeColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // The arc starts on the bottom left and goes to the bottom right
    const startAngle = math.pi * 0.75;
    const sweepAngle = math.pi * 1.5;

    // 1. Draw the faint background track
    final bgTrackPaint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      bgTrackPaint,
    );

    // 2. Draw the tick marks
    final tickPaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    const int tickCount = 40;
    for (int i = 0; i <= tickCount; i++) {
      final double angle = startAngle + (i / tickCount) * sweepAngle;
      // Make every 5th tick slightly longer/brighter
      final bool isMajor = i % 5 == 0;
      final double tickLength = isMajor ? 12.0 : 6.0;
      final double innerRadius = radius - 20;

      tickPaint.color = isMajor
          ? Colors.white.withOpacity(0.5)
          : Colors.white.withOpacity(0.15);

      final p1 = Offset(
        center.dx + innerRadius * math.cos(angle),
        center.dy + innerRadius * math.sin(angle),
      );
      final p2 = Offset(
        center.dx + (innerRadius - tickLength) * math.cos(angle),
        center.dy + (innerRadius - tickLength) * math.sin(angle),
      );
      canvas.drawLine(p1, p2, tickPaint);
    }

    // 3. Draw the Glowing Active Track
    final double fillPercentage = (speed / maxSpeed).clamp(0.0, 1.0);
    final double activeSweepAngle = sweepAngle * fillPercentage;

    if (activeSweepAngle > 0) {
      // The solid inner core of the glowing line
      final activeTrackPaint = Paint()
        ..color = themeColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 12
        ..strokeCap = StrokeCap.round;

      // The blurred outer glow
      final glowPaint = Paint()
        ..color = themeColor.withOpacity(0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 20
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);

      final rect = Rect.fromCircle(center: center, radius: radius);

      canvas.drawArc(rect, startAngle, activeSweepAngle, false, glowPaint);
      canvas.drawArc(
        rect,
        startAngle,
        activeSweepAngle,
        false,
        activeTrackPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant PlasmaGaugePainter oldDelegate) {
    return oldDelegate.speed != speed || oldDelegate.themeColor != themeColor;
  }
}

class GlowingWavePainter extends CustomPainter {
  final Color color;

  GlowingWavePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();

    // Start at bottom left
    path.moveTo(0, size.height);

    // Create a smooth flowing bezier curve resembling the reference image
    path.cubicTo(
      size.width * 0.25,
      size.height, // Control point 1
      size.width * 0.4,
      0, // Control point 2 (peaks up)
      size.width * 0.5,
      0, // Anchor point (top dead center)
    );
    path.cubicTo(
      size.width * 0.6,
      0, // Control point 3
      size.width * 0.75,
      size.height, // Control point 4 (dips back down)
      size.width,
      size.height, // Anchor point (bottom right)
    );

    // The solid sharp line
    final linePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // The glowing shadow beneath it
    final glowPaint = Paint()
      ..color = color.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    canvas.drawPath(path, glowPaint);
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
