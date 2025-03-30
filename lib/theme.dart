import 'package:flutter/material.dart';

class AppTheme {
  // Define Colors
  static const Color primaryColor = Color(0xFF3674B5); // #3674B5
  static const Color secondaryColor = Color(0xFF578FCA); // #578FCA
  static const Color backgroundColor = Color(0xFFA1E3F9); // #A1E3F9
  static const Color foregroundColor = Color(0xFFD1F8EF); // #D1F8EF

  static const Color textColor = Color(0xFF1A1A1A); // Dark text
  static const Color paragraphTextColor =
      Color(0xFF444444); // Slightly lighter text

  // Define Theme
  static final ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: foregroundColor,
      titleTextStyle: TextStyle(
          color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(
          color: textColor, fontSize: 18, fontWeight: FontWeight.bold),
      bodyMedium: TextStyle(color: paragraphTextColor, fontSize: 16),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
  );
}
