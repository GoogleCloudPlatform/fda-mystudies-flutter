import 'package:fda_mystudies_spec/study_datastore_service/activity_step.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../storage/local_storage_util.dart';
import '../questionnaire_template.dart';

class TextTemplate extends StatefulWidget {
  final ActivityStep step;
  final bool allowExit;
  final String title;
  final Map<String, Widget> widgetMap;

  const TextTemplate(this.step, this.allowExit, this.title, this.widgetMap,
      {Key? key})
      : super(key: key);

  @override
  State<TextTemplate> createState() => _TextTemplateState();
}

class _TextTemplateState extends State<TextTemplate> {
  String? _selectedValue;
  String? _startTime;
  final _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      _startTime = LocalStorageUtil.currentTimeToString();
    });
    LocalStorageUtil.readSavedResult(widget.step.key).then((value) {
      if (value != null) {
        setState(() {
          _selectedValue = value;
          _textEditingController.text = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [
      Padding(
          padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
          child: TextField(
              controller: _textEditingController,
              onChanged: (value) {
                setState(() {
                  _selectedValue = value;
                });
              },
              maxLength: widget.step.textFormat.maxLength,
              keyboardType: widget.step.textFormat.multipleLines
                  ? TextInputType.multiline
                  : TextInputType.text,
              maxLines: widget.step.textFormat.multipleLines ? null : 1,
              inputFormatters: _inputFormatters(widget.step),
              decoration: InputDecoration(
                  hintText: widget.step.textFormat.placeholder)))
    ];

    return QuestionnaireTemplate(
        widget.step,
        widget.allowExit,
        widget.title,
        widget.widgetMap,
        widgetList,
        _startTime ?? LocalStorageUtil.currentTimeToString(),
        selectedValue: _selectedValue);
  }

  List<TextInputFormatter>? _inputFormatters(ActivityStep step) {
    if (step.textFormat.validationRegex.isNotEmpty) {
      return [
        FilteringTextInputFormatter.allow(RegExp(
            step.textFormat.validationRegex,
            multiLine: step.textFormat.multipleLines))
      ];
    }
    return null;
  }
}
