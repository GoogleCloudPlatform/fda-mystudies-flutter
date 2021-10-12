import 'dart:convert';
import 'dart:developer' as developer;

import 'package:fda_mystudies_http_client/service/sample_service/sample_service.dart';
import 'package:fda_mystudies_spec/sample_service/album.pbserver.dart';

import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

@Injectable(as: SampleService)
class SampleServiceImpl implements SampleService {
  final http.Client client;

  SampleServiceImpl(this.client);

  @override
  Future<Album> makeCall() {
    return client
        .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'))
        .then((response) {
      developer.log('CALL LIVE STATUS CODE: ${response.statusCode}');
      developer.log('CALL LIVE RESPONSE: ${response.body}');

      var album = Album.create()
        ..mergeFromProto3Json(jsonDecode(response.body));
      return album;
    });
  }
}
