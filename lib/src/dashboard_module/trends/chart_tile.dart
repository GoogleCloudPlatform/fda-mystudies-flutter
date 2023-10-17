import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../dashboard_module/trends/chart_time_range.dart';
import '../../extension/datetime_extension.dart';
import 'recorded_value.dart';

class ChartTile extends StatelessWidget {
  final String chartId;

  final ChartTimeRange chartTimeRange;

  final String chartDisplayName;

  final List<RecordedValue> records;

  final barsSpace = 16.0;

  final barsWidth = 32.0;

  const ChartTile(
      this.chartId, this.chartTimeRange, this.chartDisplayName, this.records,
      {Key? key})
      : super(key: key);

  Widget bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 10);

    String text = '';

    if (value.toInt() >= 0 && value.toInt() < records.length) {
      final dateTime = records[value.toInt()].recordedAt;
      text = calculateLabel(dateTime, isStartingLabel: value.toInt() == 0);
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style),
    );
  }

  String calculateLabel(DateTime dateTime, {bool isStartingLabel = false}) {
    switch (chartTimeRange) {
      case ChartTimeRange.daysOfWeek:
        return DateFormat('E').format(dateTime);
      case ChartTimeRange.daysOfMonth:
        return isStartingLabel
            ? DateFormat('dd MMM').format(dateTime)
            : DateFormat('dd').format(dateTime);
      case ChartTimeRange.weeksOfMonth:
        var text = dateTime.weekOfMonth;
        text = (text == 'w1' ? DateFormat('MMM ').format(dateTime) : '') + text;
        return text;
      case ChartTimeRange.hoursOfDay:
        return DateFormat('HH:mm').format(dateTime);
      case ChartTimeRange.monthsOfYear:
        return isStartingLabel
            ? DateFormat('MMM, yyyy').format(dateTime)
            : DateFormat('MMM').format(dateTime);
      case ChartTimeRange.runs:
        return '';
    }
  }

  Widget leftTitles(double value, TitleMeta meta) {
    if (value == meta.max) {
      return Container();
    }

    const style = TextStyle(
      fontSize: 10,
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        meta.formattedValue,
        style: style,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    return Stack(
        children: (records.isEmpty
                    ? [
                        Padding(
                            padding: EdgeInsets.fromLTRB(
                                0, 30 * textScaleFactor, 0, 0),
                            child: SizedBox(
                                height: 200 * textScaleFactor,
                                child: const Center(
                                    child: Text('No data available!'))))
                      ]
                    : [])
                .cast<Widget>() +
            [
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).bottomAppBarTheme.color),
                    padding: const EdgeInsets.all(16),
                    child: Text(chartDisplayName, style: _titleStyle(context))),
                Container(
                    padding: const EdgeInsets.all(8),
                    width: MediaQuery.of(context).size.width - 100,
                    height: 200 * textScaleFactor,
                    child: BarChart(BarChartData(
                      alignment: BarChartAlignment.center,
                      barTouchData: BarTouchData(
                        enabled: false,
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 28,
                            getTitlesWidget: bottomTitles,
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: leftTitles,
                          ),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      gridData: const FlGridData(
                        show: true,
                      ),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      groupsSpace: barsSpace,
                      barGroups: getData(
                          context, records.map((e) => e.value).toList()),
                    ))),
                const SizedBox(height: 24)
              ])
            ].cast<Widget>());
  }

  List<BarChartGroupData> getData(BuildContext context, List<double> data) {
    List<BarChartGroupData> result = [];

    data.asMap().forEach((index, value) => result.add(BarChartGroupData(
          x: index,
          barsSpace: barsSpace,
          barRods: [
            BarChartRodData(
                toY: value,
                width: barsWidth,
                color: Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                ))
          ],
        )));

    return result;
  }

  TextStyle? _titleStyle(BuildContext context) {
    return Theme.of(context).textTheme.titleMedium;
  }
}
