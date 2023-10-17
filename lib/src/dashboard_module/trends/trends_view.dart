import 'package:fda_mystudies_http_client/activity_step_key_id.dart';
import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:fda_mystudies_http_client/response_datastore_service.dart';
import 'package:fda_mystudies_spec/database_model/activity_response.pb.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../common/future_loading_page.dart';
import '../../dashboard_module/trends/chart_time_range.dart';
import '../../provider/dashboard_provider.dart';
import '../../user/user_data.dart';
import 'chart_tile.dart';
import 'recorded_value.dart';

class TrendsView extends StatelessWidget {
  const TrendsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final charts =
        Provider.of<DashboardProvider>(context, listen: false).dashboard.charts;
    return FutureLoadingPage.build(context,
        scaffoldTitle: 'TRENDS',
        future: _fetchRecordedValues(charts
            .map((e) => ActivityStepKeyId(
                activityId: e.dataSource.activity.activityId,
                stepKey: e.dataSource.key))
            .toList()), builder: (context, snapshot) {
      var recordedValues = snapshot.data as Map<String, List<RecordedValue>>;
      return SafeArea(
          child: ListView.builder(
              itemCount: charts.length,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) => ChartTile(
                  charts[index].title,
                  charts[index].dataSource.timeRangeType.chartTimeRange,
                  charts[index].displayName,
                  recordedValues[
                          '${charts[index].dataSource.activity.activityId}${charts[index].dataSource.key}'] ??
                      [])));
    });
  }

  Future<Map<String, List<RecordedValue>>> _fetchRecordedValues(
      List<ActivityStepKeyId> activityStepKeyIdList) {
    var responseDatastoreService = getIt<ResponseDatastoreService>();
    return responseDatastoreService
        .listResponses(
            userId: UserData.shared.userId,
            studyId: UserData.shared.curStudyId,
            participantId: UserData.shared.curParticipantId,
            activityStepKeyIdList: activityStepKeyIdList)
        .then((activityResponseList) {
      Map<String, List<RecordedValue>> map = {};
      if (activityResponseList is List<ActivityResponse>) {
        for (final activityStepKeyId in activityStepKeyIdList) {
          final participantStudyActivityStepId =
              '${UserData.shared.curStudyId}${activityStepKeyId.activityId}${activityStepKeyId.stepKey}${UserData.shared.curParticipantId}'
                  .hashCode;
          map['${activityStepKeyId.activityId}${activityStepKeyId.stepKey}'] =
              activityResponseList
                  .where((element) =>
                      element.participantStudyActivityStepId ==
                      participantStudyActivityStepId)
                  .map((e) => RecordedValue(
                      DateTime.parse(e.recordedAt), double.parse(e.value)))
                  .toList();
        }
        return map;
      }
      return map;
    });
  }
}
