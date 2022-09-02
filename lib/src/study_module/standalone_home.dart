import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:fda_mystudies_http_client/participant_enroll_datastore_service.dart';
import 'package:fda_mystudies_http_client/study_datastore_service.dart';
import 'package:fda_mystudies_spec/common_specs/common_error_response.pb.dart';
import 'package:fda_mystudies_spec/participant_enroll_datastore_service/get_study_state.pb.dart';
import 'package:fda_mystudies_spec/study_datastore_service/get_study_list.pb.dart';
import 'package:fda_mystudies_spec/study_datastore_service/study_info.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../main.dart';
import '../common/future_loading_page.dart';
import '../common/widget_util.dart';
import '../theme/fda_color_scheme.dart';
import '../theme/fda_text_style.dart';
import '../user/user_data.dart';
import '../widget/fda_button.dart';
import '../widget/fda_scaffold.dart';
import 'study_status_router.dart';
import 'study_tile/pb_user_study_data.dart';

class StandaloneHome extends StatefulWidget {
  final PbUserStudyData? userStudyData;

  const StandaloneHome({this.userStudyData, Key? key}) : super(key: key);

  @override
  State<StandaloneHome> createState() => _StandaloneHomeState();
}

class _StandaloneHomeState extends State<StandaloneHome> {
  var _isLoading = false;
  late final Future<Object>? studyInfo;

  @override
  void initState() {
    super.initState();
    StudyDatastoreService studyDatastoreService =
        getIt<StudyDatastoreService>();
    studyInfo =
        studyDatastoreService.getStudyInfo(UserData.shared.curStudyId, '');
  }

  @override
  Widget build(BuildContext context) {
    return FutureLoadingPage.build(context,
        scaffoldTitle: '',
        wrapInScaffold: false,
        future: studyInfo, builder: (context, snapshot) {
      var response = snapshot.data as StudyInfoResponse;
      var infoItem = response.infos.first;
      return FDAScaffold(
          child: ListView(padding: const EdgeInsets.all(24), children: [
        const SizedBox(height: 18),
        Image(
          image: const AssetImage('assets/images/logo.png'),
          color: FDAColorScheme.googleBlue(context),
          width: 52,
          height: 47,
        ),
        const SizedBox(height: 40),
        Text(curConfig.appName,
            textAlign: TextAlign.center, style: FDATextStyle.heading(context)),
        const SizedBox(height: 12),
        Text(curConfig.organization,
            textAlign: TextAlign.center,
            style: FDATextStyle.subHeadingBold(context)),
        const SizedBox(height: 28),
        const Divider(
          thickness: 1,
          color: Color(0x1A000000),
        ),
        const SizedBox(height: 28),
        Text(infoItem.text,
            textAlign: TextAlign.center,
            style: FDATextStyle.subHeadingRegular(context)),
        const SizedBox(height: 155),
        Padding(
            padding: const EdgeInsets.fromLTRB(58, 0, 58, 0),
            child: FDAButton(
                title: AppLocalizations.of(context)
                    .standaloneHomeParticipateButton,
                onPressed: _proceedToParticipate(context)))
      ]));
    });
  }

  void Function()? _proceedToParticipate(BuildContext context) {
    return _isLoading
        ? null
        : () {
            setState(() {
              _isLoading = true;
            });
            _loadUserData().then((value) {
              if (value is PbUserStudyData) {
                StudyStatusRouter.nextStep(context, value);
              } else {
                showUserMessage(context, value as String);
              }
              setState(() {
                _isLoading = false;
              });
              return;
            });
          };
  }

  Future<Object> _loadUserData() {
    if (widget.userStudyData != null) {
      return Future.value(widget.userStudyData);
    }
    StudyDatastoreService studyDatastoreService =
        getIt<StudyDatastoreService>();
    ParticipantEnrollDatastoreService participantEnrollDatastoreService =
        getIt<ParticipantEnrollDatastoreService>();
    var commonErrorDescription =
        '${AppLocalizations.of(context).noUserStateFoundForStudyErrorMsg} : ${UserData.shared.curStudyId}.';
    return Future.wait([
      studyDatastoreService.getStudyList(UserData.shared.userId),
      participantEnrollDatastoreService.getStudyState(UserData.shared.userId)
    ]).then((value) {
      var studyInfoResponse = value[0];
      var userStudyStateResponse = value[1];
      if (studyInfoResponse is CommonErrorResponse) {
        return studyInfoResponse.errorDescription.isEmpty
            ? commonErrorDescription
            : studyInfoResponse.errorDescription;
      } else if (userStudyStateResponse is CommonErrorResponse) {
        return userStudyStateResponse.errorDescription.isEmpty
            ? commonErrorDescription
            : userStudyStateResponse.errorDescription;
      } else if (studyInfoResponse is GetStudyListResponse &&
          userStudyStateResponse is GetStudyStateResponse) {
        var matchingStudyList = studyInfoResponse.studies
            .where((e) => e.studyId == UserData.shared.curStudyId);
        var matchingStudyStateList = userStudyStateResponse.studies
            .where((e) => e.studyId == UserData.shared.curStudyId);
        if (matchingStudyList.isNotEmpty) {
          if (matchingStudyStateList.isNotEmpty) {
            UserData.shared.curParticipantId =
                matchingStudyStateList.first.participantId;
            UserData.shared.currentStudyTokenIdentifier =
                matchingStudyStateList.first.hashedToken;
            UserData.shared.curSiteId = matchingStudyStateList.first.siteId;
            UserData.shared.curStudyAdherence =
                matchingStudyStateList.first.adherence;
            UserData.shared.curStudyCompletion =
                matchingStudyStateList.first.completion;
            return PbUserStudyData(UserData.shared.curStudyId,
                matchingStudyList.first, matchingStudyStateList.first);
          } else {
            return PbUserStudyData(UserData.shared.curStudyId,
                matchingStudyList.first, GetStudyStateResponse_StudyState());
          }
        }
      }
      return commonErrorDescription;
    });
  }
}
