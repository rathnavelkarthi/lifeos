import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // THEME LOCK: dark — source: domain signal (cosmic RPG, dark background #0D1117)
  // Scaffold.backgroundColor = AppTheme.background — ALL screens

  // Core palette
  static const Color background = Color(0xFF0D1117);
  static const Color surface = Color(0xFF131A2B);
  static const Color surfaceVariant = Color(0xFF1A2236);
  static const Color border = Color(0xFF2E3749);
  static const Color borderBright = Color(0xFF3D4F6B);

  // Brand colors
  static const Color primaryViolet = Color(0xFF7C5CFF);
  static const Color primaryVioletLight = Color(0xFF9B82FF);
  static const Color accentMint = Color(0xFF22E6B1);
  static const Color accentMintDark = Color(0xFF0CE676);
  static const Color gold = Color(0xFFFFA640);
  static const Color goldDark = Color(0xFFFF6040);
  static const Color oceanBlue = Color(0xFF4460FF);
  static const Color oceanLight = Color(0xFF40B6FF);

  // Semantic
  static const Color error = Color(0xFFFF5461);
  static const Color success = Color(0xFF22E6B1);
  static const Color warning = Color(0xFFFFA640);
  static const Color muted = Color(0xFF9AAAB2);
  static const Color mutedDark = Color(0xFF5A6A7A);

  // Stat colors
  static const Color statBuilder = Color(0xFF7C5CFF);
  static const Color statHealth = Color(0xFF22E6B1);
  static const Color statWealth = Color(0xFFFFA640);
  static const Color statKnowledge = Color(0xFF4460FF);
  static const Color statCreativity = Color(0xFFFF6040);
  static const Color statSocial = Color(0xFF0CE676);

  // Gradients
  static const LinearGradient auroraGradient = LinearGradient(
    colors: [primaryViolet, accentMint],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient sunsetGradient = LinearGradient(
    colors: [Color(0xFFFF6040), Color(0xFFFFA640)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient oceanGradient = LinearGradient(
    colors: [oceanBlue, oceanLight],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient forestGradient = LinearGradient(
    colors: [accentMint, accentMintDark],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: background,
    colorScheme: const ColorScheme.dark(
      primary: primaryViolet,
      onPrimary: Colors.white,
      primaryContainer: Color(0xFF2A1F5C),
      onPrimaryContainer: Color(0xFFD4C8FF),
      secondary: accentMint,
      onSecondary: Color(0xFF0D1117),
      secondaryContainer: Color(0xFF0F3028),
      onSecondaryContainer: accentMint,
      surface: surface,
      onSurface: Colors.white,
      surfaceContainerHighest: surfaceVariant,
      onSurfaceVariant: muted,
      error: error,
      onError: Colors.white,
      outline: border,
      outlineVariant: Color(0xFF1E2A3A),
      inverseSurface: Colors.white,
      onInverseSurface: background,
    ),
    textTheme: GoogleFonts.plusJakartaSansTextTheme(
      const TextTheme(
        displayLarge: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.w700,
          height: 1.2,
          color: Colors.white,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          height: 1.2,
          color: Colors.white,
        ),
        displaySmall: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          height: 1.3,
          color: Colors.white,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 1.5,
          color: Colors.white,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 1.5,
          color: Colors.white,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          height: 1.5,
          color: Color(0xFF9AAAB2),
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
          color: Colors.white,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
          color: Colors.white,
        ),
        labelSmall: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
          color: Color(0xFF9AAAB2),
        ),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      foregroundColor: Colors.white,
    ),
    cardTheme: CardThemeData(
      color: surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: border, width: 1),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF0D1117),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryViolet, width: 1.5),
      ),
      labelStyle: const TextStyle(color: muted),
      hintStyle: const TextStyle(color: mutedDark),
    ),
    dividerTheme: const DividerThemeData(color: border, thickness: 1),
  );

  // lightTheme required by contract — mirrors dark for this domain
  static ThemeData get lightTheme => darkTheme;
}
