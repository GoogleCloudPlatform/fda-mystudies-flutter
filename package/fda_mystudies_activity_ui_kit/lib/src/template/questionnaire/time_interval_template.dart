import 'dart:io';

import 'package:fda_mystudies_spec/study_datastore_service/activity_step.pb.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../questionnaire_template.dart';

class TimeIntervalTemplate extends StatefulWidget {
  final ActivityStep step;
  final bool allowExit;
  final String title;
  final Map<String, Widget> widgetMap;

  const TimeIntervalTemplate(
      this.step, this.allowExit, this.title, this.widgetMap,
      {Key? key})
      : super(key: key);

  @override
  _TimeIntervalTemplateState createState() => _TimeIntervalTemplateState();
}

class _TimeIntervalTemplateState extends State<TimeIntervalTemplate> {
  int? _selectedValue;

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    var defaultSeconds = widget.step.timeInterval.defaultValue;
    _selectedValue ??= defaultSeconds;
    var defaultHours = defaultSeconds ~/ 3600;
    var defaultMinutes = (defaultSeconds - defaultHours * 3600) ~/ 60;
    if (Platform.isIOS) {
      widgetList = [
        CupertinoTimerPicker(
            mode: CupertinoTimerPickerMode.hm,
            initialTimerDuration:
                Duration(seconds: widget.step.timeInterval.defaultValue),
            onTimerDurationChanged: (duration) {
              setState(() {
                _selectedValue = duration.inSeconds;
              });
            })
      ];
    } else if (Platform.isAndroid) {
      widgetList = [
        ElevatedButton(
            onPressed: () {
              showTimePicker(
                  helpText: 'SELECT TIME INTERVAL',
                  context: context,
                  initialTime:
                      TimeOfDay(hour: defaultHours, minute: defaultMinutes),
                  builder: (context, child) {
                    return MediaQuery(
                        data: MediaQuery.of(context)
                            .copyWith(alwaysUse24HourFormat: true),
                        child: child!);
                  }).then((value) {
                if (value != null) {
                  setState(() {
                    _selectedValue = value.hour * 3600 + value.minute * 60;
                  });
                }
              });
            },
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text('${_selectedValue!}')))
      ];
    }

    return QuestionnaireTemplate(widget.step, widget.allowExit, widget.title,
        widget.widgetMap, widgetList,
        selectedValue: _selectedValue);
  }
}
