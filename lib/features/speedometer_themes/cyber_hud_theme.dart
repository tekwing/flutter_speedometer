import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

class CyberHudThemeScreen extends StatelessWidget {
  final double currentSpeed;
  final bool isHudMode;
  final int gpsSignalStrength;
  final VoidCallback onToggleHud;
  final VoidCallback onOpenThemeSelector;

  const CyberHudThemeScreen({
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
      backgroundColor: const Color(0xff04070D),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,

        actions: [
          IconButton(
            icon: const Icon(Icons.flip, color: Color(0xff00E5FF)),
            onPressed: onToggleHud,
          ),
          IconButton(
            icon: const Icon(Icons.palette, color: Color(0xff00E5FF)),
            onPressed: onOpenThemeSelector,
          ),
        ],
      ),

      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),

            Text(
              "CYBER HUD",
              style: GoogleFonts.orbitron(
                color: const Color(0xff00E5FF),
                letterSpacing: 4,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: Center(
                child: SizedBox(
                  width: 320,
                  height: 320,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CustomPaint(
                        size: const Size(320, 320),
                        painter: CyberGaugePainter(
                          speed: currentSpeed,
                          maxSpeed: 240,
                        ),
                      ),

                      Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withOpacity(.5),
                          border: Border.all(
                            color: const Color(0xff00E5FF),
                            width: 2,
                          ),
                          boxShadow: const [
                            BoxShadow(color: Color(0xff00E5FF), blurRadius: 20),
                          ],
                        ),
                      ),

                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            currentSpeed.toStringAsFixed(0),
                            style: GoogleFonts.orbitron(
                              fontSize: 72,
                              color: const Color(0xff00E5FF),
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          Text(
                            "KM/H",
                            style: GoogleFonts.orbitron(
                              color: Colors.white70,
                              letterSpacing: 3,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: _glassCard(
                      title: "GPS",
                      value: gpsSignalStrength.toString(),
                      icon: Icons.gps_fixed,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: _glassCard(
                      title: "SAT",
                      value: "12",
                      icon: Icons.satellite_alt,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _bottomPanel(),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _glassCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.05),

        borderRadius: BorderRadius.circular(20),

        border: Border.all(color: const Color(0xff00E5FF).withOpacity(.3)),
      ),

      child: Column(
        children: [
          Icon(icon, color: const Color(0xff00E5FF)),

          const SizedBox(height: 8),

          Text(
            title,
            style: GoogleFonts.orbitron(color: Colors.white70, fontSize: 12),
          ),

          const SizedBox(height: 4),

          Text(
            value,
            style: GoogleFonts.orbitron(color: Colors.white, fontSize: 22),
          ),
        ],
      ),
    );
  }

  Widget _bottomPanel() {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),

        color: Colors.white.withOpacity(.04),

        border: Border.all(color: const Color(0xff00E5FF).withOpacity(.3)),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _info("TRIP", "24.5"),
          _info("AVG", "78"),
          _info("MAX", "126"),
        ],
      ),
    );
  }

  Widget _info(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.orbitron(color: Colors.white54, fontSize: 12),
        ),

        const SizedBox(height: 6),

        Text(
          value,
          style: GoogleFonts.orbitron(
            color: const Color(0xff00E5FF),
            fontSize: 22,
          ),
        ),
      ],
    );
  }
}

class CyberGaugePainter extends CustomPainter {
  final double speed;
  final double maxSpeed;

  CyberGaugePainter({required this.speed, required this.maxSpeed});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final radius = size.width / 2 - 20;

    const startAngle = math.pi * .75;
    const totalSweep = math.pi * 1.5;

    final bgPaint = Paint()
      ..color = Colors.white12
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      totalSweep,
      false,
      bgPaint,
    );

    final progressPaint = Paint()
      ..color = const Color(0xff00E5FF)
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final sweep = (speed / maxSpeed) * totalSweep;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweep,
      false,
      progressPaint,
    );

    for (int i = 0; i <= 24; i++) {
      final angle = startAngle + (totalSweep / 24) * i;

      final p1 = Offset(
        center.dx + (radius - 10) * math.cos(angle),
        center.dy + (radius - 10) * math.sin(angle),
      );

      final p2 = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );

      canvas.drawLine(
        p1,
        p2,
        Paint()
          ..color = const Color(0xff00E5FF)
          ..strokeWidth = 2,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
