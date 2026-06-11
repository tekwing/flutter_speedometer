import 'dart:math' as math;
import 'package:flutter/material.dart';

class ClassicThemeScreen extends StatelessWidget {
  final double currentSpeed;
  final bool isHudMode;
  final int gpsSignalStrength;
  final VoidCallback onToggleHud;
  final VoidCallback onOpenThemeSelector;

  const ClassicThemeScreen({
    super.key,
    required this.currentSpeed,
    required this.isHudMode,
    required this.gpsSignalStrength,
    required this.onToggleHud,
    required this.onOpenThemeSelector,
  });

  @override
  Widget build(BuildContext context) {
    final speed = currentSpeed.clamp(0, 220);

    return Scaffold(
      backgroundColor: const Color(0xFF0B1220),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "CLASSIC ANALOG",
          style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: Icon(isHudMode ? Icons.wb_sunny_outlined : Icons.flip),
            onPressed: onToggleHud,
          ),
          IconButton(
            icon: const Icon(Icons.palette_outlined),
            onPressed: onOpenThemeSelector,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(.12),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.green.withOpacity(.4)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.gps_fixed, color: Colors.green, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    "GPS $gpsSignalStrength/5",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              flex: 6,
              child: Center(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 700),
                    tween: Tween<double>(begin: 0.0, end: speed.toDouble()),
                    builder: (context, animatedSpeed, child) {
                      return CustomPaint(
                        painter: SpeedometerPainter(
                          speed: animatedSpeed,
                          maxSpeed: 220,
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                animatedSpeed.toStringAsFixed(0),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 72,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                "KM/H",
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 16,
                                  letterSpacing: 4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _infoCard(Icons.route, "TRIP", "14.2 km"),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: _infoCard(Icons.speed, "MAX", "110")),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _infoCard(Icons.timer_outlined, "AVG", "82"),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _infoCard(Icons.satellite_alt, "SAT", "14"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF131C2E),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(.06)),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.cyanAccent, size: 24),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white54,
              letterSpacing: 2,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class SpeedometerPainter extends CustomPainter {
  final double speed;
  final double maxSpeed;

  SpeedometerPainter({required this.speed, required this.maxSpeed});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final radius = size.width * .42;

    final bgPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 22
      ..color = Colors.white.withOpacity(.08);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi * .75,
      math.pi * 1.5,
      false,
      bgPaint,
    );

    final progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 22
      ..shader = const LinearGradient(
        colors: [Colors.green, Colors.orange, Colors.red],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    final sweep = (speed / maxSpeed) * (math.pi * 1.5);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi * .75,
      sweep,
      false,
      progressPaint,
    );

    for (int i = 0; i <= 22; i++) {
      final angle = math.pi * .75 + (i / 22) * math.pi * 1.5;

      final outer = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );

      final inner = Offset(
        center.dx + (radius - 18) * math.cos(angle),
        center.dy + (radius - 18) * math.sin(angle),
      );

      canvas.drawLine(
        outer,
        inner,
        Paint()
          ..color = Colors.white70
          ..strokeWidth = 2,
      );

      final value = (i * 10).toString();

      final textPainter = TextPainter(
        text: TextSpan(
          text: value,
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      final textOffset = Offset(
        center.dx + (radius - 42) * math.cos(angle) - textPainter.width / 2,
        center.dy + (radius - 42) * math.sin(angle) - textPainter.height / 2,
      );

      textPainter.paint(canvas, textOffset);
    }

    final needleAngle = math.pi * .75 + (speed / maxSpeed) * (math.pi * 1.5);

    final needleEnd = Offset(
      center.dx + (radius - 45) * math.cos(needleAngle),
      center.dy + (radius - 45) * math.sin(needleAngle),
    );

    canvas.drawLine(
      center,
      needleEnd,
      Paint()
        ..color = Colors.redAccent
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round,
    );

    canvas.drawCircle(center, 12, Paint()..color = Colors.white);

    canvas.drawCircle(center, 6, Paint()..color = Colors.redAccent);
  }

  @override
  bool shouldRepaint(covariant SpeedometerPainter oldDelegate) {
    return oldDelegate.speed != speed;
  }
}
