import 'package:fda_mystudies_design_system/component/error_scenario.dart';
import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:fda_mystudies_http_client/study_datastore_service.dart';
import 'package:fda_mystudies_spec/common_specs/common_error_response.pb.dart';
import 'package:fda_mystudies_spec/study_datastore_service/get_study_list.pbserver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../mixin/connectivity_actions.dart';
import '../provider/connectivity_provider.dart';
import '../provider/user_study_state_provider.dart';
import '../route/route_name.dart';
import '../screen/study_state_check_screen.dart';
import '../study_module/study_tile/pb_study_enrollment_status.dart';
import '../user/user_data.dart';

class StudyStateCheckScreenController extends StatefulWidget {
  const StudyStateCheckScreenController({Key? key}) : super(key: key);

  @override
  State<StudyStateCheckScreenController> createState() =>
      _StudyStateCheckScreenControllerState();
}

class _StudyStateCheckScreenControllerState
    extends State<StudyStateCheckScreenController> with ConnectivityAction {
  var _studyStateCheckInProgress = true;

  @override
  void initState() {
    super.initState();
    dispatchOnConnectivityChanges(context, () {
      if (_studyStateCheckInProgress) {
        _fetchStudyState();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StudyStateCheckScreen(
        studyStateCheckInProgress: _studyStateCheckInProgress);
  }

  void _fetchStudyState() {
    final l10n = AppLocalizations.of(context)!;
    if (!Provider.of<ConnectivityProvider>(context, listen: false)
            .isConnected ||
        !_studyStateCheckInProgress) {
      return;
    }
    StudyDatastoreService studyDatastoreService =
        getIt<StudyDatastoreService>();
    studyDatastoreService.getStudyList(UserData.shared.userId).then((response) {
      if (response is CommonErrorResponse) {
        ErrorScenario.displayErrorMessageWithOKAction(
            context, response.errorDescription);
        setState(() {
          _studyStateCheckInProgress = false;
        });
      } else if (response is GetStudyListResponse) {
        if (curConfig.appType == AppType.gateway) {
          for (var studyState in response.studies) {
            Provider.of<UserStudyStateProvider>(context, listen: false)
                .assignStudyState(studyState.studyId, studyState);
          }
          context.goNamed(RouteName.userStateCheck);
        } else {
          var studyState = response.studies.firstWhere(
              (element) => element.studyId == UserData.shared.curStudyId,
              orElse: () => GetStudyListResponse_Study());
          if (studyState.studyId.isEmpty) {
            ErrorScenario.displayErrorMessageWithOKAction(context,
                'No study with study_id "${UserData.shared.curStudyId}" found!');
          } else if (studyState.status.studyStatus ==
              PbStudyEnrollmentStatus.closed) {
            ErrorScenario.displayErrorMessageWithOKAction(
                context, l10n.studyStatusClosed);
          } else if (studyState.status.studyStatus ==
              PbStudyEnrollmentStatus.paused) {
            ErrorScenario.displayErrorMessageWithOKAction(
                context, l10n.studyStatusEnrollmentPaused);
          } else if (studyState.status.studyStatus ==
              PbStudyEnrollmentStatus.active) {
            Provider.of<UserStudyStateProvider>(context, listen: false)
                .assignStudyState(studyState.studyId, studyState);
            context.goNamed(RouteName.userStateCheck);
          } else {
            ErrorScenario.displayErrorMessageWithOKAction(context,
                'Unknown status found for study with id: ${UserData.shared.curStudyId}');
          }
        }
        setState(() {
          _studyStateCheckInProgress = false;
        });
      }
    });
  }
}
