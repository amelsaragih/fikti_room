// lib/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Background layers
  static const Color bg = Color(0xFF080D17);
  static const Color bgCard = Color(0xFF0F1A2E);
  static const Color bgCardHover = Color(0xFF162035);
  static const Color bgSurface = Color(0xFF111827);

  // Accent palette
  static const Color primary = Color(0xFF00D4FF);
  static const Color primaryDim = Color(0x3300D4FF);
  static const Color primaryGlow = Color(0x8000D4FF);
  static const Color secondary = Color(0xFF6C63FF);

  // Status colors
  static const Color statusGreen = Color(0xFF00E676);
  static const Color statusGreenBg = Color(0x1A00E676);
  static const Color statusYellow = Color(0xFFFFD600);
  static const Color statusYellowBg = Color(0x1AFFD600);
  static const Color statusRed = Color(0xFFFF3D71);
  static const Color statusRedBg = Color(0x1AFF3D71);
  static const Color statusGrey = Color(0xFF546E7A);
  static const Color statusGreyBg = Color(0x1A546E7A);

  // Text
  static const Color textPrimary = Color(0xFFF0F4FF);
  static const Color textSecondary = Color(0xFF8A9CC0);
  static const Color textMuted = Color(0xFF4A5C7A);

  // Border
  static const Color border = Color(0xFF1E2D45);
  static const Color borderActive = Color(0xFF00D4FF);
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.bg,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.bgSurface,
        background: AppColors.bg,
      ),
      textTheme: GoogleFonts.spaceGroteskTextTheme(
        const TextTheme(
          displayLarge: TextStyle(color: AppColors.textPrimary),
          displayMedium: TextStyle(color: AppColors.textPrimary),
          headlineLarge: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w700),
          headlineMedium: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
          titleLarge: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
          titleMedium: TextStyle(color: AppColors.textPrimary),
          bodyLarge: TextStyle(color: AppColors.textSecondary),
          bodyMedium: TextStyle(color: AppColors.textSecondary),
          labelLarge: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.spaceGrotesk(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      cardTheme: CardThemeData(
        color: AppColors.bgCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.bg,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w700, fontSize: 15),
        ),
      ),
    );
  }
}
