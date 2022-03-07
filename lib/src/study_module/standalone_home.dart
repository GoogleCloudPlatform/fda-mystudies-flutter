import 'dart:ui';

import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:fda_mystudies_http_client/participant_enroll_datastore_service.dart';
import 'package:fda_mystudies_http_client/study_datastore_service.dart';
import 'package:fda_mystudies_spec/common_specs/common_error_response.pb.dart';
import 'package:fda_mystudies_spec/participant_enroll_datastore_service/get_study_state.pb.dart';
import 'package:fda_mystudies_spec/study_datastore_service/get_study_list.pb.dart';
import 'package:fda_mystudies_spec/study_datastore_service/study_info.pb.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../common/future_loading_page.dart';
import '../common/widget_util.dart';
import '../theme/fda_text_theme.dart';
import '../user/user_data.dart';
import '../widget/fda_button.dart';
import 'study_status_routing.dart';
import 'study_tile/pb_user_study_data.dart';

class StandaloneHome extends StatefulWidget {
  final PbUserStudyData? userStudyData;

  const StandaloneHome({this.userStudyData, Key? key}) : super(key: key);

  @override
  State<StandaloneHome> createState() => _StandaloneHomeState();
}

class _StandaloneHomeState extends State<StandaloneHome> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    StudyDatastoreService studyDatastoreService =
        getIt<StudyDatastoreService>();
    return FutureLoadingPage(
        '',
        studyDatastoreService.getStudyInfo(
            UserData.shared.curStudyId, UserData.shared.userId),
        (context, snapshot) {
      var response = snapshot.data as StudyInfoResponse;
      var infoItem = response.infos.first;
      var isDarkModeEnabled =
          MediaQuery.of(context).platformBrightness == Brightness.dark;
      var blendMode = isDarkModeEnabled ? BlendMode.darken : BlendMode.lighten;
      var blendColor = isDarkModeEnabled ? Colors.black : Colors.white;
      return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: Image.memory(
                        Uri.parse(infoItem.image).data!.contentAsBytes())
                    .image,
                colorFilter:
                    ColorFilter.mode(blendColor.withOpacity(0.5), blendMode),
                fit: BoxFit.cover),
          ),
          child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                  color: Colors.black.withOpacity(0.1),
                  child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Center(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                            Text(infoItem.title,
                                style: FDATextTheme.headerTextStyle(context),
                                textAlign: TextAlign.center),
                            const SizedBox(height: 22),
                            Text(infoItem.text,
                                style: FDATextTheme.bodyTextStyle(context),
                                textAlign: TextAlign.center),
                            const SizedBox(height: 22),
                            FDAButton(
                                isLoading: _isLoading,
                                title: 'Participate',
                                onPressed: _proceedToParticipate(context))
                          ]))))));
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
                StudyStatusRouting.nextStep(context, value);
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
        'No valid user states found for the study with id : ${UserData.shared.curStudyId}.';
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
