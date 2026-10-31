import 'package:flutter/material.dart';

/// 2000s Toon Crosswords Design System
/// Energetic, retro, tactile Light Theme celebrating 2000s animation history.
class ToonTheme {
  // Brand Canvas & Surface Tokens (Light Theme)
  static const Color canvasBackground = Color(0xFFF4F7FB);
  static const Color surfaceCard = Color(0xFFFFFFFF);
  static const Color surfaceCardLight = Color(0xFFF1F5F9);
  static const Color blockedCell = Color(0xFFE2E8F0);
  static const Color cardBorder = Color(0xFF1E293B);

  // High-Contrast Brand Accents
  static const Color slimeGreen = Color(0xFF059669);       // Emerald / Slime Green
  static const Color electricCyan = Color(0xFF0284C7);     // Vivid Cyan / Blue
  static const Color cheerfulOrange = Color(0xFFEA580C);    // Vivid Nickelodeon Orange
  static const Color mintSolved = Color(0xFF10B981);       // Celebratory Solved Mint
  static const Color activeCell = Color(0xFF38BDF8);       // Electric Sky Blue Cursor
  static const Color activeWordHighlight = Color(0xFFE0F2FE); // Soft Cyan Word Highlight
  static const Color lockedGrey = Color(0xFFE2E8F0);
  static const Color errorRed = Color(0xFFDC2626);

  // Typography Tokens
  static const Color textMain = Color(0xFF0F172A);         // Deep Slate Dark
  static const Color textMuted = Color(0xFF64748B);        // Cool Slate Grey
  static const Color parchmentMilk = Color(0xFF0F172A);    // Backward compatible token
  static const Color deepSpaceBlack = Color(0xFFF4F7FB);   // Backward compatible token mapped to canvas

  // Network Brand Accents (Vibrant & High-Contrast on Light Backgrounds)
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

  // Tactile Retro Cartoon Pop Box Decoration
  static BoxDecoration retroBox({
    Color background = surfaceCard,
    Color borderColor = cardBorder,
    double borderWidth = 2.0,
    double radius = 16,
    double shadowOffset = 3.5,
    Color shadowColor = const Color(0x300F172A),
  }) {
    return BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: borderColor, width: borderWidth),
      boxShadow: [
        BoxShadow(
          color: shadowColor,
          offset: Offset(0, shadowOffset),
          blurRadius: 0,
        ),
      ],
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
      border: Border.all(color: glowColor, width: 2.5),
      boxShadow: [
        BoxShadow(
          color: glowColor.withValues(alpha: 0.20),
          offset: const Offset(0, 4),
          blurRadius: 10,
        ),
      ],
    );
  }

  // Main Light ThemeData
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
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  // Compatibility getter
  static ThemeData get darkTheme => lightTheme;
}
