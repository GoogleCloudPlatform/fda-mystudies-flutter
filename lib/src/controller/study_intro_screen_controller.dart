import 'package:fda_mystudies_design_system/component/error_scenario.dart';
import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:fda_mystudies_http_client/study_datastore_service.dart';
import 'package:fda_mystudies_spec/common_specs/common_error_response.pb.dart';
import 'package:fda_mystudies_spec/study_datastore_service/study_info.pb.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../mixin/connectivity_actions.dart';
import '../provider/connectivity_provider.dart';
import '../provider/welcome_provider.dart';
import '../route/route_name.dart';
import '../screen/study_intro_screen.dart';
import '../user/user_data.dart';

class StudyIntroScreenController extends StatefulWidget {
  const StudyIntroScreenController({Key? key}) : super(key: key);

  @override
  State<StudyIntroScreenController> createState() =>
      _StudyIntroScreenControllerState();
}

class _StudyIntroScreenControllerState extends State<StudyIntroScreenController>
    with ConnectivityAction {
  var displayShimmer = true;

  @override
  void initState() {
    super.initState();
    dispatchOnConnectivityChanges(context, () {
      if (displayShimmer) {
        _getStudyInfo();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StudyIntroScreen(
        appName: curConfig.appName,
        orgName: curConfig.organization,
        displayShimmer: displayShimmer,
        participate: _participate);
  }

  void _participate() {
    context.pushNamed(RouteName.eligibilityRouter);
  }

  void _getStudyInfo() {
    if (!Provider.of<ConnectivityProvider>(context, listen: false)
            .isConnected ||
        !displayShimmer) {
      return;
    }
    StudyDatastoreService studyDatastoreService =
        getIt<StudyDatastoreService>();
    studyDatastoreService
        .getStudyInfo(UserData.shared.curStudyId, UserData.shared.userId)
        .then((value) {
      if (value is CommonErrorResponse) {
        ErrorScenario.displayErrorMessageWithOKAction(
            context, value.errorDescription);
      } else if (value is StudyInfoResponse) {
        Provider.of<WelcomeProvider>(context, listen: false).updateContent(
            title: value.infos.first.title, info: value.infos.first.text);
        setState(() {
          displayShimmer = false;
        });
      }
    });
  }
}
