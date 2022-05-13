import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:fda_mystudies_http_client/participant_enroll_datastore_service.dart';
import 'package:fda_mystudies_http_client/study_datastore_service.dart';
import 'package:fda_mystudies_spec/common_specs/common_error_response.pb.dart';
import 'package:fda_mystudies_spec/participant_enroll_datastore_service/get_study_state.pbserver.dart';
import 'package:fda_mystudies_spec/study_datastore_service/get_study_list.pb.dart';
import 'package:flutter/widgets.dart';

import '../../main.dart';
import '../common/future_loading_page.dart';
import '../study_module/study_tile/study_tile.dart';
import '../user/user_data.dart';
import 'study_tile/pb_user_study_data.dart';

class GatewayHome extends StatelessWidget {
  const GatewayHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureLoadingPage.build(context,
        scaffoldTitle: curConfig.appName,
        future: _fetchStudyListAndUserStatus(), builder: (context, snapshot) {
      var userStudyStatusList = snapshot.data as List<PbUserStudyData>;
      return ListView.builder(
          itemCount: userStudyStatusList.length,
          itemBuilder: (context, index) =>
              StudyTile(userStudyStatusList[index]));
    }, showDrawer: true);
  }

  Future<Object> _fetchStudyListAndUserStatus() {
    var studyDatastoreService = getIt<StudyDatastoreService>();
    var participantUserDatastoreService =
        getIt<ParticipantEnrollDatastoreService>();
    return Future.wait([
      studyDatastoreService.getStudyList(UserData.shared.userId),
      participantUserDatastoreService.getStudyState(UserData.shared.userId)
    ]).then((value) {
      var studyListResponse = value[0];
      var userStudyStateListResponse = value[1];
      if (studyListResponse is CommonErrorResponse) {
        return studyListResponse;
      } else if (userStudyStateListResponse is CommonErrorResponse) {
        return userStudyStateListResponse;
      } else if (studyListResponse is GetStudyListResponse &&
          userStudyStateListResponse is GetStudyStateResponse) {
        var studyList = studyListResponse.studies;
        var userStudyStateList = userStudyStateListResponse.studies;
        var uniqueStudyIds = studyList.map((e) => e.studyId).toSet().toList();
        List<PbUserStudyData> pbUserStudyStatusList = [];
        for (String studyId in uniqueStudyIds) {
          var matchingStudyList = studyList.where((e) => e.studyId == studyId);
          var matchingStudyStateList =
              userStudyStateList.where((e) => e.studyId == studyId);
          if (matchingStudyList.isNotEmpty &&
              matchingStudyStateList.isNotEmpty) {
            pbUserStudyStatusList.add(PbUserStudyData(studyId,
                matchingStudyList.first, matchingStudyStateList.first));
          } else if (matchingStudyList.isNotEmpty &&
              matchingStudyStateList.isEmpty) {
            pbUserStudyStatusList.add(PbUserStudyData(studyId,
                matchingStudyList.first, GetStudyStateResponse_StudyState()));
          }
        }
        if (pbUserStudyStatusList.isNotEmpty) {
          return pbUserStudyStatusList;
        }
      }
      return CommonErrorResponse(
          status: 404,
          errorDescription: 'No valid user states found for the studies.');
    });
  }
}
