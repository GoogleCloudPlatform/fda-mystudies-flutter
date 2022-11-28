import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityProvider extends ChangeNotifier {
  bool _isConnected = false;

  void updateStatus({required ConnectivityResult result}) {
    var newStatus = result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi;
    if (newStatus != _isConnected) {
      _isConnected = newStatus;
      notifyListeners();
    }
  }

  bool get isConnected => _isConnected;
}
