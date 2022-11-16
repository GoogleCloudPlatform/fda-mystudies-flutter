import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../typography/typography_tokens.dart';

class DarkTheme {
  static final ColorScheme _colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: Colors.blue.shade300,
      onPrimary: Colors.grey.shade900,
      secondary: Colors.blue.shade300.withOpacity(0.24),
      onSecondary: Colors.blue.shade100,
      error: Colors.red.shade300,
      onError: Colors.grey.shade900,
      background: Colors.grey.shade900,
      onBackground: Colors.grey.shade200,
      surface: Colors.grey.shade900,
      onSurface: Colors.grey.shade200);

  static final ThemeData _themeData = ThemeData(
      colorScheme: _colorScheme,
      scaffoldBackgroundColor: Colors.grey.shade900,
      textTheme: TypographyTokens.roles,
      appBarTheme: AppBarTheme(
          foregroundColor: Colors.white,
          backgroundColor: Colors.grey.shade900,
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
