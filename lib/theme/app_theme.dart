import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Curated, vibrant color palette designed to pop on both light and dark canvases.
class AppPalette {
  static const List<Color> colors = [
    Color(0xFF0F172A), // Deep Slate
    Color(0xFFFFFFFF), // Pure White
    Color(0xFFEF4444), // Coral Red
    Color(0xFFF97316), // Bright Orange
    Color(0xFFFBBF24), // Golden Amber
    Color(0xFF10B981), // Emerald Green
    Color(0xFF06B6D4), // Sky Cyan
    Color(0xFF6366F1), // Electric Indigo
    Color(0xFF8B5CF6), // Royal Violet
    Color(0xFFEC4899), // Hot Pink
    Color(0xFF64748B), // Neutral Slate
  ];
}

class AppTheme {
  // Light mode semantic colors
  static const Color lightCanvas = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightInk = Color(0xFF0F172A);
  static const Color lightMuted = Color(0xFF94A3B8);
  static const Color lightAccent = Color(0xFF6366F1);
  static const Color lightBorder = Color(0xFFE2E8F0);

  // Dark mode semantic colors
  static const Color darkCanvas = Color(0xFF0F1117);
  static const Color darkSurface = Color(0xFF1A1D26);
  static const Color darkInk = Color(0xFFF1F5F9);
  static const Color darkMuted = Color(0xFF64748B);
  static const Color darkAccent = Color(0xFF818CF8);
  static const Color darkBorder = Color(0xFF272B38);

  // Fallback defaults for backwards compatibility
  static const Color canvasColor = lightCanvas;
  static const Color surface = lightSurface;
  static const Color ink = lightInk;
  static const Color accent = lightAccent;
  static const Color muted = lightMuted;

  // Context-aware color helpers
  static Color getCanvasColor(bool isDark) => isDark ? darkCanvas : lightCanvas;
  static Color getSurfaceColor(bool isDark) => isDark ? darkSurface : lightSurface;
  static Color getInkColor(bool isDark) => isDark ? darkInk : lightInk;
  static Color getMutedColor(bool isDark) => isDark ? darkMuted : lightMuted;
  static Color getBorderColor(bool isDark) => isDark ? darkBorder : lightBorder;
  static Color getAccentColor(bool isDark) => isDark ? darkAccent : lightAccent;

  static ThemeData get light {
    final textTheme = GoogleFonts.outfitTextTheme();
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: lightCanvas,
      colorScheme: ColorScheme.fromSeed(
        seedColor: lightAccent,
        brightness: Brightness.light,
        surface: lightSurface,
        onSurface: lightInk,
        primary: lightAccent,
      ),
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: lightCanvas,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        foregroundColor: lightInk,
        titleTextStyle: GoogleFonts.outfit(
          color: lightInk,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
      ),
      iconTheme: const IconThemeData(color: lightInk),
    );
  }

  static ThemeData get dark {
    final textTheme = GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme);
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkCanvas,
      colorScheme: ColorScheme.fromSeed(
        seedColor: darkAccent,
        brightness: Brightness.dark,
        surface: darkSurface,
        onSurface: darkInk,
        primary: darkAccent,
      ),
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: darkCanvas,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        foregroundColor: darkInk,
        titleTextStyle: GoogleFonts.outfit(
          color: darkInk,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
      ),
      iconTheme: const IconThemeData(color: darkInk),
    );
  }
}
