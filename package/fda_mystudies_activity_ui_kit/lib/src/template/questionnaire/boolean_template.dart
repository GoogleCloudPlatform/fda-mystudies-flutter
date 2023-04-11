import 'package:fda_mystudies_spec/study_datastore_service/activity_step.pb.dart';
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
    List<Widget> widgetList =
        List<Widget>.of(['Yes', 'No'].map((e) => RadioListTile(
            title: Text(e),
            value: e == "Yes",
            groupValue: _selectedValue,
            activeColor: Theme.of(context).colorScheme.primary,
            onChanged: (value) {
              setState(() {
                _selectedValue = value as bool;
              });
            })));
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
