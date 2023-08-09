import 'package:fda_mystudies_spec/study_datastore_service/activity_step.pb.dart';
import 'package:fda_mystudies_spec/study_datastore_service/get_eligibility_and_consent.pb.dart';
import 'package:flutter/material.dart';

import '../../storage/local_storage_util.dart';
import '../questionnaire_template.dart';

class MultipleTextChoiceTemplate extends StatefulWidget {
  final ActivityStep step;
  final bool allowExit;
  final String title;
  final List<CorrectAnswers>? answers;
  final Map<String, Widget> widgetMap;

  const MultipleTextChoiceTemplate(
      this.step, this.allowExit, this.title, this.widgetMap,
      {this.answers, Key? key})
      : super(key: key);

  @override
  State<MultipleTextChoiceTemplate> createState() =>
      _MultipleTextChoiceTemplateState();
}

class _MultipleTextChoiceTemplateState
    extends State<MultipleTextChoiceTemplate> {
  List<String> _selectedValue = [];
  bool _previouslySelected = false;
  bool? _showOtherOption;
  String? _otherPlaceholder;
  final _otherController = TextEditingController();
  bool _isExclusiveSelected = false;
  String? _startTime;

  @override
  void initState() {
    super.initState();
    setState(() {
      _startTime = LocalStorageUtil.currentTimeToString();
    });
    LocalStorageUtil.readSavedResult(widget.step.key).then((value) {
      if (value != null) {
        setState(() {
          _previouslySelected = true;
          _selectedValue = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var textChoiceList = widget.step.textChoice.textChoices;

    List<Widget> widgetList = textChoiceList
        .map((e) {
          var showIndicator = false;
          var color = Colors.transparent;
          if (widget.answers != null) {
            var isCorrect = widget.answers!
                .firstWhere((element) => element.key == widget.step.key)
                .textChoiceAnswers
                .contains(e.value);
            var isSelected = _selectedValue.contains(e.value);
            var showIncorrectIndicator = isSelected && !isCorrect;
            if (_previouslySelected) {
              if (isCorrect) {
                color = Colors.green;
                showIndicator = true;
              }
              if (showIncorrectIndicator) {
                color = Colors.red;
                showIndicator = true;
              }
            }
          }
          return Container(
              margin: showIndicator ? const EdgeInsets.all(10) : null,
              padding:
                  showIndicator ? const EdgeInsets.fromLTRB(0, 5, 0, 5) : null,
              decoration: showIndicator
                  ? BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 2, color: color))
                  : null,
              child: CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text(e.text),
                  subtitle: e.detail.isNotEmpty ? Text(e.detail) : null,
                  activeColor: Theme.of(context).colorScheme.primary,
                  value: _selectedValue.contains(e.value),
                  onChanged: (value) => _updateState(e)));
        })
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
        _startTime ?? LocalStorageUtil.currentTimeToString(),
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
