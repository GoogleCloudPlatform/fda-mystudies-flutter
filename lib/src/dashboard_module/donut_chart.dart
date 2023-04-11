import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/widgets.dart';

class DonutChart extends StatelessWidget {
  final double completedPercent;

  const DonutChart(this.completedPercent, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 170,
        width: 170,
        child: charts.PieChart(_createData(), animate: false));
  }

  List<charts.Series<GaugeSegment, String>> _createData() {
    final data = [
      GaugeSegment('completed', completedPercent),
      GaugeSegment('remaining', 100 - completedPercent)
    ];

    return [
      charts.Series<GaugeSegment, String>(
        id: 'segments',
        domainFn: (GaugeSegment segment, _) => segment.segment,
        measureFn: (GaugeSegment segment, _) => segment.size,
        data: data,
      )
    ];
  }
}

class GaugeSegment {
  final String segment;
  final double size;

  GaugeSegment(this.segment, this.size);
}
