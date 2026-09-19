// ============================================================
// theme/nivakin_theme.dart
// Blossom & Lilac Material 3 design system for Nivakin.
// Grade 5–6 reading-level typography (Nunito), 48dp touch targets.
// ============================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NivakinColors {
  NivakinColors._();

  // ── Base Palette ─────────────────────────────────────────────
  static const Color canvas         = Color(0xFFFFF7F9); // Soft Blossom White
  static const Color surface        = Color(0xFFFFFFFF); // Pure Cloud White
  static const Color primaryAccent  = Color(0xFFF472B6); // Warm Rose Pink
  static const Color secondaryAccent= Color(0xFFC084FC); // Soft Lilac Lavender
  static const Color textPrimary    = Color(0xFF374151); // Charcoal Slate
  static const Color textMuted      = Color(0xFF9CA3AF); // Soft Heather
  static const Color success        = Color(0xFF34D399); // Pastel Mint
  static const Color alert          = Color(0xFFFB7185); // Coral Rose
  static const Color alertSoft      = Color(0xFFFFF1F3); // Alert background tint

  // ── Convenient Aliases ────────────────────────────────────────
  static const Color blossomWhite   = canvas;
  static const Color cardWhite      = surface;
  static const Color rosePink       = primaryAccent;
  static const Color softLilac      = secondaryAccent;
  static const Color charcoalSlate  = textPrimary;
  static const Color textSubtle     = textMuted;
  static const Color tealBadge      = success;
  static const Color purpleAccent   = secondaryAccent;
  static const Color borderSoft     = Color(0xFFEDE9FE);

  // ── Gradient ─────────────────────────────────────────────────
  static const LinearGradient blossomGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFF7F9), Color(0xFFF9F0FF)],
  );

  static const LinearGradient pinkLilacGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF472B6), Color(0xFFC084FC)],
  );

  static const LinearGradient mintGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF34D399), Color(0xFF6EE7B7)],
  );

  // Bucket & View background tints
  static const Color bucketABg     = Color(0xFFFAF5FF); // Soft Lilac tinted
  static const Color bucketBBg     = Color(0xFFFFF0F5); // Warm Blossom Pink tinted
  static const Color bucketCBg     = Color(0xFFFFFBEB); // Soft Amber tinted
  static const Color softAmber     = Color(0xFFF59E0B); // Soft Amber Accent
  static const Color softLilacBg   = bucketABg;
  static const Color blossomPinkBg = bucketBBg;
}

class NivakinTheme {
  NivakinTheme._();

  static ThemeData get lightTheme {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: NivakinColors.canvas,
      colorScheme: ColorScheme.fromSeed(
        seedColor: NivakinColors.primaryAccent,
        brightness: Brightness.light,
        surface: NivakinColors.surface,
        primary: NivakinColors.primaryAccent,
        secondary: NivakinColors.secondaryAccent,
        error: NivakinColors.alert,
      ),
    );

    return base.copyWith(
      textTheme: GoogleFonts.nunitoTextTheme(base.textTheme).copyWith(
        displayLarge: GoogleFonts.nunito(
          fontSize: 28,
          fontWeight: FontWeight.w800,
          color: NivakinColors.textPrimary,
          letterSpacing: -0.5,
        ),
        displayMedium: GoogleFonts.nunito(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: NivakinColors.textPrimary,
        ),
        headlineMedium: GoogleFonts.nunito(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: NivakinColors.textPrimary,
        ),
        titleLarge: GoogleFonts.nunito(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: NivakinColors.textPrimary,
        ),
        bodyLarge: GoogleFonts.nunito(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: NivakinColors.textPrimary,
          height: 1.6,
        ),
        bodyMedium: GoogleFonts.nunito(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: NivakinColors.textPrimary,
          height: 1.6,
        ),
        labelLarge: GoogleFonts.nunito(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
      cardTheme: CardThemeData(
        color: NivakinColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(NivakinRadius.card),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: NivakinColors.primaryAccent,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 52),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(NivakinRadius.pill),
          ),
          elevation: 0,
          textStyle: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: NivakinColors.primaryAccent,
          side: const BorderSide(color: NivakinColors.primaryAccent, width: 1.5),
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(NivakinRadius.pill),
          ),
          textStyle: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: NivakinColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(NivakinRadius.pill),
          borderSide: const BorderSide(color: NivakinColors.borderSoft, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(NivakinRadius.pill),
          borderSide: const BorderSide(color: NivakinColors.borderSoft, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(NivakinRadius.pill),
          borderSide: const BorderSide(color: NivakinColors.primaryAccent, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        hintStyle: GoogleFonts.nunito(
          color: NivakinColors.textMuted,
          fontSize: 15,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: NivakinColors.canvas,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.nunito(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: NivakinColors.textPrimary,
        ),
        iconTheme: const IconThemeData(color: NivakinColors.textPrimary),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: NivakinColors.surface,
        selectedItemColor: NivakinColors.primaryAccent,
        unselectedItemColor: NivakinColors.textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
  }
}

// ── Design Constants ──────────────────────────────────────────
class NivakinSpacing {
  NivakinSpacing._();
  static const double xs   = 4.0;
  static const double sm   = 8.0;
  static const double md   = 16.0;
  static const double lg   = 24.0;
  static const double xl   = 32.0;
  static const double xxl  = 48.0;
}

class NivakinRadius {
  NivakinRadius._();
  static const double sm   = 12.0;
  static const double md   = 16.0;
  static const double lg   = 24.0;
  static const double pill = 24.0;
  static const double card = 24.0;
}
