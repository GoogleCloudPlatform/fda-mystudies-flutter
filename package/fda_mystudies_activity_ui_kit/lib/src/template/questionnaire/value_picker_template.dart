import 'dart:math';

import 'package:fda_mystudies_spec/study_datastore_service/activity_step.pb.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../config.dart';
import '../../injection/injection.dart';
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
  String? _startTime;
  final _scrollController = FixedExtentScrollController();

  @override
  void initState() {
    super.initState();
    setState(() {
      _startTime = QuestionnaireTemplate.currentTimeToString();
    });
    QuestionnaireTemplate.readSavedResult(widget.step.key).then((value) {
      if (value != null) {
        setState(() {
          _selectedValue = value;
          _scrollController.jumpToItem(widget.step.textChoice.textChoices
                  .indexWhere((element) => element.value == value) +
              1);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var textChoiceList = widget.step.textChoice.textChoices;

    List<Widget> widgetList = [];

    if (getIt<Config>().isIOS) {
      widgetList = [
        SizedBox(
            height: max(150 * MediaQuery.of(context).textScaleFactor, 150),
            child: CupertinoPicker(
                scrollController: _scrollController,
                itemExtent:
                    max(30 * MediaQuery.of(context).textScaleFactor, 30),
                onSelectedItemChanged: (value) {
                  setState(() {
                    if (value == 0) {
                      _selectedValue = null;
                    } else {
                      _selectedValue = textChoiceList[value - 1].value;
                    }
                  });
                },
                children: textChoiceList
                    .map((e) => Center(
                        child: Text(e.text,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center)))
                    .toList()
                  ..insert(
                      0,
                      const Center(
                          child: Text('Select an item',
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center)))))
      ];
    } else if (getIt<Config>().isAndroid) {
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

    return QuestionnaireTemplate(
        widget.step,
        widget.allowExit,
        widget.title,
        widget.widgetMap,
        widgetList,
        _startTime ?? QuestionnaireTemplate.currentTimeToString(),
        selectedValue: _selectedValue);
  }
}
