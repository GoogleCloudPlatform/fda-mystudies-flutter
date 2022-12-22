import 'package:flutter/material.dart';

class MyAccountProvider extends ChangeNotifier {
  String? _email;
  String? _userId;
  String? _tempRegistrationId;

  MyAccountProvider({String? email, String? userId, String? tempRegId}) {
    _email = email ?? '';
    _userId = userId ?? '';
    _tempRegistrationId = tempRegId ?? '';
  }

  void updateContent({String? email, String? userId, String? tempRegId}) {
    if (email != null && email.isNotEmpty) {
      _email = email;
    }
    if (userId != null && userId.isNotEmpty) {
      _userId = userId;
    }
    if (tempRegId != null && tempRegId.isNotEmpty) {
      _tempRegistrationId = tempRegId;
    }
    notifyListeners();
  }

  String get email => _email ?? '';
  String get userId => _userId ?? '';
  String get tempRegId => _tempRegistrationId ?? '';
}
