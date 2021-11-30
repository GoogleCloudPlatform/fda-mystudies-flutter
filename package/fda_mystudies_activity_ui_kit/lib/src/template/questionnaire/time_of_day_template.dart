import 'dart:io';

import 'package:fda_mystudies_spec/study_datastore_service/activity_step.pb.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../questionnaire_template.dart';

class TimeOfDayTemplate extends StatefulWidget {
  final ActivityStep step;
  final bool allowExit;
  final String title;
  final Map<String, Widget> widgetMap;

  const TimeOfDayTemplate(this.step, this.allowExit, this.title, this.widgetMap,
      {Key? key})
      : super(key: key);

  @override
  _TimeOfDayTemplateState createState() => _TimeOfDayTemplateState();
}

class _TimeOfDayTemplateState extends State<TimeOfDayTemplate> {
  String? _selectedValue;

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    var time = TimeOfDay.now();
    if (_selectedValue != null) {
      time = _selectedValueToTimeOfDay(_selectedValue!);
    }
    if (Platform.isIOS) {
      widgetList = [
        CupertinoTimerPicker(
            initialTimerDuration:
                Duration(hours: time.hour, minutes: time.minute),
            mode: CupertinoTimerPickerMode.hm,
            onTimerDurationChanged: (duration) {
              setState(() {
                _selectedValue =
                    _timeToHhMm(duration.inHours, duration.inMinutes % 60);
              });
            })
      ];
    } else if (Platform.isAndroid) {
      widgetList = [
        ElevatedButton(
            onPressed: () {
              showTimePicker(
                  context: context,
                  initialTime: time,
                  builder: (context, child) {
                    return MediaQuery(
                        data: MediaQuery.of(context)
                            .copyWith(alwaysUse24HourFormat: true),
                        child: child!);
                  }).then((value) {
                if (value != null) {
                  setState(() {
                    _selectedValue = _timeToHhMm(value.hour, value.minute);
                  });
                }
              });
            },
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                    _selectedValue ?? _timeToHhMm(time.hour, time.minute))))
      ];
    }

    return QuestionnaireTemplate(widget.step, widget.allowExit, widget.title,
        widget.widgetMap, widgetList);
  }

  String _timeToHhMm(int hours, int minutes) {
    var hh = '$hours'.padLeft(2, '0');
    var mm = '$minutes'.padLeft(2, '0');
    return '$hh:$mm';
  }

  TimeOfDay _selectedValueToTimeOfDay(String hhmm) {
    var hh = hhmm.substring(0, 2);
    var mm = hhmm.substring(3, 5);
    return TimeOfDay(hour: int.parse(hh), minute: int.parse(mm));
  }
}
