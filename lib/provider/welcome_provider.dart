import 'package:flutter/material.dart';

class WelcomeProvider extends ChangeNotifier {
  String? _title;
  String? _info;
  String? _errorMessage;

  WelcomeProvider({String? title, String? info}) {
    _title = title ?? '';
    _info = info ?? '';
  }

  void updateContent({String? title, String? info, String? errorMessage}) {
    _title = title;
    _info = info;
    _errorMessage = errorMessage;
    notifyListeners();
  }

  String get title => _title ?? '';
  String get info => _info ?? '';
  String? get errorMessage => _errorMessage;
}
