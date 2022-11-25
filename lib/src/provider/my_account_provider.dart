import 'package:flutter/material.dart';

class MyAccountProvider extends ChangeNotifier {
  String? _email;

  MyAccountProvider({String? email}) {
    _email = email ?? '';
  }

  void updateContent({String? email}) {
    _email = email;
    notifyListeners();
  }

  String get email => _email ?? '';
}
