import 'dart:convert';

import 'package:http/http.dart' as http;

class HTTPClientWrapper {
  final http.Client client;

  HTTPClientWrapper(this.client);

  Future<http.Response> get(Uri url, {Map<String, String>? headers}) async {
    try {
      return await client.get(url, headers: headers);
    } catch (e) {
      return Future.value(
          http.Response('{"error_description": "${e.toString()}"}', 502));
    }
  }

  Future<http.Response> post(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    try {
      return await client.post(url,
          headers: headers, body: body, encoding: encoding);
    } catch (e) {
      return Future.value(
          http.Response('{"error_description": "${e.toString()}"}', 502));
    }
  }

  Future<http.Response> delete(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
    try {
      return await client.delete(url,
          headers: headers, body: body, encoding: encoding);
    } catch (e) {
      return Future.value(
          http.Response('{"error_description": "${e.toString()}"}', 502));
    }
  }

  Future<http.Response> put(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
    try {
      return await client.put(url,
          headers: headers, body: body, encoding: encoding);
    } catch (e) {
      return Future.value(
          http.Response('{"error_description": "${e.toString()}"}', 502));
    }
  }
}
