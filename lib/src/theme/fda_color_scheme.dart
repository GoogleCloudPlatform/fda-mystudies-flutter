import 'package:flutter/material.dart';

class FDAColorScheme {
  static Color? primaryIconColor(BuildContext context) {
    return Theme.of(context).colorScheme.onSurface;
  }

  static Color? bottomAppBarColor(BuildContext context) {
    return Theme.of(context).bottomAppBarTheme.color;
  }

  static Color? googleBlue(BuildContext context) {
    return const Color(0xFF4285F4);
  }
}
