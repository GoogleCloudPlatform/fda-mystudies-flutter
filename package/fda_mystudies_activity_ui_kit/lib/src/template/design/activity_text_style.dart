import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ActivityTextStyle {
  static TextStyle? appBarTitle(BuildContext context) {
    return GoogleFonts.roboto(
        decoration: TextDecoration.none,
        fontSize: 16,
        height: (24.0 / 16.0),
        fontWeight: FontWeight.w500,
        fontStyle: FontStyle.normal,
        color: const Color(0xFF3C4043));
  }

  static TextStyle? activityTitle(BuildContext context) {
    return GoogleFonts.roboto(
        decoration: TextDecoration.none,
        fontSize: 28,
        height: (36.0 / 28.0),
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
        color: const Color(0xFF202124));
  }

  static TextStyle? activitySubTitle(BuildContext context) {
    return GoogleFonts.roboto(
        decoration: TextDecoration.none,
        fontSize: 16,
        height: (24.0 / 16.0),
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
        color: const Color(0xFF80868B));
  }
}
