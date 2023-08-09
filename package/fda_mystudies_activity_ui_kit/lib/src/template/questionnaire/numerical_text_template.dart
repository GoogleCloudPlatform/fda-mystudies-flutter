import 'package:fda_mystudies_spec/study_datastore_service/activity_step.pb.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../storage/local_storage_util.dart';
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
  State<NumericalTextTemplate> createState() => _NumericalTextTemplateState();
}

class _NumericalTextTemplateState extends State<NumericalTextTemplate> {
  dynamic _selectedValue;
  String? _startTime;
  String? _helperText;
  final _textEditController = TextEditingController();

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
          _textEditController.text = '$value';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [
      Padding(
          padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
          child: Row(children: [
            Expanded(
                child: TextField(
                    controller: _textEditController,
                    onChanged: (value) {
                      setState(() {
                        _selectedValue =
                            _stringToSelectedValue(widget.step, value);
                        _setHelperText();
                      });
                    },
                    decoration: InputDecoration(
                        errorText: _helperText,
                        errorMaxLines: 10,
                        hintText: widget.step.numericalFormat.placeholder),
                    keyboardType: _textInputType(widget.step))),
            Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
                child: Text(widget.step.numericalFormat.unit))
          ]))
    ];

    return QuestionnaireTemplate(
        widget.step,
        widget.allowExit,
        widget.title,
        widget.widgetMap,
        widgetList,
        _startTime ?? LocalStorageUtil.currentTimeToString(),
        selectedValue: _numericValueError() == _NumericValueError.none
            ? _selectedValue
            : null);
  }

  void _setHelperText() {
    switch (_numericValueError()) {
      case _NumericValueError.none:
        _helperText = null;
        break;
      case _NumericValueError.outOfRange:
        final hasDecimalNumberFormat =
            widget.step.numericalFormat.style == 'Decimal';
        var numberFormater = NumberFormat();
        numberFormater.minimumFractionDigits = 0;
        numberFormater.maximumFractionDigits = hasDecimalNumberFormat ? 2 : 0;
        _helperText = 'Please enter a number between '
            '${numberFormater.format(widget.step.numericalFormat.minValue)} '
            'and ${numberFormater.format(widget.step.numericalFormat.maxValue)}.';
        break;
      case _NumericValueError.invalid:
        _helperText = 'Please enter a valid number';
        break;
    }
  }

  _NumericValueError _numericValueError() {
    if (_selectedValue == null) {
      return _NumericValueError.invalid;
    } else if (_selectedValue < widget.step.numericalFormat.minValue ||
        _selectedValue > widget.step.numericalFormat.maxValue) {
      return _NumericValueError.outOfRange;
    }
    return _NumericValueError.none;
  }

  dynamic _stringToSelectedValue(ActivityStep step, String value) {
    if (value.isEmpty) {
      return null;
    }
    if (step.hasNumericalFormat()) {
      if (step.numericalFormat.style == 'Decimal') {
        return double.tryParse(value.trim());
      } else if (step.numericalFormat.style == 'Integer') {
        return int.tryParse(value.trim());
      }
    }
    return null;
  }

  TextInputType? _textInputType(ActivityStep step) {
    if (step.hasNumericalFormat()) {
      final isDecimalFormat = (step.numericalFormat.style == 'Decimal');
      final isSignedFormat = (step.numericalFormat.minValue < 0);
      return TextInputType.numberWithOptions(
          decimal: isDecimalFormat, signed: isSignedFormat);
    }
    return null;
  }
}

enum _NumericValueError { none, invalid, outOfRange }

