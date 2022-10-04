import 'dart:math';

import 'package:fda_mystudies_spec/study_datastore_service/get_study_dashboard.pb.dart';
import 'package:flutter/material.dart';

class StatisticsTileView extends StatelessWidget {
  final GetStudyDashboardResponse_Dashboard_Statistics statistic;
  final double? value;

  const StatisticsTileView(this.statistic, {this.value, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 8, 0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Theme.of(context).colorScheme.primary),
      height: _tileEdge(context),
      width: _tileEdge(context),
      child: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.waves, color: Colors.white),
          const SizedBox(height: 4),
          Text(statistic.displayName, style: _displayNameStyle(context)),
          const SizedBox(height: 4),
          Text(value == null ? 'NA' : '$value', style: _valueStyle(context)),
          const SizedBox(height: 2),
          Text(statistic.unit, style: _unitStyle(context))
        ],
      )),
    );
  }

  double _tileEdge(BuildContext context) {
    var scale = MediaQuery.of(context).textScaleFactor;
    return min(200, 130 * scale);
  }

  TextStyle? _displayNameStyle(BuildContext context) {
    return Theme.of(context)
        .textTheme
        .bodyText1
        ?.apply(fontWeightDelta: 2, color: Colors.white);
  }

  TextStyle? _valueStyle(BuildContext context) {
    return Theme.of(context)
        .textTheme
        .headline4
        ?.apply(color: Colors.white, fontWeightDelta: 2, fontSizeFactor: 0.7);
  }

  TextStyle? _unitStyle(BuildContext context) {
    return Theme.of(context)
        .textTheme
        .bodyText1
        ?.apply(fontWeightDelta: 2, color: Colors.white);
  }
}
