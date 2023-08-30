import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:fda_mystudies_activity_ui_kit/fda_mystudies_activity_ui_kit.dart'
    as ui_kit;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'config/app_config.dart';
import 'fda_mystudies_app.dart';
import 'src/provider/activities_provider.dart';
import 'src/provider/activity_step_provider.dart';
import 'src/provider/connectivity_provider.dart';
import 'src/provider/dashboard_provider.dart';
import 'src/provider/eligibility_consent_provider.dart';
import 'src/provider/local_auth_provider.dart';
import 'src/provider/my_account_provider.dart';
import 'src/provider/user_study_state_provider.dart';
import 'src/provider/welcome_provider.dart';

void main() {
  configureDependencies(AppConfig.shared.currentConfig);
  ui_kit.configureDependencies();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => ConnectivityProvider()),
    ChangeNotifierProvider(create: (context) => LocalAuthProvider()),
    ChangeNotifierProvider(create: (context) => WelcomeProvider()),
    ChangeNotifierProvider(create: (context) => MyAccountProvider()),
    ChangeNotifierProvider(create: (context) => EligibilityConsentProvider()),
    ChangeNotifierProvider(create: (context) => UserStudyStateProvider()),
    ChangeNotifierProvider(create: (context) => DashboardProvider()),
    ChangeNotifierProvider(create: (context) => ActivitiesProvider()),
    ChangeNotifierProvider(create: (context) => ActivityStepProvider())
  ], child: const FDAMyStudiesApp()));
}
