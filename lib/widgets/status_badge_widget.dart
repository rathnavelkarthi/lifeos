import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum BadgeType { xp, gold, time, stat, level, streak, warning, success, error }

class StatusBadgeWidget extends StatelessWidget {
  final String label;
  final BadgeType type;
  final double fontSize;

  const StatusBadgeWidget({
    required this.label,
    required this.type,
    this.fontSize = 11,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getConfig();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: config.gradient,
        color: config.gradient == null ? config.color : null,
        border: config.gradient == null
            ? Border.all(color: config.borderColor, width: 1)
            : null,
      ),
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          color: config.textColor,
          letterSpacing: 0.2,
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
      ),
    );
  }

  _BadgeConfig _getConfig() {
    switch (type) {
      case BadgeType.xp:
        return _BadgeConfig(
          gradient: const LinearGradient(
            colors: [Color(0xFF22E6B1), Color(0xFF0CE676)],
          ),
          textColor: const Color(0xFF0D1117),
          borderColor: Colors.transparent,
        );
      case BadgeType.gold:
        return _BadgeConfig(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF6040), Color(0xFFFFA640)],
          ),
          textColor: Colors.white,
          borderColor: Colors.transparent,
        );
      case BadgeType.time:
        return _BadgeConfig(
          gradient: const LinearGradient(
            colors: [Color(0xFF4460FF), Color(0xFF40B6FF)],
          ),
          textColor: Colors.white,
          borderColor: Colors.transparent,
        );
      case BadgeType.stat:
        return _BadgeConfig(
          color: const Color(0xFF1A2236),
          textColor: const Color(0xFF9AAAB2),
          borderColor: const Color(0xFF2E3749),
        );
      case BadgeType.level:
        return _BadgeConfig(
          color: const Color(0xFF2A1F5C),
          textColor: const Color(0xFF9B82FF),
          borderColor: const Color(0xFF7C5CFF),
        );
      case BadgeType.streak:
        return _BadgeConfig(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF6040), Color(0xFFFFA640)],
          ),
          textColor: Colors.white,
          borderColor: Colors.transparent,
        );
      case BadgeType.warning:
        return _BadgeConfig(
          color: const Color(0xFF2A1A0D),
          textColor: const Color(0xFFFFA640),
          borderColor: const Color(0xFFFFA640),
        );
      case BadgeType.success:
        return _BadgeConfig(
          color: const Color(0xFF0F3028),
          textColor: const Color(0xFF22E6B1),
          borderColor: const Color(0xFF22E6B1),
        );
      case BadgeType.error:
        return _BadgeConfig(
          color: const Color(0xFF2A0D10),
          textColor: const Color(0xFFFF5461),
          borderColor: const Color(0xFFFF5461),
        );
    }
  }
}

class _BadgeConfig {
  final LinearGradient? gradient;
  final Color? color;
  final Color textColor;
  final Color borderColor;

  const _BadgeConfig({
    this.gradient,
    this.color,
    required this.textColor,
    required this.borderColor,
  });
}
