import 'package:fda_mystudies_spec/study_datastore_service/activity_step.pb.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../questionnaire_template.dart';

class DateTemplate extends StatefulWidget {
  final ActivityStep step;
  final bool allowExit;
  final String title;
  final Map<String, Widget> widgetMap;

  const DateTemplate(this.step, this.allowExit, this.title, this.widgetMap,
      {Key? key})
      : super(key: key);

  @override
  _DateTemplateState createState() => _DateTemplateState();
}

class _DateTemplateState extends State<DateTemplate> {
  String? _selectedValue;
  String? _startTime;
  String? _selectedValueLabel;

  @override
  void initState() {
    super.initState();
    setState(() {
      _startTime = QuestionnaireTemplate.currentTimeToString();
    });
  }

  @override
  Widget build(BuildContext context) {
    var time = DateTime.now();
    if (_selectedValue != null) {
      time = DateTime.parse(_selectedValue!);
    } else {
      _selectedValue = _dateTimeToString(time);
      _selectedValueLabel = _formattedDateTimeToString(time);
    }

    List<Widget> widgetList = [
      Padding(
          padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
          child: ElevatedButton(
              onPressed: () {
                showDatePicker(
                        context: context,
                        initialDate: time,
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100))
                    .then((dateTime) {
                  if (dateTime != null) {
                    setState(() {
                      _selectedValue = _dateTimeToString(dateTime);
                      _selectedValueLabel =
                          _formattedDateTimeToString(dateTime);
                    });
                    if (widget.step.dateTime.style == 'Date-Time') {
                      showTimePicker(
                              context: context,
                              initialTime: TimeOfDay(
                                  hour: time.hour, minute: time.minute))
                          .then((value) {
                        if (value != null) {
                          setState(() {
                            var updatedDateTime = DateTime(
                                dateTime.year,
                                dateTime.month,
                                dateTime.day,
                                value.hour,
                                value.minute);
                            _selectedValue = _dateTimeToString(updatedDateTime);
                            _selectedValueLabel =
                                _formattedDateTimeToString(updatedDateTime);
                          });
                        }
                      });
                    }
                  }
                });
              },
              child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(_selectedValueLabel!))))
    ];
    return QuestionnaireTemplate(
        widget.step,
        widget.allowExit,
        widget.title,
        widget.widgetMap,
        widgetList,
        _startTime ?? QuestionnaireTemplate.currentTimeToString(),
        selectedValue: _selectedValue);
  }

  String _dateTimeToString(DateTime dateTime) {
    var yyyy = '${dateTime.year}'.padLeft(4, '0');
    var mm = '${dateTime.month}'.padLeft(2, '0');
    var dd = '${dateTime.day}'.padLeft(2, '0');
    var hh = '${dateTime.hour}'.padLeft(2, '0');
    var min = '${dateTime.minute}'.padLeft(2, '0');
    var ss = '${dateTime.second}'.padLeft(2, '0');
    return '$yyyy-$mm-$dd${widget.step.dateTime.style == 'Date' ? '' : 'T$hh:$min:$ss'}';
  }

  String _formattedDateTimeToString(DateTime dateTime) {
    var dateFormat = DateFormat.yMMMMd();
    if (widget.step.dateTime.style != 'Date') {
      dateFormat.add_jm();
    }
    return dateFormat.format(dateTime);
  }
}
