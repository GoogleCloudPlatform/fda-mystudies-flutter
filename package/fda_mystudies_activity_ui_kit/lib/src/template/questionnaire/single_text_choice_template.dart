import 'package:fda_mystudies_spec/study_datastore_service/activity_step.pb.dart';
import 'package:flutter/material.dart';

import '../questionnaire_template.dart';

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
  String? _startTime;

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
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var textChoiceList = widget.step.textChoice.textChoices;

    List<Widget> widgetList = textChoiceList
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
