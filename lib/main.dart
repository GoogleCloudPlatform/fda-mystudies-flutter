import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'fda_mystudies_app.dart';
import 'config/demo_config.dart' as dc;

void main() {
  configureDependencies(dc.DemoConfig());
  runApp(const FDAMyStudiesApp());
}
