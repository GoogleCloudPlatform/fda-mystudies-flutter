import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DonutChart extends StatelessWidget {
  final double completedPercent;

  const DonutChart(this.completedPercent, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 170,
        width: 170,
        child: PieChart(PieChartData(sections: [
          PieChartSectionData(
              value: max(completedPercent, 0.1),
              title: 'completed',
              color: Theme.of(context).colorScheme.background,
              borderSide: BorderSide(
                  width: 1.0, color: Theme.of(context).colorScheme.background),
              showTitle: false),
          PieChartSectionData(
              value: 100 - max(completedPercent, 0.1),
              title: 'remaining',
              color: Theme.of(context).colorScheme.primary,
              showTitle: false)
        ], sectionsSpace: 0, centerSpaceRadius: 0, startDegreeOffset: -90)));
  }
}
