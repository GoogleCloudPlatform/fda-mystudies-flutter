import 'package:fda_mystudies/src/dashboard_module/adherence_completion_view.dart';
import 'package:fda_mystudies/src/dashboard_module/statistics/statistics_view.dart';
import 'package:fda_mystudies/src/dashboard_module/study_participation_status_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        SizedBox(height: 8),
        StudyParticipationStatusView(
            studyStatus: 'ACTIVE', participationStatus: 'ENROLLED'),
        SizedBox(height: 8),
        AdherenceCompletionView(
            studyCompletionPercent: 3, activitiesCompletionPercent: 7),
        SizedBox(height: 8),
        StatisticsView()
      ],
    );
  }
}
