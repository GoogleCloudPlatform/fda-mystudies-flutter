import 'package:fda_mystudies_spec/study_datastore_service/activity_step.pb.dart';
import 'package:flutter/material.dart';

import '../../storage/local_storage_util.dart';
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
  State<TimeIntervalTemplate> createState() => _TimeIntervalTemplateState();
}

class _TimeIntervalTemplateState extends State<TimeIntervalTemplate> {
  int? _selectedValue;
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
    var defaultSeconds = widget.step.timeInterval.defaultValue;
    _selectedValue ??= defaultSeconds;
    var selectedHours = _selectedValue! ~/ 3600;
    var selectedMinutes = (_selectedValue! - selectedHours * 3600) ~/ 60;

    List<Widget> widgetList = [
      Padding(
          padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
          child: ElevatedButton(
              onPressed: () {
                showTimePicker(
                    helpText: 'SELECT TIME INTERVAL',
                    context: context,
                    initialTime:
                        TimeOfDay(hour: selectedHours, minute: selectedMinutes),
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
                  child: Text(_formattedTimeInterval(_selectedValue!)))))
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

  String _formattedTimeInterval(int seconds) {
    var duration = Duration(seconds: seconds);
    var hours = duration.inHours;
    var minutes = (seconds - hours * 3600) ~/ 60;
    return '$hours hours  $minutes min.';
  }
}
