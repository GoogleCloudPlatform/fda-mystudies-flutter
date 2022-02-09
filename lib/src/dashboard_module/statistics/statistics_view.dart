import 'package:clock/clock.dart';
import 'package:fda_mystudies_spec/study_datastore_service/get_study_dashboard.pb.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  var dayCounter = 0;
  var weekCounter = 0;
  var monthCounter = 0;

  @override
  Widget build(BuildContext context) {
    final platformIsIos = (isPlatformIos(context));
    return Container(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
        height: 230,
        decoration: BoxDecoration(
            color: platformIsIos
                ? CupertinoTheme.of(context).barBackgroundColor
                : Theme.of(context).bottomAppBarColor),
        child: Column(children: [
          const SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('STATISTICS', style: _titleStyle(context)),
            Row(
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
          ]),
          const SizedBox(height: 8),
          _divider(context),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            _iconButton(
                context,
                platformIsIos
                    ? CupertinoIcons.left_chevron
                    : Icons.arrow_left_sharp, () {
              setState(() {
                if (curMode == dayMode) {
                  dayCounter -= 1;
                } else if (curMode == weekMode) {
                  weekCounter -= 1;
                } else if (curMode == monthMode) {
                  monthCounter -= 1;
                }
              });
            }),
            Text(_timeFormat(),
                style: (platformIsIos
                    ? CupertinoTheme.of(context)
                        .textTheme
                        .textStyle
                        .apply(fontSizeFactor: 0.7)
                    : Theme.of(context).textTheme.bodyText1)),
            _iconButton(
                context,
                platformIsIos
                    ? CupertinoIcons.right_chevron
                    : Icons.arrow_right_sharp,
                _shouldDisableNextButton()
                    ? null
                    : () {
                        setState(() {
                          if (curMode == dayMode) {
                            dayCounter += 1;
                          } else if (curMode == weekMode) {
                            weekCounter += 1;
                          } else if (curMode == monthMode) {
                            monthCounter += 1;
                          }
                        });
                      })
          ]),
          _divider(context),
          const SizedBox(height: 8),
          Expanded(
              child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: widget.statistics
                      .map((e) => StatisticsTileView(e))
                      .toList()))
        ]));
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

  Widget _iconButton(
      BuildContext context, IconData icon, void Function()? onPressed) {
    if (isPlatformIos(context)) {
      return CupertinoButton(
          child: Icon(icon, size: 12),
          onPressed: onPressed == null ? null : () => onPressed());
    }
    return IconButton(
        onPressed: onPressed == null ? null : () => onPressed(),
        icon: Icon(icon, size: 16));
  }

  bool _shouldDisableNextButton() {
    if (curMode == dayMode && dayCounter == 0) {
      return true;
    }
    if (curMode == monthMode && monthCounter == 0) {
      return true;
    }
    if (curMode == weekMode && weekCounter == 0) {
      return true;
    }
    return false;
  }

  Divider _divider(BuildContext context) {
    final platformIsIos = (isPlatformIos(context));
    return Divider(
        height: 1,
        thickness: 1,
        color: (platformIsIos
            ? CupertinoTheme.of(context).scaffoldBackgroundColor
            : Theme.of(context).scaffoldBackgroundColor));
  }

  String _timeFormat() {
    var dateTime = clock.now();
    if (curMode == dayMode) {
      return DateFormat('dd, MMM yyyy')
          .format(dateTime.add(Duration(days: dayCounter)));
    } else if (curMode == weekMode) {
      var firstDayOfWeek = dateTime;
      if (dateTime.weekday != DateTime.sunday) {
        firstDayOfWeek = dateTime.add(Duration(days: dateTime.weekday));
      }
      firstDayOfWeek = firstDayOfWeek.add(Duration(days: 7 * weekCounter));
      final lastDayOfWeek = firstDayOfWeek.add(const Duration(days: 6));
      return '${DateFormat('dd, MMM yyyy').format(firstDayOfWeek)} - ${DateFormat('dd, MMM yyyy').format(lastDayOfWeek)}';
    } else if (curMode == monthMode) {
      var firstDayOfTheMonth =
          DateTime(dateTime.year, dateTime.month + monthCounter, 1);
      return DateFormat('MMM yyyy').format(firstDayOfTheMonth);
    }
    return 'UNKNOWN';
  }
}
