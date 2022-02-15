import 'package:fda_mystudies_spec/study_datastore_service/get_study_dashboard.pbserver.dart';
import 'package:flutter/widgets.dart';

import '../../common/future_loading_page.dart';
import 'chart_tile.dart';
import 'recorded_value.dart';

class TrendsView extends StatelessWidget {
  final List<GetStudyDashboardResponse_Dashboard_Chart> chart;

  const TrendsView(this.chart, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureLoadingPage('TRENDS', _fetchRecordedValues(),
        (context, snapshot) {
      var recordedValues = snapshot.data as List<RecordedValue>;
      return SafeArea(
          child: ListView(
              padding: const EdgeInsets.all(0),
              children: chart
                  .map((e) => ChartTile(e.title, e.displayName, recordedValues))
                  .toList()));
    });
  }

  // TODO(cg2092): Replace with real data.
  Future<List<RecordedValue>> _fetchRecordedValues() {
    return Future.value([
      RecordedValue(DateTime.now().subtract(const Duration(days: 5)), '5'),
      RecordedValue(DateTime.now().subtract(const Duration(days: 4)), '1'),
      RecordedValue(DateTime.now().subtract(const Duration(days: 3)), '2'),
      RecordedValue(DateTime.now().subtract(const Duration(days: 2)), '3'),
      RecordedValue(DateTime.now().subtract(const Duration(days: 1)), '4'),
      RecordedValue(DateTime.now(), '5')
    ]);
  }
}