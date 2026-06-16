import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AircraftHudThemeScreen extends StatelessWidget {
  final double currentSpeed;
  final bool isHudMode;
  final int gpsSignalStrength;
  final VoidCallback onToggleHud;
  final VoidCallback onOpenThemeSelector;

  const AircraftHudThemeScreen({
    super.key,
    required this.currentSpeed,
    required this.isHudMode,
    required this.gpsSignalStrength,
    required this.onToggleHud,
    required this.onOpenThemeSelector,
  });

  // --- PRE-CACHED CONSTANTS & STYLES ---
  static const Color hudGreen = Color(0xFF00FF66);

  // Pre-caching these prevents massive lag during rapid rebuilds
  static final TextStyle hudText = GoogleFonts.rajdhani(color: hudGreen);
  static final TextStyle hudBold = GoogleFonts.rajdhani(
    color: hudGreen,
    fontWeight: FontWeight.bold,
  );
  static final TextStyle hudSatText = GoogleFonts.rajdhani(
    color: hudGreen,
    fontSize: 22,
    fontWeight: FontWeight.bold,
  );
  static final TextStyle hudSpeedText = GoogleFonts.rajdhani(
    color: hudGreen,
    fontSize: 90,
    fontWeight: FontWeight.bold,
  );
  static final TextStyle hudUnitText = GoogleFonts.rajdhani(
    color: hudGreen,
    letterSpacing: 6,
  );
  static final TextStyle hudTelemetryValText = GoogleFonts.rajdhani(
    color: hudGreen,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              isHudMode ? Icons.wb_sunny : Icons.flip,
              color: hudGreen,
            ),
            onPressed: onToggleHud,
          ),
          IconButton(
            icon: const Icon(Icons.palette, color: hudGreen),
            onPressed: onOpenThemeSelector,
          ),
        ],
      ),
      body: Stack(
        children: [
          // Using a const CustomPaint completely stops this layer from rebuilding
          const Positioned.fill(
            child: RepaintBoundary(
              child: CustomPaint(painter: HudGridPainter()),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _hudBox("GPS", "$gpsSignalStrength/5"),
                      Text("SAT 14", style: hudSatText),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Expanded(
                    child: Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 280,
                            height: 280,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: hudGreen, width: 2),
                            ),
                          ),
                          Container(
                            width: 180,
                            height: 180,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color.fromARGB(100, 0, 255, 102),
                              ),
                            ),
                          ),
                          const Icon(Icons.add, size: 100, color: hudGreen),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                currentSpeed.toStringAsFixed(0),
                                style: hudSpeedText,
                              ),
                              Text("KM/H", style: hudUnitText),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(child: _telemetry("HDG", "185°")),
                      const SizedBox(width: 10),
                      Expanded(child: _telemetry("ALT", "1250m")),
                      const SizedBox(width: 10),
                      Expanded(child: _telemetry("DIST", "12.4km")),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Container(
                    height: 70,
                    decoration: BoxDecoration(
                      border: Border.all(color: hudGreen),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _bottomItem(Icons.navigation),
                        _bottomItem(Icons.radar),
                        _bottomItem(Icons.flight),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _hudBox(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: hudGreen),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text("$title  $value", style: hudBold),
    );
  }

  Widget _telemetry(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(color: hudGreen),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(title, style: hudText),
          const SizedBox(height: 6),
          Text(value, style: hudTelemetryValText),
        ],
      ),
    );
  }

  Widget _bottomItem(IconData icon) {
    return Icon(icon, color: hudGreen, size: 28);
  }
}

class HudGridPainter extends CustomPainter {
  // Adding a const constructor allows Flutter to cache the widget
  const HudGridPainter();

  // Create the Paint object once statically
  static final Paint _paint = Paint()
    ..color = const Color(0xFF00FF66).withOpacity(.08)
    ..strokeWidth = 1;

  @override
  void paint(Canvas canvas, Size size) {
    for (double x = 0; x < size.width; x += 30) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), _paint);
    }
    for (double y = 0; y < size.height; y += 30) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), _paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
