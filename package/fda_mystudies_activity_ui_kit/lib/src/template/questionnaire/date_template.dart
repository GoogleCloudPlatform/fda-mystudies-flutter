import 'dart:io';

import 'package:fda_mystudies_spec/study_datastore_service/activity_step.pb.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    var time = DateTime.now();
    if (_selectedValue != null) {
      time = DateTime.parse(_selectedValue!);
    } else {
      _selectedValue = _dateTimeToString(DateTime.now());
    }
    if (Platform.isIOS) {
      widgetList = [
        SizedBox(
            height: 300,
            child: CupertinoDatePicker(
                mode: widget.step.dateTime.style == 'Date'
                    ? CupertinoDatePickerMode.date
                    : CupertinoDatePickerMode.dateAndTime,
                onDateTimeChanged: (dateTime) {
                  _selectedValue = _dateTimeToString(dateTime);
                },
                initialDateTime: time))
      ];
    } else if (Platform.isAndroid) {
      widgetList = [
        ElevatedButton(
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
                  });
                  if (widget.step.dateTime.style == 'Date-Time') {
                    showTimePicker(
                            context: context,
                            initialTime:
                                TimeOfDay(hour: time.hour, minute: time.minute))
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
                        });
                      }
                    });
                  }
                }
              });
            },
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(_selectedValue ?? _dateTimeToString(time))))
      ];
    }
    return QuestionnaireTemplate(widget.step, widget.allowExit, widget.title,
        widget.widgetMap, widgetList);
  }

  String _dateTimeToString(DateTime dateTime) {
    var yyyy = '${dateTime.year}'.padLeft(4, '0');
    var mm = '${dateTime.month}'.padLeft(2, '0');
    var dd = '${dateTime.day}'.padLeft(2, '0');
    var hh = '${dateTime.hour}'.padLeft(2, '0');
    var m = '${dateTime.minute}'.padLeft(2, '0');
    var ss = '${dateTime.second}'.padLeft(2, '0');
    return '$yyyy-$mm-$dd${widget.step.dateTime.style == 'Date' ? '' : 'T$hh:$m:$ss'}';
  }
}
