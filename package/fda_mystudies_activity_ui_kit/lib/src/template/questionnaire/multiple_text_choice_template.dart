import 'dart:io';

import 'package:fda_mystudies_spec/study_datastore_service/activity_step.pb.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../questionnaire_template.dart';
import 'cupertino_widget/cupertino_checkbox_list_tile.dart';

class MultipleTextChoiceTemplate extends StatefulWidget {
  final ActivityStep step;
  final bool allowExit;
  final String title;
  final Map<String, Widget> widgetMap;

  const MultipleTextChoiceTemplate(
      this.step, this.allowExit, this.title, this.widgetMap,
      {Key? key})
      : super(key: key);

  @override
  _MultipleTextChoiceTemplateState createState() =>
      _MultipleTextChoiceTemplateState();
}

class _MultipleTextChoiceTemplateState
    extends State<MultipleTextChoiceTemplate> {
  final List<String> _selectedValue = [];
  bool _isExclusiveSelected = false;
  String? _startTime;

  @override
  Widget build(BuildContext context) {
    if (_startTime == null) {
      setState(() {
        _startTime = QuestionnaireTemplate.currentTimeToString();
      });
    }
    var textChoiceList = widget.step.textChoice.textChoices;
    List<Widget> widgetList = [];

    if (Platform.isIOS) {
      widgetList = [
        Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                border: Border.all(color: CupertinoColors.inactiveGray),
                borderRadius: BorderRadius.circular(5)),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: textChoiceList
                    .map((e) {
                      return CupertinoCheckboxListTile(
                          e.text,
                          e.detail,
                          e.value,
                          _selectedValue.contains(e.value),
                          e == textChoiceList.last,
                          onChanged: (value) => _updateState(e));
                    })
                    .toList()
                    .cast<Widget>()))
      ];
    } else if (Platform.isAndroid) {
      widgetList = textChoiceList
          .map((e) => CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(e.text),
              subtitle: Text(e.detail),
              value: _selectedValue.contains(e.value),
              onChanged: (value) => _updateState(e)))
          .cast<Widget>()
          .toList();
    }

    return QuestionnaireTemplate(
        widget.step,
        widget.allowExit,
        widget.title,
        widget.widgetMap,
        widgetList,
        _startTime ?? QuestionnaireTemplate.currentTimeToString(),
        selectedValue: (_selectedValue.isEmpty ? null : _selectedValue));
  }

  void _updateState(TextChoiceFormat_TextChoice e) {
    setState(() {
      if (_selectedValue.contains(e.value)) {
        if (e.exclusive) {
          _isExclusiveSelected = false;
        }
        _selectedValue.remove(e.value);
      } else {
        if (e.exclusive) {
          _selectedValue.clear();
          _isExclusiveSelected = true;
        } else if (_isExclusiveSelected) {
          _selectedValue.clear();
          _isExclusiveSelected = false;
        }
        _selectedValue.add(e.value);
      }
    });
  }
}
