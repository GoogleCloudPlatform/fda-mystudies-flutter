import 'dart:io';

import 'package:fda_mystudies_spec/study_datastore_service/activity_step.pb.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../questionnaire_template.dart';

class NumericalTextTemplate extends StatefulWidget {
  final ActivityStep step;
  final bool allowExit;
  final String title;
  final Map<String, Widget> widgetMap;

  const NumericalTextTemplate(
      this.step, this.allowExit, this.title, this.widgetMap,
      {Key? key})
      : super(key: key);

  @override
  _NumericalTextTemplateState createState() => _NumericalTextTemplateState();
}

class _NumericalTextTemplateState extends State<NumericalTextTemplate> {
  dynamic _selectedValue;
  String? _startTime;

  @override
  Widget build(BuildContext context) {
    if (_startTime == null) {
      setState(() {
        _startTime = QuestionnaireTemplate.currentTimeToString();
      });
    }
    List<Widget> widgetList = [];
    if (Platform.isIOS) {
      widgetList = [
        Row(children: [
          Expanded(
              child: CupertinoTextField(
                  onChanged: (value) {
                    setState(() {
                      _selectedValue =
                          _stringToSelectedValue(widget.step, value);
                    });
                  },
                  placeholder: widget.step.numericalFormat.placeholder,
                  keyboardType: _textInputType(widget.step),
                  inputFormatters: _inputFormatters(widget.step))),
          Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
              child: Text(widget.step.numericalFormat.unit,
                  style: CupertinoTheme.of(context).textTheme.textStyle))
        ])
      ];
    } else if (Platform.isAndroid) {
      widgetList = [
        Row(children: [
          Expanded(
              child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _selectedValue =
                          _stringToSelectedValue(widget.step, value);
                    });
                  },
                  decoration: InputDecoration(
                      hintText: widget.step.numericalFormat.placeholder),
                  keyboardType: _textInputType(widget.step),
                  inputFormatters: _inputFormatters(widget.step))),
          Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
              child: Text(widget.step.numericalFormat.unit))
        ])
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

  dynamic _stringToSelectedValue(ActivityStep step, String value) {
    if (value.isEmpty) {
      return null;
    }
    if (step.hasNumericalFormat()) {
      if (step.numericalFormat.style == 'Decimal') {
        return double.parse(value);
      } else if (step.numericalFormat.style == 'Integer') {
        return int.parse(value);
      }
    }
    return null;
  }

  List<TextInputFormatter>? _inputFormatters(ActivityStep step) {
    if (step.hasNumericalFormat()) {
      if (step.numericalFormat.style == 'Decimal') {
        return [
          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,5}')),
          _NumericalTextInputFormatter(
              step.numericalFormat.minValue, step.numericalFormat.maxValue)
        ];
      } else if (step.numericalFormat.style == 'Integer') {
        return [
          FilteringTextInputFormatter.digitsOnly,
          _NumericalTextInputFormatter(
              step.numericalFormat.minValue, step.numericalFormat.maxValue)
        ];
      }
    }
    return null;
  }

  TextInputType? _textInputType(ActivityStep step) {
    if (step.hasNumericalFormat()) {
      if (step.numericalFormat.style == 'Decimal') {
        return const TextInputType.numberWithOptions(decimal: true);
      } else if (step.numericalFormat.style == 'Integer') {
        return const TextInputType.numberWithOptions(decimal: false);
      }
    }
    return null;
  }
}

class _NumericalTextInputFormatter extends TextInputFormatter {
  final double min;
  final double max;

  _NumericalTextInputFormatter(this.min, this.max) : super();

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text == '') {
      return const TextEditingValue();
    } else if (double.parse(newValue.text) > max ||
        double.parse(newValue.text) < min) {
      return oldValue;
    }
    return newValue;
  }
}
