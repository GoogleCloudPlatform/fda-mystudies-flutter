import 'package:fda_mystudies/config/demo_config.dart' as dc;
import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';

class ConfigMapping {
  static const String configKey = 'config';
  static const String demoEnv = 'demo';
  static const String devEnv = 'dev';
  static const String stagingEnv = 'staging';
  static const String prodEnv = 'production';
  static const String defaultEnvironment = demoEnv;
  static Map<String, Config> configMap = {
    demoEnv: dc.DemoConfig(),
    devEnv: dc.DemoConfig(),
    stagingEnv: dc.DemoConfig(),
    prodEnv: dc.DemoConfig()
  };
}
