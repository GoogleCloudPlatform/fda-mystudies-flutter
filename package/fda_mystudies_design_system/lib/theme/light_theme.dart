import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../typography/typography_tokens.dart';

class LightTheme {
  static final ColorScheme _colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: const Color(0xFF1A73E8),
      onPrimary: Colors.white,
      secondary: Colors.blue.shade50,
      onSecondary: Colors.blue.shade700,
      error: Colors.red.shade600,
      onError: Colors.white,
      background: Colors.white,
      onBackground: Colors.grey.shade900,
      surface: Colors.white,
      onSurface: Colors.grey.shade900,
      onSurfaceVariant: Colors.grey.shade600);

  static final ThemeData _themeData = ThemeData(
      colorScheme: _colorScheme,
      scaffoldBackgroundColor: Colors.white,
      textTheme: TypographyTokens.roles,
      appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.grey.shade900,
          titleTextStyle: GoogleFonts.roboto(
              decoration: TextDecoration.none,
              fontSize: 22.0,
              height: (28.0 / 22.0),
              fontWeight: FontWeight.w400,
              color: _colorScheme.onBackground,
              fontStyle: FontStyle.normal),
          elevation: 0),
      fontFamily: GoogleFonts.roboto().fontFamily);

  static ThemeData getThemeData() => _themeData;
}
