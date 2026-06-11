import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class F1RacingThemeScreen extends StatelessWidget {
  final double currentSpeed;
  final bool isHudMode;
  final int gpsSignalStrength;
  final VoidCallback onToggleHud;
  final VoidCallback onOpenThemeSelector;

  const F1RacingThemeScreen({
    super.key,
    required this.currentSpeed,
    required this.isHudMode,
    required this.gpsSignalStrength,
    required this.onToggleHud,
    required this.onOpenThemeSelector,
  });

  static const Color bgColor = Color(0xFF090909);
  static const Color redColor = Color(0xFFFF2D55);
  static const Color yellowColor = Color(0xFFFFD60A);
  static const Color greenColor = Color(0xFF32D74B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,

        actions: [
          IconButton(
            icon: Icon(
              isHudMode ? Icons.wb_sunny : Icons.flip,
              color: redColor,
            ),
            onPressed: onToggleHud,
          ),

          IconButton(
            icon: const Icon(Icons.palette, color: Colors.white),
            onPressed: onOpenThemeSelector,
          ),
        ],
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              // 1. TOP (compact header)
              _buildTopHeader(),

              const SizedBox(height: 10),

              // 2. RPM (compressed)
              SizedBox(height: 60, child: F1RpmBar(speed: currentSpeed)),

              const SizedBox(height: 10),

              // 3. SPEED (flex center)
              Expanded(child: _buildSpeedCenter()),

              // 4. BOTTOM (single row only)
              _buildBottomRow(),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _miniChip("GPS", "$gpsSignalStrength/5", Colors.greenAccent),

        Text(
          "F1 TELEMETRY",
          style: GoogleFonts.exo2(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 14,
            letterSpacing: 2,
          ),
        ),

        _miniChip("SAT", "14", Colors.yellow),
      ],
    );
  }

  Widget _miniChip(String t, String v, Color c) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.withOpacity(.6)),
      ),
      child: Text("$t $v", style: TextStyle(color: c, fontSize: 11)),
    );
  }

  Widget _buildSpeedCenter() {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            currentSpeed.toStringAsFixed(0),
            style: GoogleFonts.exo2(
              fontSize: 110,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          Text(
            "KM/H",
            style: GoogleFonts.exo2(
              color: Colors.white70,
              fontSize: 16,
              letterSpacing: 5,
            ),
          ),
          const SizedBox(height: 10),
          _gearWidget("6"),
        ],
      ),
    );
  }

  Widget _buildBottomRow() {
    return Row(
      children: [
        Expanded(child: _telemetryCard("LAP", "02:14", Colors.white)),
        const SizedBox(width: 8),
        Expanded(child: _telemetryCard("FUEL", "58%", Colors.yellow)),
        const SizedBox(width: 8),
        Expanded(child: _telemetryCard("TYRE", "89°C", Colors.red)),
      ],
    );
  }

  Widget _statusChip(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: color),
      ),

      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),

          const SizedBox(width: 6),

          Text(value, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _gearWidget(String gear) {
    return Container(
      width: 95,
      height: 95,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: redColor, width: 2),
      ),

      child: Center(
        child: Text(
          gear,
          style: GoogleFonts.exo2(
            color: Colors.white,
            fontSize: 50,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }

  Widget _drsWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),

      decoration: BoxDecoration(
        color: greenColor.withOpacity(.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: greenColor),
      ),

      child: Text(
        "DRS ACTIVE",
        style: GoogleFonts.exo2(color: greenColor, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _telemetryCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(.4)),
      ),

      child: Column(
        children: [
          Text(
            title,
            style: GoogleFonts.exo2(
              color: Colors.white54,
              fontSize: 12,
              letterSpacing: 1.5,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            value,
            style: GoogleFonts.exo2(
              color: color,
              fontWeight: FontWeight.w800,
              fontSize: 24,
            ),
          ),
        ],
      ),
    );
  }
}

class F1RpmBar extends StatelessWidget {
  final double speed;

  const F1RpmBar({super.key, required this.speed});

  @override
  Widget build(BuildContext context) {
    int activeBars = ((speed / 240) * 20).clamp(0, 20).toInt();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            10,
            (index) => Text(
              index.toString(),
              style: const TextStyle(color: Colors.white54, fontSize: 10),
            ),
          ),
        ),

        const SizedBox(height: 6),

        Row(
          children: List.generate(20, (index) {
            Color color;

            if (index < 10) {
              color = Colors.orange;
            } else if (index < 16) {
              color = Colors.redAccent;
            } else {
              color = Colors.red;
            }

            return Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 1),

                height: 20,

                decoration: BoxDecoration(
                  color: index < activeBars ? color : Colors.white12,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            );
          }),
        ),

        const SizedBox(height: 8),

        Text(
          "RPM x1000",
          style: GoogleFonts.exo2(
            color: Colors.white54,
            fontSize: 12,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }
}
