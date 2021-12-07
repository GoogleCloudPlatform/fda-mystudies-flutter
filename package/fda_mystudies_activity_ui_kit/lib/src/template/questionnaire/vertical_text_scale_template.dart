import 'dart:io';

import 'package:fda_mystudies_spec/study_datastore_service/activity_step.pb.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../questionnaire_template.dart';

class VerticalTextScaleTemplate extends StatefulWidget {
  final ActivityStep step;
  final bool allowExit;
  final String title;
  final Map<String, Widget> widgetMap;

  const VerticalTextScaleTemplate(
      this.step, this.allowExit, this.title, this.widgetMap,
      {Key? key})
      : super(key: key);

  @override
  _VerticalTextScaleTemplateState createState() =>
      _VerticalTextScaleTemplateState();
}

class _VerticalTextScaleTemplateState extends State<VerticalTextScaleTemplate> {
  String? _selectedValue;
  String? _startTime;

  @override
  Widget build(BuildContext context) {
    if (_startTime == null) {
      setState(() {
        _startTime = QuestionnaireTemplate.currentTimeToString();
      });
    }
    var textChoiceList = widget.step.textChoice.textChoices;
    var defaultValue =
        textChoiceList[widget.step.textChoice.defaultValue - 1].value;
    _selectedValue ??= defaultValue;
    var selectedValueLabel = _selectedValue;
    var selectedValueIndex = textChoiceList
        .indexWhere((element) => element.value == selectedValueLabel);

    int? divisions = textChoiceList.length;
    List<Widget> widgetList = [];
    if (Platform.isIOS) {
      var labelList = Padding(
          padding: const EdgeInsets.fromLTRB(12, 4, 0, 12),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: textChoiceList.reversed
                  .map((e) => SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(e.text,
                          textAlign: TextAlign.left,
                          maxLines: 2,
                          style: CupertinoTheme.of(context)
                              .textTheme
                              .pickerTextStyle)))
                  .toList()));

      widgetList = [
        Center(
            child: Text(textChoiceList[selectedValueIndex].text,
                style: CupertinoTheme.of(context).textTheme.pickerTextStyle)),
        const SizedBox(height: 24),
        SizedBox(
            height: (CupertinoTheme.of(context)
                        .textTheme
                        .pickerTextStyle
                        .fontSize ??
                    20.0) *
                3 *
                divisions *
                MediaQuery.of(context).textScaleFactor,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                      width: 80,
                      child: RotatedBox(
                          quarterTurns: 3,
                          child: CupertinoSlider(
                              value: selectedValueIndex.toDouble(),
                              min: 0,
                              max: (textChoiceList.length - 1).toDouble(),
                              divisions: divisions,
                              onChanged: (double value) {
                                setState(() {
                                  _selectedValue =
                                      textChoiceList[value.toInt()].value;
                                });
                              }))),
                  Expanded(child: labelList)
                ]))
      ];
    } else if (Platform.isAndroid) {
      var labelList = Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 0, 18),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: textChoiceList.reversed
                  .map((e) => SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(e.text,
                          textAlign: TextAlign.left,
                          style: Theme.of(context).textTheme.headline6)))
                  .toList()));
      widgetList = [
        Center(
            child: Text(textChoiceList[selectedValueIndex].text,
                style: Theme.of(context).textTheme.headline6)),
        const SizedBox(height: 24),
        SizedBox(
            height: (Theme.of(context).textTheme.headline6?.fontSize ?? 20) *
                3 *
                divisions *
                MediaQuery.of(context).textScaleFactor,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                      width: 80,
                      child: RotatedBox(
                          quarterTurns: 3,
                          child: Slider(
                              value: selectedValueIndex.toDouble(),
                              min: 0,
                              max: (textChoiceList.length - 1).toDouble(),
                              divisions: divisions - 1,
                              onChanged: (double value) {
                                setState(() {
                                  _selectedValue =
                                      textChoiceList[value.toInt()].value;
                                });
                              }))),
                  Expanded(child: labelList)
                ]))
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
