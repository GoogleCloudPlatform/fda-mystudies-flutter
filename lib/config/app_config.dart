import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';

import 'demo_config.dart' as dc;

// Singleton to wrap current-config and demo-config constants that are set
// to run the app in any and demo environment respectively.
class AppConfig {
  // Current config can be configs for live or demo environment.
  final Config _currentConfig = dc.DemoConfig();

  // Demo config should contain configs only for demo environment.
  final dc.DemoConfig _demoConfig = dc.DemoConfig();

  AppConfig._init();

  static final AppConfig shared = AppConfig._init();

  Config get currentConfig => _currentConfig;
  dc.DemoConfig get demoConfig => _demoConfig;
}
