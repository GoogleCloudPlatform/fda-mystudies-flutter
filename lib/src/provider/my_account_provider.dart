import 'package:flutter/material.dart';

class MyAccountProvider extends ChangeNotifier {
  String? _email;
  String? _userId;
  String? _tempRegistrationId;
  String? _code;

  MyAccountProvider(
      {String? email, String? userId, String? tempRegId, String? code}) {
    _email = email ?? '';
    _userId = userId ?? '';
    _tempRegistrationId = tempRegId ?? '';
    _code = code ?? '';
  }

  void updateContent(
      {String? email, String? userId, String? tempRegId, String? code}) {
    if (email != null && email.isNotEmpty) {
      _email = email;
    }
    if (userId != null && userId.isNotEmpty) {
      _userId = userId;
    }
    if (tempRegId != null && tempRegId.isNotEmpty) {
      _tempRegistrationId = tempRegId;
    }
    if (code != null && code.isNotEmpty) {
      _code = code;
    }
    notifyListeners();
  }

  String get email => _email ?? '';
  String get userId => _userId ?? '';
  String get tempRegId => _tempRegistrationId ?? '';
  String get code => _code ?? '';
}
