import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FDATextStyle {
  static TextStyle? heading(BuildContext context) {
    return GoogleFonts.roboto(
        decoration: TextDecoration.none,
        fontSize: 22,
        height: (35.0 / 22.0),
        fontWeight: FontWeight.w700,
        fontStyle: FontStyle.normal,
        color: const Color(0xFF000000));
  }

  static TextStyle? subHeadingRegular(BuildContext context) {
    return GoogleFonts.roboto(
        decoration: TextDecoration.none,
        fontSize: 16,
        height: (24.0 / 16.0),
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
        color: const Color(0xFF80868B));
  }

  static TextStyle? subHeadingBold(BuildContext context) {
    return GoogleFonts.roboto(
        decoration: TextDecoration.none,
        fontSize: 14,
        height: (22.0 / 14.0),
        fontWeight: FontWeight.w700,
        fontStyle: FontStyle.normal,
        color: const Color(0xFF5F6368));
  }

  static TextStyle? button(BuildContext context) {
    return GoogleFonts.roboto(
        decoration: TextDecoration.none,
        fontSize: 14,
        height: (20.0 / 14.0),
        fontWeight: FontWeight.w500,
        fontStyle: FontStyle.normal,
        color: const Color(0xFFFFFFFF));
  }

  static TextStyle? textButton(BuildContext context) {
    return GoogleFonts.roboto(
        decoration: TextDecoration.none,
        fontSize: 13,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
        color: const Color(0xFF0B57D0));
  }

  static TextStyle? text(BuildContext context) {
    return GoogleFonts.roboto(
        decoration: TextDecoration.none,
        fontSize: 13,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
        color: const Color(0xFF000000));
  }

  static TextStyle? appBarTitle(BuildContext context) {
    return GoogleFonts.roboto(
        decoration: TextDecoration.none,
        fontSize: 22,
        height: (28.0 / 22.0),
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
        color: const Color(0xFF202124));
  }

  static TextStyle? inputText(BuildContext context) {
    return GoogleFonts.roboto(
        decoration: TextDecoration.none,
        fontSize: 16,
        height: (24.0 / 16.0),
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
        color: const Color(0xFF3C4043));
  }

  static TextStyle? information(BuildContext context) {
    return GoogleFonts.roboto(
        decoration: TextDecoration.none,
        fontSize: 14,
        height: (20.0 / 14.0),
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
        color: const Color(0xFF80868B));
  }

  static TextStyle? inlineText(BuildContext context) {
    return GoogleFonts.roboto(
        decoration: TextDecoration.none,
        fontSize: 14,
        height: (20.0 / 14.0),
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
        color: const Color(0xFF3C4043));
  }

  static TextStyle? inkwell(BuildContext context) {
    return GoogleFonts.roboto(
        decoration: TextDecoration.none,
        fontSize: 14,
        height: (20.0 / 14.0),
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
        color: const Color(0xFF1A73E8));
  }

  static TextStyle? activityTileTitle(BuildContext context) {
    return GoogleFonts.roboto(
        decoration: TextDecoration.none,
        fontSize: 16,
        height: (20.0 / 16.0),
        fontWeight: FontWeight.w500,
        fontStyle: FontStyle.normal,
        color: const Color(0xFF202124));
  }

  static TextStyle? activityTileFrequency(BuildContext context) {
    return GoogleFonts.roboto(
        decoration: TextDecoration.none,
        fontSize: 12,
        height: (16.0 / 12.0),
        fontWeight: FontWeight.w500,
        fontStyle: FontStyle.normal,
        color: const Color(0xFF70757A));
  }

  static TextStyle? activityStatus(BuildContext context, Color color) {
    return GoogleFonts.roboto(
        decoration: TextDecoration.none,
        fontSize: 14,
        height: (16.0 / 14.0),
        fontWeight: FontWeight.w500,
        fontStyle: FontStyle.normal,
        color: color);
  }

  static TextStyle? drawerNavigationItem(BuildContext context) {
    return GoogleFonts.roboto(
        decoration: TextDecoration.none,
        fontSize: 14,
        height: (20.0 / 14.0),
        fontWeight: FontWeight.w500,
        fontStyle: FontStyle.normal,
        color: const Color(0xFF606060));
  }

  static TextStyle? drawerNavigationItemSubtitle(BuildContext context) {
    return GoogleFonts.roboto(
        decoration: TextDecoration.none,
        fontSize: 12,
        height: (16.0 / 12.0),
        fontWeight: FontWeight.w500,
        fontStyle: FontStyle.normal,
        color: const Color(0xFF70757A));
  }
}
