import 'package:fda_mystudies_spec/study_datastore_service/activity_step.pb.dart';
import 'package:flutter/material.dart';

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

    List<Widget> widgetList = [
      DropdownButton(
        isExpanded: true,
        value: _selectedValue,
        items: textChoiceList
            .map((e) => DropdownMenuItem(
                value: e.value,
                child:
                    Text(e.text, style: Theme.of(context).textTheme.headline6)))
            .toList(),
        onChanged: (value) {
          setState(() {
            _selectedValue = '$value';
          });
        },
      )
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
}
