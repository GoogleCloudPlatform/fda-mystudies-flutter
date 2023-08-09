import 'package:fda_mystudies_spec/study_datastore_service/activity_step.pb.dart';
import 'package:flutter/material.dart';

import '../../storage/local_storage_util.dart';
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
  State<TimeOfDayTemplate> createState() => _TimeOfDayTemplateState();
}

class _TimeOfDayTemplateState extends State<TimeOfDayTemplate> {
  String? _selectedValue;
  String? _startTime;

  @override
  void initState() {
    super.initState();
    setState(() {
      _startTime = LocalStorageUtil.currentTimeToString();
    });
  }

  @override
  Widget build(BuildContext context) {
    var time = DateTime.now();
    _selectedValue ??= _timeToHhMm(time.hour, time.minute);
    time = _selectedValueToTimeOfDay(_selectedValue!);

    List<Widget> widgetList = [
      Padding(
          padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
          child: ElevatedButton(
              onPressed: () {
                showTimePicker(
                        context: context,
                        initialTime:
                            TimeOfDay(hour: time.hour, minute: time.minute))
                    .then((value) {
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
                      _selectedValue ?? _timeToHhMm(time.hour, time.minute)))))
    ];

    return QuestionnaireTemplate(
        widget.step,
        widget.allowExit,
        widget.title,
        widget.widgetMap,
        widgetList,
        _startTime ?? LocalStorageUtil.currentTimeToString(),
        selectedValue: _selectedValue);
  }

  String _timeToHhMm(int hours, int minutes) {
    var hh = '$hours'.padLeft(2, '0');
    var mm = '$minutes'.padLeft(2, '0');
    return '$hh:$mm';
  }

  DateTime _selectedValueToTimeOfDay(String hhmm) {
    var hh = hhmm.substring(0, 2);
    var mm = hhmm.substring(3, 5);
    var time = DateTime.now();
    return DateTime(
        time.year, time.month, time.day, int.parse(hh), int.parse(mm));
  }
}
