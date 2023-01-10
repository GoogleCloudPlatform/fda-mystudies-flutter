import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:uuid/uuid.dart';

class Session {
  final String correlationId;
  final String codeVerifier;
  final String codeChallenge;
  final String state;

  String authToken = '';
  String contactUsEmail = '';
  String fromEmail = '';
  String refreshToken = '';
  String supportEmail = '';

  static Session _session = Session.reset();
  static Session get shared => _session;

  Session(
      {required this.correlationId,
      required this.codeVerifier,
      required this.codeChallenge,
      required this.state});

  static Session reset() {
    final newCodeVerifier = RandomGenerator.getRandomString(50);
    var newSession = Session(
        correlationId: const Uuid().v4(),
        codeVerifier: newCodeVerifier,
        codeChallenge: _codeChallenge(newCodeVerifier),
        state: RandomGenerator.getRandomString(21));
    _session = newSession;
    return newSession;
  }

  static String _codeChallenge(String verifier) {
    var bytes = utf8.encode(verifier);
    var digest = sha256.convert(bytes);
    return const Base64Encoder.urlSafe()
        .convert(digest.bytes)
        .replaceAll('+', '-')
        .replaceAll('/', '_')
        .replaceAll('=', '');
  }
}

class RandomGenerator {
  static const _chars =
      'abcdefghjklmnpqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ12345789';
  static final Random _rnd = Random();

  static String getRandomString(int length) =>
      String.fromCharCodes(Iterable.generate(
          length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
}
