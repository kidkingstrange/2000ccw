import 'package:flutter/material.dart';

/// 2000s Toon Crosswords Luxury Editorial Design System
/// Apple Design Award & NYT Crossword-caliber Light Theme celebrating 2000s animation history.
class ToonTheme {
  // Brand Canvas & Surface Tokens (Refined Light Theme)
  static const Color canvasBackground = Color(0xFFF8FAFC); // Slate 50 (Crisp luxury canvas)
  static const Color surfaceCard = Color(0xFFFFFFFF);     // Pure Crisp White
  static const Color surfaceCardLight = Color(0xFFF1F5F9);// Slate 100
  static const Color blockedCell = Color(0xFFF1F5F9);     // Soft Editorial Blocked Cell
  static const Color cardBorder = Color(0xFFE2E8F0);      // Ultra-fine luxury border
  static const Color subtleBorder = Color(0xFFE2E8F0);

  // High-Contrast Refined Accents
  static const Color slimeGreen = Color(0xFF059669);       // Deep Emerald / Slime Accent
  static const Color electricCyan = Color(0xFF0284C7);     // Rich Sky Blue / Azure
  static const Color cheerfulOrange = Color(0xFFEA580C);    // Vivid Nickelodeon Orange
  static const Color amberGold = Color(0xFFD97706);        // Warm Trophy Gold
  static const Color mintSolved = Color(0xFF10B981);       // Celebratory Solved Mint
  static const Color mintSolvedBg = Color(0xFFECFDF5);     // Soft Emerald Cell Background
  static const Color mintSolvedText = Color(0xFF065F46);   // Deep Emerald Solved Text
  static const Color activeCell = Color(0xFF0284C7);       // Active Cell Focus Ring
  static const Color activeCellBg = Color(0xFFE0F2FE);     // Active Cell Fill
  static const Color activeWordHighlight = Color(0xFFF0F9FF); // Word Tracking Soft Tint
  static const Color activeWordBorder = Color(0xFFBAE6FD); // Word Tracking Border
  static const Color lockedGrey = Color(0xFFE2E8F0);
  static const Color errorRed = Color(0xFFDC2626);

  // Typography Tokens
  static const Color textMain = Color(0xFF0F172A);         // Deep Slate 900
  static const Color textSecondary = Color(0xFF334155);    // Slate 700
  static const Color textMuted = Color(0xFF64748B);        // Slate 500
  static const Color textSubtle = Color(0xFF94A3B8);       // Slate 400
  static const Color parchmentMilk = Color(0xFF0F172A);    // Backward compatible token
  static const Color deepSpaceBlack = Color(0xFFE2E8F0);   // Backward compatible token

  // Network Brand Accents (Vibrant, high-contrast, editorial)
  static Color getNetworkColor(String network) {
    switch (network.toLowerCase()) {
      case 'cartoon network':
        return const Color(0xFF0284C7);
      case 'nickelodeon':
        return const Color(0xFFEA580C);
      case 'disney channel & jetix':
      case 'disney & jetix':
        return const Color(0xFFE11D48);
      case "kids' wb & 4kids":
      case 'kids wb & 4kids':
        return const Color(0xFFD97706);
      case 'kidsco':
        return const Color(0xFF2563EB);
      case 'jimjam':
        return const Color(0xFFCA8A04);
      case 'teletoon & international':
        return const Color(0xFF7C3AED);
      default:
        return const Color(0xFF059669);
    }
  }

  // Premium Luxury Card Decoration (Diffused Ambient Drop-Shadows)
  static BoxDecoration cardDecoration({
    Color background = surfaceCard,
    Color borderColor = cardBorder,
    double borderWidth = 1.0,
    double radius = 16,
    double shadowOffset = 3.0,
    double blurRadius = 12.0,
  }) {
    return BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: borderColor, width: borderWidth),
      boxShadow: [
        BoxShadow(
          color: const Color(0x0A0F172A),
          offset: Offset(0, shadowOffset),
          blurRadius: blurRadius,
        ),
        const BoxShadow(
          color: Color(0x040F172A),
          offset: Offset(0, 1),
          blurRadius: 3,
        ),
      ],
    );
  }

  // Backward compatible retroBox updated to luxury aesthetic
  static BoxDecoration retroBox({
    Color background = surfaceCard,
    Color borderColor = cardBorder,
    double borderWidth = 1.0,
    double radius = 16,
    double shadowOffset = 3.0,
    Color shadowColor = const Color(0x0A0F172A),
  }) {
    return BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: borderColor, width: borderWidth),
      boxShadow: [
        BoxShadow(
          color: shadowColor,
          offset: Offset(0, shadowOffset),
          blurRadius: shadowOffset * 3 + 4,
        ),
        const BoxShadow(
          color: Color(0x040F172A),
          offset: Offset(0, 1),
          blurRadius: 3,
        ),
      ],
    );
  }

  // Refined Pill Decoration (Status badges, network chips)
  static BoxDecoration pillDecoration({
    required Color color,
    double radius = 24,
  }) {
    return BoxDecoration(
      color: color.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: color.withValues(alpha: 0.22), width: 1.0),
    );
  }

  // Celebratory Accent Box Decoration
  static BoxDecoration neonBox({
    Color background = surfaceCard,
    Color glowColor = electricCyan,
    double radius = 16,
  }) {
    return BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: glowColor.withValues(alpha: 0.6), width: 1.5),
      boxShadow: [
        BoxShadow(
          color: glowColor.withValues(alpha: 0.15),
          offset: const Offset(0, 4),
          blurRadius: 16,
        ),
      ],
    );
  }

  // Main Light ThemeData (Modern Luxury Typography & Navigation)
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: canvasBackground,
      primaryColor: slimeGreen,
      colorScheme: const ColorScheme.light(
        primary: slimeGreen,
        secondary: electricCyan,
        tertiary: cheerfulOrange,
        surface: surfaceCard,
        surfaceContainerHighest: surfaceCardLight,
        onSurface: textMain,
      ),
      fontFamily: 'Nunito',
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceCard,
        foregroundColor: textMain,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 1,
        iconTheme: IconThemeData(color: textMain),
        titleTextStyle: TextStyle(
          color: textMain,
          fontSize: 17,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
      ),
      dividerColor: cardBorder,
    );
  }

  // Compatibility getter
  static ThemeData get darkTheme => lightTheme;
}
