import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

import '../injection/environment.dart';
import '../mock/mock_http_client.dart';

@module
abstract class RegisterModule {
  @demo
  @injectable
  http.Client get mockClient => MockHttpClient();

  @live
  @injectable
  http.Client get liveClient => http.Client();
}
