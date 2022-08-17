import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../common/widget_util.dart';

class StudyParticipationStatusView extends StatelessWidget {
  final String studyStatus;
  final String participationStatus;

  const StudyParticipationStatusView(
      {required this.studyStatus, required this.participationStatus, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final platformIsIos = (isPlatformIos(context));
    return Container(
        decoration: BoxDecoration(
            color: platformIsIos
                ? CupertinoTheme.of(context).barBackgroundColor
                : Theme.of(context).bottomAppBarColor),
        child: IntrinsicHeight(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
                child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(children: [
                      Text('STUDY STATUS',
                          textAlign: TextAlign.center,
                          style: _titleStyle(context)),
                      const SizedBox(height: 6),
                      Text(studyStatus,
                          textAlign: TextAlign.center,
                          style: _statusStyle(context))
                    ]))),
            VerticalDivider(
                width: 1,
                thickness: 1,
                color: contrastingDividerColor(context)),
            Expanded(
                child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(children: [
                      Text('PARTICIPATION STATUS',
                          textAlign: TextAlign.center,
                          style: _titleStyle(context)),
                      const SizedBox(height: 6),
                      Text(participationStatus,
                          textAlign: TextAlign.center,
                          style: _statusStyle(context))
                    ])))
          ],
        )));
  }

  TextStyle? _titleStyle(BuildContext context) {
    if (isPlatformIos(context)) {
      return CupertinoTheme.of(context)
          .textTheme
          .pickerTextStyle
          .apply(fontSizeFactor: 0.6, fontWeightDelta: 3);
    }
    return Theme.of(context)
        .textTheme
        .headline6
        ?.apply(fontSizeFactor: 0.7, fontWeightDelta: 3);
  }

  TextStyle? _statusStyle(BuildContext context) {
    if (isPlatformIos(context)) {
      return CupertinoTheme.of(context)
          .textTheme
          .pickerTextStyle
          .apply(fontSizeFactor: 0.6);
    }
    return Theme.of(context).textTheme.headline6?.apply(fontSizeFactor: 0.7);
  }
}
