import 'dart:io';

import 'package:fda_mystudies_spec/study_datastore_service/activity_step.pb.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../questionnaire_template.dart';

class BooleanTemplate extends StatefulWidget {
  final ActivityStep step;
  final bool allowExit;
  final String title;
  final Map<String, Widget> widgetMap;

  const BooleanTemplate(this.step, this.allowExit, this.title, this.widgetMap,
      {Key? key})
      : super(key: key);

  @override
  _BooleanTemplateState createState() => _BooleanTemplateState();
}

class _BooleanTemplateState extends State<BooleanTemplate> {
  bool? _selectedValue;

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];

    if (Platform.isIOS) {
      widgetList = [
        CupertinoSegmentedControl(
            children: const {true: Text('Yes'), false: Text('No')},
            onValueChanged: (value) {
              setState(() {
                _selectedValue = value as bool;
              });
            },
            groupValue: _selectedValue)
      ];
    } else if (Platform.isAndroid) {
      widgetList = List<Widget>.of(['Yes', 'No'].map((e) => RadioListTile(
          title: Text(e),
          contentPadding: EdgeInsets.zero,
          value: e == "Yes",
          groupValue: _selectedValue,
          onChanged: (value) {
            setState(() {
              _selectedValue = value as bool;
            });
          })));
    }
    return QuestionnaireTemplate(widget.step, widget.allowExit, widget.title,
        widget.widgetMap, widgetList);
  }
}
