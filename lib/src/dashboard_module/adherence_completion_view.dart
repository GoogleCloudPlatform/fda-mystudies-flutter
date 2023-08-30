import 'package:flutter/material.dart';

import 'donut_chart.dart';

class AdherenceCompletionView extends StatelessWidget {
  final int studyCompletionPercent;
  final int activitiesCompletionPercent;

  const AdherenceCompletionView(
      {required this.studyCompletionPercent,
      required this.activitiesCompletionPercent,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
        decoration:
            BoxDecoration(color: Theme.of(context).colorScheme.surfaceVariant),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: Column(children: [
              DonutChart(studyCompletionPercent.toDouble()),
              Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text('The study is $studyCompletionPercent% complete',
                      textAlign: TextAlign.center,
                      style: _statusStyle(context)))
            ])),
            VerticalDivider(
                width: 1,
                thickness: 1,
                color: Theme.of(context).scaffoldBackgroundColor),
            Expanded(
                child: Column(children: [
              DonutChart(activitiesCompletionPercent.toDouble()),
              Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                      'You completed $activitiesCompletionPercent% of activities so far',
                      textAlign: TextAlign.center,
                      style: _statusStyle(context)))
            ]))
          ],
        ));
  }

  TextStyle? _statusStyle(BuildContext context) {
    return Theme.of(context).textTheme.titleLarge?.apply(fontSizeFactor: 0.7);
  }
}
