import 'dart:io';

import 'package:fda_mystudies_spec/study_datastore_service/activity_step.pb.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../questionnaire_template.dart';
import 'cupertino_widget/cupertino_radio_list_tile.dart';

class SingleTextChoiceTemplate extends StatefulWidget {
  final ActivityStep step;
  final bool allowExit;
  final String title;
  final Map<String, Widget> widgetMap;

  const SingleTextChoiceTemplate(
      this.step, this.allowExit, this.title, this.widgetMap,
      {Key? key})
      : super(key: key);

  @override
  _SingleTextChoiceTemplateState createState() =>
      _SingleTextChoiceTemplateState();
}

class _SingleTextChoiceTemplateState extends State<SingleTextChoiceTemplate> {
  List<String>? _selectedValue;
  bool? _showOtherOption;
  String? _otherPlaceholder;
  final _otherController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                          return CupertinoRadioListTile(
                              e.text,
                              e.detail,
                              e.value,
                              _selectedValue == null
                                  ? false
                                  : e.value == _selectedValue!.first,
                              e == textChoiceList.last, onChanged: (value) {
                            setState(() {
                              _selectedValue = [value];
                              _showOtherOption = e.hasOther();
                              _otherPlaceholder =
                                  e.hasOther() ? e.other.placeholder : null;
                            });
                          });
                        })
                        .toList()
                        .cast<Widget>() +
                    (_showOtherOption == true
                        ? [
                            Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 12, 20, 24),
                                child: CupertinoTextField(
                                  controller: _otherController,
                                  placeholder: _otherPlaceholder,
                                ))
                          ]
                        : [])))
      ];
    } else if (Platform.isAndroid) {
      widgetList = textChoiceList
          .map((e) => RadioListTile(
              title: Text(e.text),
              subtitle: Text(e.detail),
              selected: _selectedValue == null
                  ? false
                  : e.value == _selectedValue!.first,
              value: e.value,
              groupValue: _selectedValue?.first,
              onChanged: (value) {
                setState(() {
                  _selectedValue = [e.value];
                  _showOtherOption = e.hasOther();
                  _otherPlaceholder = e.hasOther() ? e.other.placeholder : null;
                });
              }))
          .cast<Widget>()
          .toList();
      if (_showOtherOption == true) {
        widgetList.add(Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
            child: TextField(
              controller: _otherController,
              decoration: InputDecoration(hintText: _otherPlaceholder),
            )));
      }
    }

    return QuestionnaireTemplate(widget.step, widget.allowExit, widget.title,
        widget.widgetMap, widgetList,
        selectedValue: _selectedValue);
  }
}
