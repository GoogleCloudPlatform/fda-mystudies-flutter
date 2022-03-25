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
    return FutureLoadingPage('', _fetchDashboardDetails(), (context, snapshot) {
      var response = snapshot.data as GetStudyDashboardResponse;
      var statistics = response.dashboard.statistics;
      var charts = response.dashboard.charts;
      return ListView(
        children: [
          const SizedBox(height: 8),
          const StudyParticipationStatusView(
              studyStatus: 'ACTIVE', participationStatus: 'ENROLLED'),
          const SizedBox(height: 8),
          AdherenceCompletionView(
              studyCompletionPercent: UserData.shared.curStudyCompletion,
              activitiesCompletionPercent: UserData.shared.curStudyAdherence),
          const SizedBox(height: 8),
          StatisticsView(statistics),
          const SizedBox(height: 8),
          TrendsDashboardTile(charts)
        ],
      );
    }, wrapInScaffold: false);
  }

  Future<Object> _fetchDashboardDetails() {
    var studyDatastoreService = getIt<StudyDatastoreService>();
    return studyDatastoreService.getStudyDashboard(UserData.shared.curStudyId);
  }
}
