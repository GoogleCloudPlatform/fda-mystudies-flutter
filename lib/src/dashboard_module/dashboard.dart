import 'package:fda_mystudies/src/user/user_data.dart';
import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:fda_mystudies_http_client/study_datastore_service.dart';
import 'package:fda_mystudies_spec/study_datastore_service/get_study_dashboard.pbserver.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../common/future_loading_page.dart';
import 'adherence_completion_view.dart';
import 'statistics/statistics_view.dart';
import 'study_participation_status_view.dart';
import 'trends/trends_dashboard_tile.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureLoadingPage.build(context,
        scaffoldTitle: '',
        future: _fetchDashboardDetails(), builder: (context, snapshot) {
      var response = snapshot.data as GetStudyDashboardResponse;
      var statistics = response.dashboard.statistics;
      var charts = response.dashboard.charts;
      var dashboardItems = [
        const StudyParticipationStatusView(
            studyStatus: 'ACTIVE', participationStatus: 'ENROLLED'),
        AdherenceCompletionView(
            studyCompletionPercent: UserData.shared.curStudyCompletion,
            activitiesCompletionPercent: UserData.shared.curStudyAdherence),
        StatisticsView(statistics),
        TrendsDashboardTile(charts)
      ];
      return SafeArea(
          child: ListView.separated(
        itemCount: dashboardItems.length,
        itemBuilder: (context, index) => dashboardItems[index],
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
      ));
    }, wrapInScaffold: false);
  }

  Future<Object> _fetchDashboardDetails() {
    var studyDatastoreService = getIt<StudyDatastoreService>();
    return studyDatastoreService.getStudyDashboard(UserData.shared.curStudyId);
  }
}
