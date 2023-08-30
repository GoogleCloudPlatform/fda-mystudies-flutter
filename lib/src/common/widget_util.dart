import 'package:fda_mystudies_spec/common_specs/common_error_response.pb.dart';
import 'package:flutter/material.dart';

Future<T?> push<T extends Object?>(BuildContext context, Widget widget) {
  return Navigator.of(context)
      .push(MaterialPageRoute(builder: (BuildContext context) {
    return widget;
  }));
}

String processResponse(dynamic response, String successfulMessage) {
  if (response is CommonErrorResponse) {
    var errorResponse = response.errorDescription;
    return errorResponse.isEmpty ? 'Something went wrong!' : errorResponse;
  }
  return successfulMessage;
}

void showUserMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
