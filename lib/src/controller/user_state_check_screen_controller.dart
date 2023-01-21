import 'package:fda_mystudies_design_system/component/error_scenario.dart';
import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:fda_mystudies_http_client/participant_enroll_datastore_service.dart';
import 'package:fda_mystudies_spec/common_specs/common_error_response.pb.dart';
import 'package:fda_mystudies_spec/participant_enroll_datastore_service/get_study_state.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../mixin/connectivity_actions.dart';
import '../provider/connectivity_provider.dart';
import '../provider/user_study_state_provider.dart';
import '../route/route_name.dart';
import '../screen/user_state_check_screen.dart';
import '../study_module/study_tile/pb_user_study_status.dart';
import '../user/user_data.dart';

class UserStateCheckScreenController extends StatefulWidget {
  const UserStateCheckScreenController({Key? key}) : super(key: key);

  @override
  State<UserStateCheckScreenController> createState() =>
      _UserStateCheckScreenControllerState();
}

class _UserStateCheckScreenControllerState
    extends State<UserStateCheckScreenController> with ConnectivityAction {
  var _userStateCheckInProgress = true;

  @override
  void initState() {
    super.initState();
    dispatchOnConnectivityChanges(context, () {
      if (_userStateCheckInProgress) {
        _fetchUserState();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return UserStateCheckScreen(
        userStateCheckInProgress: _userStateCheckInProgress);
  }

  void _fetchUserState() {
    if (!Provider.of<ConnectivityProvider>(context, listen: false)
            .isConnected ||
        !_userStateCheckInProgress) {
      return;
    }
    final l10n = AppLocalizations.of(context);
    ParticipantEnrollDatastoreService participantEnrollDatastoreService =
        getIt<ParticipantEnrollDatastoreService>();
    participantEnrollDatastoreService
        .getStudyState(UserData.shared.userId)
        .then((response) {
      if (response is CommonErrorResponse) {
        ErrorScenario.displayErrorMessageWithOKAction(
            context, response.errorDescription);
      } else if (response is GetStudyStateResponse) {
        if (curConfig.appType == AppType.gateway) {
          for (var userState in response.studies) {
            Provider.of<UserStudyStateProvider>(context, listen: false)
                .assignUserState(userState.studyId, userState);
          }
          context.goNamed(RouteName.gatewayHome);
        } else {
          var userStudyState = response.studies.firstWhere(
              (element) => element.studyId == UserData.shared.curStudyId,
              orElse: () => GetStudyStateResponse_StudyState());
          Provider.of<UserStudyStateProvider>(context, listen: false)
              .assignUserState(userStudyState.studyId, userStudyState);
          var studyState =
              Provider.of<UserStudyStateProvider>(context, listen: false)
                  .studyState(UserData.shared.curStudyId);
          if (studyState == null || studyState.studyId.isEmpty) {
            ErrorScenario.displayErrorMessageWithOKAction(context,
                'No study with study_id "${UserData.shared.curStudyId}" found!');
          } else if (userStudyState.status.userStudyStatus ==
                  PbUserStudyStatus.yetToEnroll ||
              userStudyState.status.userStudyStatus ==
                  PbUserStudyStatus.notEligible) {
            if (studyState.settings.enrolling) {
              context.goNamed(RouteName.studyIntro);
            } else {
              ErrorScenario.displayErrorMessageWithOKAction(
                  context,
                  curConfig.appType == AppType.standalone
                      ? l10n.studyStatusEnrollmentNotAllowedInStandaloneApp
                      : l10n.studyStatusEnrollmentNotAllowedInGatewayApp);
            }
          } else if (userStudyState.status.userStudyStatus ==
              PbUserStudyStatus.withdrawn) {
            context.goNamed(RouteName.studyIntro);
          } else if (userStudyState.status.userStudyStatus ==
                  PbUserStudyStatus.completed ||
              userStudyState.status.userStudyStatus ==
                  PbUserStudyStatus.enrolled) {
            UserData.shared.curStudyId = userStudyState.studyId;
            UserData.shared.curStudyName = studyState.title;
            UserData.shared.curStudyVersion = studyState.studyVersion;
            UserData.shared.curParticipantId = userStudyState.participantId;
            UserData.shared.curSiteId = userStudyState.siteId;
            UserData.shared.currentStudyTokenIdentifier =
                userStudyState.hashedToken;
            UserData.shared.curStudyCompletion = userStudyState.completion;
            UserData.shared.curStudyAdherence = userStudyState.adherence;
            context.goNamed(RouteName.studyHome);
          }
        }
        setState(() {
          _userStateCheckInProgress = false;
        });
      }
    });
  }
}
