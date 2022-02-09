import 'package:fda_mystudies_spec/study_datastore_service/get_study_dashboard.pb.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../common/widget_util.dart';

class StatisticsTileView extends StatelessWidget {
  final GetStudyDashboardResponse_Dashboard_Statistics statistic;
  final double? value;

  const StatisticsTileView(this.statistic, {this.value, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final platformIsIos = (isPlatformIos(context));
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 8, 0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: platformIsIos
              ? CupertinoColors.activeBlue
              : Theme.of(context).colorScheme.primary),
      height: 130,
      width: 130,
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(platformIsIos ? CupertinoIcons.waveform : Icons.waves,
              color: Colors.white),
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

  TextStyle? _displayNameStyle(BuildContext context) {
    if (isPlatformIos(context)) {
      return CupertinoTheme.of(context)
          .textTheme
          .textStyle
          .apply(color: CupertinoColors.white, fontSizeFactor: 0.7);
    }
    return Theme.of(context)
        .textTheme
        .bodyText1
        ?.apply(fontWeightDelta: 2, color: Colors.white);
  }

  TextStyle? _valueStyle(BuildContext context) {
    if (isPlatformIos(context)) {
      return CupertinoTheme.of(context)
          .textTheme
          .navLargeTitleTextStyle
          .apply(color: CupertinoColors.white, fontSizeFactor: 0.7);
    }
    return Theme.of(context)
        .textTheme
        .headline4
        ?.apply(color: Colors.white, fontWeightDelta: 2, fontSizeFactor: 0.7);
  }

  TextStyle? _unitStyle(BuildContext context) {
    if (isPlatformIos(context)) {
      return CupertinoTheme.of(context)
          .textTheme
          .textStyle
          .apply(color: CupertinoColors.white, fontSizeFactor: 0.7);
    }
    return Theme.of(context)
        .textTheme
        .bodyText1
        ?.apply(fontWeightDelta: 2, color: Colors.white);
  }
}
