import 'dart:io';

import 'package:fda_mystudies_activity_ui_kit/fda_mystudies_activity_ui_kit.dart';

class PlatformConfig extends Config {
  @override
  String get operatingSystem => Platform.isIOS ? 'ios' : 'android';
}
