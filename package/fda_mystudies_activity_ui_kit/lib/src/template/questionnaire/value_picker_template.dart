import 'dart:io';
import 'dart:math';

import 'package:fda_mystudies_spec/study_datastore_service/activity_step.pb.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../questionnaire_template.dart';

class ValuePickerTemplate extends StatefulWidget {
  final ActivityStep step;
  final bool allowExit;
  final String title;
  final Map<String, Widget> widgetMap;

  const ValuePickerTemplate(
      this.step, this.allowExit, this.title, this.widgetMap,
      {Key? key})
      : super(key: key);

  @override
  _ValuePickerTemplateState createState() => _ValuePickerTemplateState();
}

class _ValuePickerTemplateState extends State<ValuePickerTemplate> {
  String? _selectedValue;

  @override
  Widget build(BuildContext context) {
    var textChoiceList = widget.step.textChoice.textChoices;
    List<Widget> widgetList = [];

    if (Platform.isIOS) {
      widgetList = [
        SizedBox(
            height: max(150 * MediaQuery.of(context).textScaleFactor, 150),
            child: CupertinoPicker(
                itemExtent:
                    max(30 * MediaQuery.of(context).textScaleFactor, 30),
                onSelectedItemChanged: (value) {
                  setState(() {
                    _selectedValue = textChoiceList[value].value;
                  });
                },
                children: textChoiceList
                    .map((e) => Center(
                        child: Text(e.text,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center)))
                    .toList()))
      ];
    } else if (Platform.isAndroid) {
      widgetList = [
        DropdownButton(
          isExpanded: true,
          value: _selectedValue,
          items: textChoiceList
              .map((e) => DropdownMenuItem(
                  value: e.value,
                  child: Text(e.text,
                      style: Theme.of(context).textTheme.headline6)))
              .toList(),
          onChanged: (value) {
            setState(() {
              _selectedValue = '$value';
            });
          },
        )
      ];
    }

    return QuestionnaireTemplate(widget.step, widget.allowExit, widget.title,
        widget.widgetMap, widgetList);
  }
}
