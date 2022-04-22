import 'dart:convert';

import 'package:fda_mystudies_spec/common_specs/common_request_header.pb.dart';

import '../config.dart';
import '../../service/session.dart';

enum AuthorizationType { basic, bearer }

enum ContentType { json, fromUrlEncoded }

extension RequestHeaderExtension on CommonRequestHeader {
  void from(Config config,
      {AuthorizationType? authType,
      ContentType? contentType,
      String? authToken,
      String? userId}) {
    this
      ..appId = config.appId
      ..applicationId = config.appId
      ..source = config.source
      ..appName = config.appName
      ..mobilePlatform = config.platform
      ..appVersion = config.version
      ..correlationId = Session.shared.correlationId;

    var authorization = _getAuthorizationHeader(config, authType, authToken);
    if (authorization != null) {
      this.authorization = authorization;
    }

    var contentTypeValue = contentType?.stringValue();
    if (contentTypeValue != null) {
      this.contentType = contentTypeValue;
    }

    if (userId != null) {
      this.userId = userId;
    }
  }

  String? _getAuthorizationHeader(
      Config config, AuthorizationType? type, String? authToken) {
    if (type == AuthorizationType.basic) {
      return 'Basic ${const Base64Encoder().convert(utf8.encode(config.apiKey))}';
    } else if (authToken != null) {
      return authToken;
    }
    return null;
  }
}

extension _ContentTypeToString on ContentType {
  String? stringValue() {
    switch (this) {
      case ContentType.json:
        return 'application/json';
      case ContentType.fromUrlEncoded:
        return 'application/x-www-form-urlencoded';
      default:
        return null;
    }
  }
}
