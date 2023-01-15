import 'dart:math';

import 'package:clock/clock.dart';
import 'package:fda_mystudies_spec/study_datastore_service/get_study_dashboard.pb.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../common/widget_util.dart';
import 'statistics_tile_view.dart';
import 'time_mode_button.dart';

class StatisticsView extends StatefulWidget {
  final List<GetStudyDashboardResponse_Dashboard_Statistics> statistics;

  const StatisticsView(this.statistics, {Key? key}) : super(key: key);

  @override
  _StatisticsViewState createState() => _StatisticsViewState();
}

class _StatisticsViewState extends State<StatisticsView> {
  static const dayMode = 'DAY';
  static const weekMode = 'WEEK';
  static const monthMode = 'MONTH';
  var curMode = dayMode;
  var modeToCounterMap = {dayMode: 0, weekMode: 0, monthMode: 0};

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
        height: _containerHeight(context),
        decoration:
            BoxDecoration(color: Theme.of(context).colorScheme.surfaceVariant),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const SizedBox(height: 8),
          SizedBox(
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('STATISTICS',
                            textAlign: TextAlign.left,
                            style: _titleStyle(context)),
                        const SizedBox(width: 32),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [dayMode, weekMode, monthMode]
                                .map((e) => TimeModeButton(
                                    mode: e,
                                    isActive: e == curMode,
                                    onPressed: () {
                                      if (curMode != e) {
                                        setState(() {
                                          curMode = e;
                                        });
                                      }
                                    }))
                                .toList())
                      ]))),
          const SizedBox(height: 8),
          _divider(context),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            _iconButton(context, Icons.arrow_left_sharp, () {
              setState(() {
                modeToCounterMap[curMode] =
                    (modeToCounterMap[curMode] ?? 0) - 1;
              });
            }),
            Expanded(
                child: Text(_timeFormat(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText1)),
            _iconButton(
                context,
                Icons.arrow_right_sharp,
                _shouldDisableNextButton()
                    ? null
                    : () {
                        setState(() {
                          modeToCounterMap[curMode] =
                              (modeToCounterMap[curMode] ?? 0) + 1;
                        });
                      })
          ]),
          _divider(context),
          const SizedBox(height: 8),
          Expanded(
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.statistics.length,
                  itemBuilder: (context, index) =>
                      StatisticsTileView(widget.statistics[index])))
        ]));
  }

  double _containerHeight(BuildContext context) {
    var scale = MediaQuery.of(context).textScaleFactor;
    return min(500, 230 * scale);
  }

  TextStyle? _titleStyle(BuildContext context) {
    return Theme.of(context)
        .textTheme
        .headline6
        ?.apply(fontSizeFactor: 0.7, fontWeightDelta: 3);
  }

  Widget _iconButton(
      BuildContext context, IconData icon, void Function()? onPressed) {
    return IconButton(
        onPressed: onPressed == null ? null : () => onPressed(),
        icon: Icon(icon, size: 16));
  }

  bool _shouldDisableNextButton() {
    return modeToCounterMap[curMode] == 0;
  }

  Divider _divider(BuildContext context) {
    return Divider(
        height: 1, thickness: 1, color: contrastingDividerColor(context));
  }

  String _timeFormat() {
    var dateTime = clock.now();
    var curModeCounter = modeToCounterMap[curMode] ?? 0;
    if (curMode == dayMode) {
      return DateFormat('dd, MMM yyyy')
          .format(dateTime.add(Duration(days: curModeCounter)));
    } else if (curMode == weekMode) {
      var firstDayOfWeek = dateTime;
      if (dateTime.weekday != DateTime.sunday) {
        firstDayOfWeek = dateTime.subtract(Duration(days: dateTime.weekday));
      }
      firstDayOfWeek = firstDayOfWeek.add(Duration(days: 7 * curModeCounter));
      final lastDayOfWeek = firstDayOfWeek.add(const Duration(days: 6));
      return '${DateFormat('dd, MMM yyyy').format(firstDayOfWeek)} - ${DateFormat('dd, MMM yyyy').format(lastDayOfWeek)}';
    } else if (curMode == monthMode) {
      var firstDayOfTheMonth =
          DateTime(dateTime.year, dateTime.month + curModeCounter, 1);
      return DateFormat('MMM yyyy').format(firstDayOfTheMonth);
    }
    return 'UNKNOWN';
  }
}
