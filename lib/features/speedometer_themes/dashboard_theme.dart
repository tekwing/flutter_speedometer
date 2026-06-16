import 'package:flutter/material.dart';
import 'dart:math' as math;

class DashboardThemeScreen extends StatelessWidget {
  final double currentSpeed;
  final bool isHudMode;
  final int gpsSignalStrength;
  final VoidCallback onToggleHud;
  final VoidCallback onOpenThemeSelector;

  const DashboardThemeScreen({
    super.key,
    required this.currentSpeed,
    required this.isHudMode,
    required this.gpsSignalStrength,
    required this.onToggleHud,
    required this.onOpenThemeSelector,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFF080B14,
      ), // Dark matte grey like a car dashboard
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(
              isHudMode ? Icons.wb_sunny : Icons.flip_to_back,
              color: Colors.orangeAccent,
            ),
            onPressed: onToggleHud,
          ),
          IconButton(
            icon: const Icon(Icons.palette),
            onPressed: onOpenThemeSelector,
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            top: -120,
            right: -100,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.orange.withOpacity(.12),
              ),
            ),
          ),

          Positioned(
            bottom: -120,
            left: -100,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red.withOpacity(.08),
              ),
            ),
          ),

          Column(
            children: [
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),

                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.05),
                  borderRadius: BorderRadius.circular(30),
                ),

                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.gps_fixed, color: Colors.green, size: 16),

                    const SizedBox(width: 8),

                    Text(
                      "GPS LOCK • $gpsSignalStrength/5",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              // --- ANALOG GAUGE ---
              Expanded(
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 300,
                        height: 300,
                        child: CustomPaint(
                          painter: SpeedometerPainter(
                            speed: currentSpeed,
                            maxSpeed: 240,
                          ),
                        ),
                      ),
                      // Digital fallback in the center bottom of the dial
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            currentSpeed.toStringAsFixed(0),
                            style: const TextStyle(
                              fontSize: 82,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              height: 1,
                            ),
                          ),

                          const SizedBox(height: 4),

                          const Text(
                            "KM/H",
                            style: TextStyle(
                              color: Colors.white54,
                              letterSpacing: 5,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // --- SIMPLE DASH STATS ---
              Container(
                padding: const EdgeInsets.symmetric(vertical: 32),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.white12)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _modernCard(Icons.route, "TRIP", "14.2 km"),
                    ),

                    const SizedBox(width: 12),

                    Expanded(child: _modernCard(Icons.speed, "MAX", "118")),

                    const SizedBox(width: 12),

                    Expanded(
                      child: _modernCard(
                        Icons.gps_fixed,
                        "GPS",
                        "$gpsSignalStrength",
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _modernCard(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.05),

        borderRadius: BorderRadius.circular(24),

        border: Border.all(color: Colors.white12),
      ),

      child: Column(
        children: [
          Icon(icon, color: Colors.orangeAccent),

          const SizedBox(height: 10),

          Text(
            title,
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),

          const SizedBox(height: 6),

          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashStat(String label, String val, String unit) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 12,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$val $unit',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// --- CUSTOM PAINTER FOR THE ANALOG DIAL ---
class SpeedometerPainter extends CustomPainter {
  final double speed;
  final double maxSpeed;

  SpeedometerPainter({required this.speed, required this.maxSpeed});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw Background Arc
    final bgPaint = Paint()
      ..color = Colors.white12
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    // We draw from 140 degrees (bottom left) to 40 degrees (bottom right)
    const startAngle = math.pi * 0.8;
    const sweepAngle = math.pi * 1.4;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      bgPaint,
    );

    // Draw Active Speed Arc (Orange)
    final activePaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xff00E5FF), Color(0xff6C63FF), Color(0xffFF6B35)],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;
    for (int i = 0; i <= 40; i++) {
      final angle = startAngle + (sweepAngle / 40) * i;

      final p1 = Offset(
        center.dx + (radius - 18) * math.cos(angle),
        center.dy + (radius - 18) * math.sin(angle),
      );

      final p2 = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );

      canvas.drawLine(
        p1,
        p2,
        Paint()
          ..color = Colors.white24
          ..strokeWidth = 2,
      );
    }

    final currentSweep = (speed.clamp(0, maxSpeed) / maxSpeed) * sweepAngle;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      currentSweep,
      false,
      activePaint,
    );

    // Draw the Needle
    final needleAngle = startAngle + currentSweep;
    final needleLength = radius - 20;

    final needlePaint = Paint()
      ..color = Colors.redAccent
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    final needleEnd = Offset(
      center.dx + needleLength * math.cos(needleAngle),
      center.dy + needleLength * math.sin(needleAngle),
    );

    canvas.drawCircle(needleEnd, 10, Paint()..color = Colors.orangeAccent);

    // Draw center pin
    canvas.drawCircle(center, 12, Paint()..color = Colors.redAccent);
    canvas.drawCircle(center, 6, Paint()..color = Colors.black);
  }

  @override
  bool shouldRepaint(covariant SpeedometerPainter oldDelegate) {
    return oldDelegate.speed != speed;
  }
}
