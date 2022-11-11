import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// https://m3.material.io/styles/typography/type-scale-tokens#d74b73c2-ac5d-43c5-93b3-088a2f67723d
class TypographyTokens {
  static final roles = TextTheme(
      displayLarge: GoogleFonts.roboto(
          decoration: TextDecoration.none,
          fontWeight: FontWeight.w400,
          fontSize: 57.0,
          height: (64.0 / 57.0),
          fontStyle: FontStyle.normal),
      displayMedium: GoogleFonts.roboto(
          decoration: TextDecoration.none,
          fontWeight: FontWeight.w400,
          fontSize: 45.0,
          height: (52.0 / 45.0),
          fontStyle: FontStyle.normal),
      displaySmall: GoogleFonts.roboto(
          decoration: TextDecoration.none,
          fontWeight: FontWeight.w400,
          fontSize: 36.0,
          height: (44.0 / 36.0),
          fontStyle: FontStyle.normal),
      headlineLarge: GoogleFonts.roboto(
          decoration: TextDecoration.none,
          fontWeight: FontWeight.w400,
          fontSize: 32.0,
          height: (40.0 / 32.0),
          fontStyle: FontStyle.normal),
      headlineMedium: GoogleFonts.roboto(
          decoration: TextDecoration.none,
          fontSize: 28.0,
          height: (36.0 / 28.0),
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal),
      headlineSmall: GoogleFonts.roboto(
          decoration: TextDecoration.none,
          fontSize: 24.0,
          height: (32.0 / 24.0),
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal),
      titleLarge: GoogleFonts.roboto(
          decoration: TextDecoration.none,
          fontSize: 22.0,
          height: (28.0 / 22.0),
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal),
      titleMedium: GoogleFonts.roboto(
          decoration: TextDecoration.none,
          fontSize: 16.0,
          height: (24.0 / 16.0),
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.normal),
      titleSmall: GoogleFonts.roboto(
          decoration: TextDecoration.none,
          fontSize: 14.0,
          height: (20.0 / 14.0),
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.normal),
      labelLarge: GoogleFonts.roboto(
          decoration: TextDecoration.none,
          fontSize: 14.0,
          height: (20.0 / 14.0),
          letterSpacing: 0.2,
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.normal),
      labelMedium: GoogleFonts.roboto(
          decoration: TextDecoration.none,
          fontSize: 12.0,
          height: (16.0 / 12.0),
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.normal),
      labelSmall: GoogleFonts.roboto(
          decoration: TextDecoration.none,
          fontSize: 11.0,
          height: (16.0 / 11.0),
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.normal),
      bodyLarge: GoogleFonts.roboto(
          decoration: TextDecoration.none,
          fontSize: 16.0,
          height: (24.0 / 16.0),
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal),
      bodyMedium: GoogleFonts.roboto(
          decoration: TextDecoration.none,
          fontSize: 14.0,
          height: (20.0 / 14.0),
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal),
      bodySmall: GoogleFonts.roboto(
          decoration: TextDecoration.none,
          fontSize: 12.0,
          height: (16.0 / 12.0),
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal));
}
