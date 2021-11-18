import 'package:flutter/material.dart';

class TestUtils {
  static Widget createWidgetForTesting(Widget child) {
    return MaterialApp(home: child);
  }
}
