import 'dart:developer' as developer;

import 'package:fda_mystudies_design_system/component/error_scenario.dart';
import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:fda_mystudies_http_client/participant_user_datastore_service.dart';
import 'package:fda_mystudies_http_client/study_datastore_service.dart';
import 'package:fda_mystudies_spec/common_specs/common_error_response.pb.dart';
import 'package:fda_mystudies_spec/study_datastore_service/study_info.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../config/app_config.dart';
import '../mixin/connectivity_actions.dart';
import '../provider/welcome_provider.dart';
import '../route/route_name.dart';
import '../screen/welcome_screen.dart';

class WelcomeScreenController extends StatefulWidget {
  const WelcomeScreenController({Key? key}) : super(key: key);

  @override
  State<WelcomeScreenController> createState() =>
      _WelcomeScreenControllerState();
}

class _WelcomeScreenControllerState extends State<WelcomeScreenController>
    with ConnectivityAction {
  var displayShimmer = true;

  @override
  void initState() {
    super.initState();
    dispatchOnConnectivityChanges(context, () {
      _fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WelcomeScreen(
        displayShimmer: displayShimmer,
        continueToOnboarding: _continueToOnboarding,
        continueToSignIn: _continueToSignIn);
  }

  void _continueToOnboarding() {
    context.pushNamed(RouteName.onboardingInstructions);
  }

  void _continueToSignIn() {
    context.pushNamed(RouteName.signIn);
  }

  void _fetchData() {
    if (!displayShimmer) {
      return;
    }
    Future.wait([_getAppInfo(), _getStudyInfo()]).then((value) {
      if (!(value[0] is CommonErrorResponse ||
          value[1] is CommonErrorResponse)) {
        developer.log('EVERYTHING WORKED OUT WELL!');
      }
    });
  }

  Future<dynamic> _getStudyInfo() {
    final l10n = AppLocalizations.of(context)!;
    StudyDatastoreService studyDatastoreService =
        getIt<StudyDatastoreService>();
    return studyDatastoreService
        .getStudyInfo(AppConfig.shared.currentConfig.studyId, '')
        .then((value) {
      if (value is CommonErrorResponse) {
        ErrorScenario.displayAppropriateErrorMessage(
            context, value.errorDescription,
            action: SnackBarAction(
                label: l10n.retryErrorMessage, onPressed: () => _fetchData()));
      } else if (value is StudyInfoResponse) {
        Provider.of<WelcomeProvider>(context, listen: false).updateContent(
            title: value.infos.first.title, info: value.infos.first.text);
        setState(() {
          displayShimmer = false;
        });
      }
      return value;
    });
  }

  Future<dynamic> _getAppInfo() {
    final l10n = AppLocalizations.of(context)!;
    ParticipantUserDatastoreService participantUserDatastoreService =
        getIt<ParticipantUserDatastoreService>();
    return participantUserDatastoreService.appInfo().then((value) {
      if (value is CommonErrorResponse) {
        ErrorScenario.displayAppropriateErrorMessage(
            context, value.errorDescription,
            action: SnackBarAction(
                label: l10n.retryErrorMessage, onPressed: () => _fetchData()));
      }
      return value;
    });
  }
}
