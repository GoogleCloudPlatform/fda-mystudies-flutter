import 'package:fda_mystudies_spec/study_datastore_service/activity_step.pb.dart';
import 'package:flutter/material.dart';

import '../../storage/local_storage_util.dart';
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
  State<HorizontalScaleTemplate> createState() =>
      _HorizontalScaleTemplateState();
}

class _HorizontalScaleTemplateState extends State<HorizontalScaleTemplate> {
  double? _selectedValue;
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
          if (value is int) {
            _selectedValue = value.toDouble();
          } else {
            _selectedValue = value;
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var defaultValue = widget.step.hasScaleFormat()
        ? widget.step.scaleFormat.defaultValue
        : widget.step.continuousScale.defaultValue;
    _selectedValue ??= defaultValue.toDouble();
    var selectedValueLabel = widget.step.hasScaleFormat()
        ? '${(_selectedValue!).toInt()}'
        : '${_selectedValue!}';
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

    List<Widget> widgetList = [
      Center(
          child: Text(selectedValueLabel,
              style: Theme.of(context).textTheme.bodyLarge)),
      Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Slider(
              value: _selectedValue ?? defaultValue.toDouble(),
              min: minValue.toDouble(),
              max: maxValue.toDouble(),
              divisions: divisions,
              onChanged: (double value) {
                setState(() {
                  _selectedValue =
                      double.parse(value.toStringAsFixed(maxFractionDigits));
                });
              })),
      Padding(
          padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(minValueLabel, style: Theme.of(context).textTheme.bodyLarge),
              Text(maxValueLabel, style: Theme.of(context).textTheme.bodyLarge)
            ],
          ))
    ];

    return QuestionnaireTemplate(
        widget.step,
        widget.allowExit,
        widget.title,
        widget.widgetMap,
        widgetList,
        _startTime ?? LocalStorageUtil.currentTimeToString(),
        selectedValue: widget.step.hasScaleFormat()
            ? _selectedValue?.toInt()
            : _selectedValue?.toDouble());
  }
}
