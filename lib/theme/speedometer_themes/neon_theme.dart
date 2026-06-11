import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NeonThemeScreen extends StatelessWidget {
  final double currentSpeed;
  final bool isHudMode;
  final int gpsSignalStrength;
  final VoidCallback onToggleHud;
  final VoidCallback onOpenThemeSelector;

  const NeonThemeScreen({
    super.key,
    required this.currentSpeed,
    required this.isHudMode,
    required this.gpsSignalStrength,
    required this.onToggleHud,
    required this.onOpenThemeSelector,
  });

  static const Color neonBlue = Color(0xFF00E5FF);
  static const Color neonPurple = Color(0xFF7B61FF);
  static const Color bgDark = Color(0xFF050816);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgDark,
      body: SafeArea(
        child: Stack(
          children: [
            const Positioned.fill(
              child: CustomPaint(painter: CyberGridPainter()),
            ),

            Positioned(
              top: -100,
              right: -100,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: neonBlue.withOpacity(.08),
                ),
              ),
            ),

            Positioned(
              bottom: -100,
              left: -100,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: neonPurple.withOpacity(.08),
                ),
              ),
            ),

            Column(
              children: [
                _buildTopBar(),
                Expanded(child: Center(child: _buildSpeedDial())),
                _buildBottomPanel(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.05),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white10),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.gps_fixed,
                  size: 16,
                  color: gpsSignalStrength > 2
                      ? Colors.greenAccent
                      : Colors.redAccent,
                ),
                const SizedBox(width: 6),
                Text(
                  "GPS $gpsSignalStrength/5",
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  isHudMode ? Icons.wb_sunny : Icons.flip,
                  color: neonBlue,
                ),
                onPressed: onToggleHud,
              ),
              IconButton(
                icon: const Icon(Icons.palette, color: Colors.white70),
                onPressed: onOpenThemeSelector,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSpeedDial() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 340,
          height: 340,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: neonBlue.withOpacity(.15),
                blurRadius: 80,
                spreadRadius: 10,
              ),
            ],
          ),
        ),

        SizedBox(
          width: 320,
          height: 320,
          child: CircularProgressIndicator(
            value: (currentSpeed / 240).clamp(0.0, 1.0),
            strokeWidth: 10,
            backgroundColor: Colors.white10,
            valueColor: const AlwaysStoppedAnimation(neonBlue),
          ),
        ),

        Container(
          width: 250,
          height: 250,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF0D1322),
            border: Border.all(color: neonBlue.withOpacity(.2), width: 2),
          ),
        ),

        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: neonPurple.withOpacity(.15)),
          ),
        ),

        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              currentSpeed.toStringAsFixed(0),
              style: GoogleFonts.orbitron(
                fontSize: 96,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                height: 1,
              ),
            ),

            const SizedBox(height: 8),

            Text(
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
                color: neonBlue.withOpacity(.1),
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
            color: Colors.white.withOpacity(.04),
            border: Border(
              top: BorderSide(color: Colors.white.withOpacity(.08)),
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
        color: Colors.white.withOpacity(.05),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: neonBlue.withOpacity(.15)),
      ),
      child: Column(
        children: [
          Icon(icon, color: neonBlue, size: 22),

          const SizedBox(height: 8),

          Text(
            title,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 11,
              letterSpacing: 2,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
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
  const CyberGridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.cyanAccent.withOpacity(.04)
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
    return false;
  }
}
