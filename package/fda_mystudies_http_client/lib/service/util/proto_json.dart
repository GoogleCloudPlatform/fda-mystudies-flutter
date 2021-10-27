import 'dart:convert';

import 'package:protobuf/protobuf.dart';

extension ProtoJson on GeneratedMessage {
  void fromJson(String json) {
    mergeFromProto3Json(jsonDecode(json), ignoreUnknownFields: true);
  }

  Map<String, dynamic> toJson() {
    return toProto3Json() as Map<String, dynamic>;
  }

  Map<String, String> toHeaderJson() {
    var protoJsonMap = toProto3Json() as Map<String, dynamic>;
    return protoJsonMap.map((key, value) => MapEntry(key, value.toString()));
  }
}
