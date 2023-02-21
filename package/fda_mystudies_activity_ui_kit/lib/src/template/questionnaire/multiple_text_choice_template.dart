import 'package:fda_mystudies_spec/study_datastore_service/activity_step.pb.dart';
import 'package:flutter/material.dart';

import '../questionnaire_template.dart';

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
  List<String> _selectedValue = [];
  bool? _showOtherOption;
  String? _otherPlaceholder;
  final _otherController = TextEditingController();
  bool _isExclusiveSelected = false;
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
        .map((e) => CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            title: Text(e.text),
            subtitle: e.detail.isNotEmpty ? Text(e.detail) : null,
            activeColor: Theme.of(context).colorScheme.primary,
            value: _selectedValue.contains(e.value),
            onChanged: (value) => _updateState(e)))
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
      final otherIsSelected = _selectedValue
          .firstWhere((e) => e == "other", orElse: () => '')
          .isNotEmpty;
      _showOtherOption = otherIsSelected;
      if (e.hasOther()) {
        _otherPlaceholder = e.other.placeholder;
      }
    });
  }
}
