import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:fda_mystudies_activity_ui_kit/fda_mystudies_activity_ui_kit.dart'
    as ui_kit;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'fda_mystudies_app.dart';
import 'config/demo_config.dart' as dc;
import 'config/platform_config.dart';

final demoConfig = dc.DemoConfig();

void main() {
  configureDependencies(demoConfig);
  ui_kit.configureDependencies(PlatformConfig());
  runApp(const FDAMyStudiesApp());
}
