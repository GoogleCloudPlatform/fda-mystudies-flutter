import 'dart:typed_data';

import 'dart:convert';

import 'package:http/http.dart' as http;

class MockHttpClient implements http.Client {
  @override
  void close() {
    // TODO: implement close
  }

  @override
  Future<http.Response> delete(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<http.Response> get(Uri url, {Map<String, String>? headers}) {
    // TODO: implement get
    return Future.value(
        http.Response('{"userId": 3, "id": 3, "title": "test"}', 200));
  }

  @override
  Future<http.Response> head(Uri url, {Map<String, String>? headers}) {
    // TODO: implement head
    throw UnimplementedError();
  }

  @override
  Future<http.Response> patch(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    // TODO: implement patch
    throw UnimplementedError();
  }

  @override
  Future<http.Response> post(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    // TODO: implement post
    throw UnimplementedError();
  }

  @override
  Future<http.Response> put(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    // TODO: implement put
    throw UnimplementedError();
  }

  @override
  Future<String> read(Uri url, {Map<String, String>? headers}) {
    // TODO: implement read
    throw UnimplementedError();
  }

  @override
  Future<Uint8List> readBytes(Uri url, {Map<String, String>? headers}) {
    // TODO: implement readBytes
    throw UnimplementedError();
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    // TODO: implement send
    throw UnimplementedError();
  }
}
