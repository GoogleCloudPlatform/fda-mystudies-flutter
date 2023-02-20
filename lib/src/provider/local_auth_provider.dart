import 'package:flutter/material.dart';

class LocalAuthProvider extends ChangeNotifier {
  bool _showLock = true;

  void updateStatus({required bool showLock}) {
    if (showLock != _showLock) {
      _showLock = showLock;
      notifyListeners();
    }
  }

  bool get showLock => _showLock;
}
