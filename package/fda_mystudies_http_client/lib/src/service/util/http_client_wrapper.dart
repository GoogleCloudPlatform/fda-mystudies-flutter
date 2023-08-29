import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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

  Future<http.Response> cachedGet(Uri url,
      {Map<String, String>? headers, bool prioritizeCache = false}) async {
    const secureStorage = FlutterSecureStorage(
        iOptions: IOSOptions(),
        aOptions: AndroidOptions(encryptedSharedPreferences: true));
    final cacheKey = url.toString();
    final isCached = await secureStorage.containsKey(key: cacheKey);
    if (prioritizeCache && isCached) {
      final responseBody = await secureStorage.read(key: cacheKey);
      if (responseBody != null) {
        return http.Response(responseBody, 200);
      }
    }
    try {
      final response = await client.get(url, headers: headers);
      if (response.statusCode == 200) {
        await secureStorage.write(key: cacheKey, value: response.body);
      }
      return response;
    } catch (e) {
      if (isCached) {
        final responseBody = await secureStorage.read(key: cacheKey);
        if (responseBody != null) {
          return http.Response(responseBody, 200);
        }
      }
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
