import 'dart:io';

import 'package:fda_mystudies_spec/study_datastore_service/activity_step.pb.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../questionnaire_template.dart';

class HorizontalScaleTemplate extends StatefulWidget {
  final ActivityStep step;
  final bool allowExit;
  final String title;
  final Map<String, Widget> widgetMap;

  const HorizontalScaleTemplate(
      this.step, this.allowExit, this.title, this.widgetMap,
      {Key? key})
      : super(key: key);

  @override
  _HorizontalScaleTemplateState createState() =>
      _HorizontalScaleTemplateState();
}

class _HorizontalScaleTemplateState extends State<HorizontalScaleTemplate> {
  double? _selectedValue;

  @override
  Widget build(BuildContext context) {
    var defaultValue = widget.step.hasScaleFormat()
        ? widget.step.scaleFormat.defaultValue
        : widget.step.continuousScale.defaultValue;
    var selectedValueLabel = widget.step.hasScaleFormat()
        ? '${(_selectedValue ?? defaultValue).toInt()}'
        : '${_selectedValue ?? defaultValue}';
    var maxValue = widget.step.hasScaleFormat()
        ? widget.step.scaleFormat.maxValue
        : widget.step.continuousScale.maxValue;
    var minValue = widget.step.hasScaleFormat()
        ? widget.step.scaleFormat.minValue
        : widget.step.continuousScale.minValue;
    var maxValueLabel = '$maxValue';
    var minValueLabel = '$minValue';
    var maxFractionDigits = widget.step.hasScaleFormat()
        ? 0
        : widget.step.continuousScale.maxFractionDigits;
    int? divisions = widget.step.hasScaleFormat()
        ? ((maxValue.toInt() - minValue.toInt()) ~/
            widget.step.scaleFormat.step)
        : null;
    List<Widget> widgetList = [];
    if (Platform.isIOS) {
      widgetList = [
        Center(
            child: Text(selectedValueLabel,
                style: CupertinoTheme.of(context).textTheme.pickerTextStyle)),
        CupertinoSlider(
            value: _selectedValue ?? defaultValue.toDouble(),
            min: minValue.toDouble(),
            max: maxValue.toDouble(),
            divisions: divisions,
            onChanged: (double value) {
              setState(() {
                _selectedValue =
                    double.parse(value.toStringAsFixed(maxFractionDigits));
              });
            }),
        Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(minValueLabel,
                    style:
                        CupertinoTheme.of(context).textTheme.pickerTextStyle),
                Text(maxValueLabel,
                    style: CupertinoTheme.of(context).textTheme.pickerTextStyle)
              ],
            ))
      ];
    } else if (Platform.isAndroid) {
      widgetList = [
        Center(
            child: Text(selectedValueLabel,
                style: Theme.of(context).textTheme.headline6)),
        Slider(
            value: _selectedValue ?? defaultValue.toDouble(),
            min: minValue.toDouble(),
            max: maxValue.toDouble(),
            divisions: divisions,
            onChanged: (double value) {
              setState(() {
                _selectedValue =
                    double.parse(value.toStringAsFixed(maxFractionDigits));
              });
            }),
        Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(minValueLabel,
                    style: Theme.of(context).textTheme.headline6),
                Text(maxValueLabel,
                    style: Theme.of(context).textTheme.headline6)
              ],
            ))
      ];
    }

    return QuestionnaireTemplate(widget.step, widget.allowExit, widget.title,
        widget.widgetMap, widgetList);
  }
}