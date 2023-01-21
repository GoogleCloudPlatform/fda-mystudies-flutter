import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../common/future_loading_page.dart';
import '../../provider/dashboard_provider.dart';
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
        future: _fetchRecordedValues(), builder: (context, snapshot) {
      var recordedValues = snapshot.data as List<RecordedValue>;
      return SafeArea(
          child: ListView.builder(
              itemCount: charts.length,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) => ChartTile(charts[index].title,
                  charts[index].displayName, recordedValues)));
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
