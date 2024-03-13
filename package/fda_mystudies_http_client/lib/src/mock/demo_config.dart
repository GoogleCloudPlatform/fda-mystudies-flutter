import 'package:injectable/injectable.dart';

import '../injection/environment.dart';
import '../service/config.dart';

class DemoConfig implements Config {
  Map<String, String> serviceMethodScenarioMap = {};
  int delay = 0;

  @override
  String get apiKey => 'API_KEY';

  @override
  AppType get appType => AppType.gateway;

  @override
  String get appId => 'DEMO-APP';

  @override
  String get appName => 'FDA MyStudies';

  @override
  String get organization => 'Google Cloud Platform';

  @override
  String get baseParticipantUrl => 'participants.fda-mystudies.test-url.com';

  @override
  String get baseStudiesUrl => 'studies.fda-mystudies.test-url.com';

  @override
  Environment get environment => demo;

  @override
  String get hydraClientId => 'HYDRACLIENTID';

  @override
  String get studyId => 'study-id';

  @override
  String get version => '1.0';

  @override
  String get platform => 'IOS';

  @override
  String get source => 'MOBILE APPS';
  
  @override
  String get fitbitClientId => '';

  @override
  String get fitbitClientSecret => '';

  @override 
  String get fitbitRedirectUri => 'app://com.google.fda_mystudies/mystudies';

  @override 
  String get fitbitCallbackScheme => 'app';

  @override
  Map<String, String> get scenarios => serviceMethodScenarioMap;

  @override
  int get delayInSeconds => delay;
}
