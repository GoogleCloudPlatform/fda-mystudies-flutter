import 'package:fda_mystudies_http_client/injection/environment.dart';
import 'package:fda_mystudies_http_client/mock/mock_http_client.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

@module
abstract class RegisterModule {
  @demo
  @injectable
  http.Client get mockClient => MockHttpClient();

  @live
  @injectable
  http.Client get liveClient => http.Client();
}
