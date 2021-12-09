import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:fda_mystudies_spec/study_datastore_service/activity_step.pb.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../questionnaire_template.dart';

class ImageChoiceTemplate extends StatefulWidget {
  final ActivityStep step;
  final bool allowExit;
  final String title;
  final Map<String, Widget> widgetMap;

  const ImageChoiceTemplate(
      this.step, this.allowExit, this.title, this.widgetMap,
      {Key? key})
      : super(key: key);

  @override
  _ImageChoiceTemplateState createState() => _ImageChoiceTemplateState();
}

class _ImageChoiceTemplateState extends State<ImageChoiceTemplate> {
  String _selectedText = '';
  String? _selectedValue;
  String? _startTime;
  bool _defaultValueSet = false;

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
          });
        }
      });
    }
    List<Widget> widgetList = [];

    if (Platform.isIOS) {
      widgetList = [
        Center(
            child: Text(_selectedText,
                style: CupertinoTheme.of(context).textTheme.pickerTextStyle,
                textAlign: TextAlign.center))
      ];
    } else if (Platform.isAndroid) {
      widgetList = [
        Text(_selectedText,
            style: Theme.of(context).textTheme.headline6,
            textAlign: TextAlign.center)
      ];
    }
    widgetList.add(Wrap(
      children: widget.step.imageChoice.imageChoices.map((e) {
        var isSelected = e.value == _selectedValue;
        return GestureDetector(
            onTap: () {
              setState(() {
                _selectedValue = e.value;
                _selectedText = e.text;
              });
            },
            child: ImageChoiceGridItem(e, isSelected));
      }).toList(),
    ));

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

class ImageChoiceGridItem extends StatelessWidget {
  final ImageChoiceFormat_ImageChoiceItem item;
  final bool selected;

  const ImageChoiceGridItem(this.item, this.selected, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Uint8List bytes;
    if (selected) {
      bytes = base64Decode(item.selectedImage);
    } else {
      bytes = base64Decode(item.image);
    }
    return Image.memory(bytes,
        scale: min(1, 1.0 / MediaQuery.of(context).textScaleFactor));
  }
}
