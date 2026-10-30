import 'package:flutter/material.dart';

class ToonTheme {
  // Brand Color Tokens
  static const Color slimeGreen = Color(0xFF39FF14);
  static const Color electricCyan = Color(0xFF00F0FF);
  static const Color cheerfulOrange = Color(0xFFFF6B35);
  static const Color deepSpaceBlack = Color(0xFF12121E);
  static const Color parchmentMilk = Color(0xFFFFFDF7);
  static const Color surfaceCard = Color(0xFF1E1E30);
  static const Color surfaceCardLight = Color(0xFF282842);
  static const Color mintSolved = Color(0xFF2EC4B6);
  static const Color lockedGrey = Color(0xFF2A2A3D);
  static const Color errorRed = Color(0xFFFF4757);

  // Network Brand Accents
  static Color getNetworkColor(String network) {
    switch (network.toLowerCase()) {
      case 'cartoon network':
        return electricCyan;
      case 'nickelodeon':
        return cheerfulOrange;
      case 'disney channel & jetix':
      case 'disney & jetix':
        return const Color(0xFFFF2A6D);
      case "kids' wb & 4kids":
      case 'kids wb & 4kids':
        return const Color(0xFFFFCC00);
      case 'kidsco':
        return const Color(0xFF4D96FF);
      case 'jimjam':
        return const Color(0xFFFFD93D);
      case 'teletoon & international':
        return const Color(0xFF9D4EDD);
      default:
        return slimeGreen;
    }
  }

  // Tactile Box Decoration
  static BoxDecoration retroBox({
    Color background = surfaceCard,
    Color borderColor = deepSpaceBlack,
    double borderWidth = 2.5,
    double radius = 16,
    double shadowOffset = 4,
    Color shadowColor = Colors.black,
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

  // Neon Glow Decoration
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
          color: glowColor.withValues(alpha: 0.35),
          offset: const Offset(0, 4),
          blurRadius: 10,
        ),
      ],
    );
  }

  // Main ThemeData
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: deepSpaceBlack,
      primaryColor: slimeGreen,
      colorScheme: const ColorScheme.dark(
        primary: slimeGreen,
        secondary: electricCyan,
        tertiary: cheerfulOrange,
        surface: surfaceCard,
      ),
      fontFamily: 'Nunito',
      appBarTheme: const AppBarTheme(
        backgroundColor: deepSpaceBlack,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: parchmentMilk,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
