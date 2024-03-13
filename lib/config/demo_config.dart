import 'dart:io';

import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:injectable/injectable.dart';

class DemoConfig implements Config {
  Map<String, String> serviceMethodScenarioMap = {};
  int delay = 0;

  @override
  String get apiKey => 'API_KEY';

  @override
  AppType get appType => AppType.standalone;

  @override
  String get appId => 'fda-mystudies-flutter';

  @override
  String get appName => 'Akuaba Maternal Health Study';

  @override
  String get organization => 'University of Ghana Medical Centre';

  @override
  String get baseParticipantUrl => 'participants.fda-mystudies.test-url.com';

  @override
  String get baseStudiesUrl => 'studies.fda-mystudies.test-url.com';

  @override
  Environment get environment => demo;

  @override
  String get hydraClientId => 'HYDRACLIENTID';

  @override
  String get platform => (Platform.isIOS ? 'IOS' : 'ANDROID');

  @override
  Map<String, String> get scenarios => serviceMethodScenarioMap;

  @override
  String get source => 'MOBILE APPS';

  @override
  String get studyId => 'fda-mystudies';

  @override
  String get version => '1.0';

  @override
  int get delayInSeconds => delay;

  @override
  String get fitbitClientId => '';

  @override
  String get fitbitClientSecret => '';

  @override
  String get fitbitRedirectUri => 'app://com.google.fda_mystudies/mystudies';

  @override
  String get fitbitCallbackScheme => 'app';
  
}
