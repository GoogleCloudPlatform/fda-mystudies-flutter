import 'package:http/http.dart' as http;

class MockHttpClient implements http.Client {
  @override
  Future<http.Response> get(Uri url, {Map<String, String>? headers}) {
    return Future.value(
        http.Response('{"userId": 3, "id": 3, "title": "test"}', 200));
  }

  @override
  // method to ignore overriding unnecessary methods.
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
