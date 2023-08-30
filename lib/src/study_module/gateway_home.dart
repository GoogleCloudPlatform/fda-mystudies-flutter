import 'package:fda_mystudies_spec/common_specs/common_error_response.pb.dart';
import 'package:fda_mystudies_spec/participant_enroll_datastore_service/get_study_state.pbserver.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../config/app_config.dart';
import '../common/future_loading_page.dart';
import '../provider/user_study_state_provider.dart';
import '../study_module/study_tile/study_tile.dart';
import 'study_tile/pb_user_study_data.dart';

class GatewayHome extends StatelessWidget {
  const GatewayHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureLoadingPage.build(context,
        scaffoldTitle: AppConfig.shared.currentConfig.appName,
        future: _fetchStudyListAndUserStatus(context),
        builder: (context, snapshot) {
      var userStudyStatusList = snapshot.data as List<PbUserStudyData>;
      return ListView.builder(
          itemCount: userStudyStatusList.length,
          itemBuilder: (context, index) =>
              StudyTile(userStudyStatusList[index]));
    }, showDrawer: true);
  }

  Future<Object> _fetchStudyListAndUserStatus(BuildContext context) {
    List<PbUserStudyData> pbUserStudyStatusList = [];
    final studyIds =
        Provider.of<UserStudyStateProvider>(context, listen: false).studyIds;
    for (String studyId in studyIds) {
      final studyState =
          Provider.of<UserStudyStateProvider>(context, listen: false)
              .studyState(studyId);
      final userState =
          Provider.of<UserStudyStateProvider>(context, listen: false)
                  .userState(studyId) ??
              GetStudyStateResponse_StudyState();
      if (studyState != null) {
        pbUserStudyStatusList
            .add(PbUserStudyData(studyId, studyState, userState));
      }
    }

    if (pbUserStudyStatusList.isNotEmpty) {
      return Future.value(pbUserStudyStatusList);
    }
    return Future.value(CommonErrorResponse()
      ..status = 404
      ..errorDescription = 'No valid user states found for the studies.');
  }
}
