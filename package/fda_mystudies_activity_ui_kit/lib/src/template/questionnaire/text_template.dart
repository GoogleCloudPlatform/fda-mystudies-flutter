import 'dart:io';

import 'package:fda_mystudies_spec/study_datastore_service/activity_step.pb.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

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
  _TextTemplateState createState() => _TextTemplateState();
}

class _TextTemplateState extends State<TextTemplate> {
  String? _selectedValue;
  String? _startTime;
  bool _defaultValueSet = false;
  final _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (_startTime == null) {
      setState(() {
        _startTime = QuestionnaireTemplate.currentTimeToString();
      });
    }
    if (!_defaultValueSet) {
      QuestionnaireTemplate.readSavedResult(widget.step.key).then((value) {
        if (value != null) {
          setState(() {
            _selectedValue = value;
            _defaultValueSet = true;
            _textEditingController.text = value;
          });
        }
      });
    }
    List<Widget> widgetList = [];
    if (Platform.isIOS) {
      widgetList = [
        CupertinoTextField(
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
            placeholder: widget.step.textFormat.placeholder)
      ];
    } else if (Platform.isAndroid) {
      widgetList = [
        TextField(
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
            decoration:
                InputDecoration(hintText: widget.step.textFormat.placeholder))
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
