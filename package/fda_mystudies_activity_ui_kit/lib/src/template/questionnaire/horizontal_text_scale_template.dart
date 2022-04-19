import 'package:fda_mystudies_spec/study_datastore_service/activity_step.pb.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../config.dart';
import '../../injection/injection.dart';
import '../questionnaire_template.dart';

class HorizontalTextScaleTemplate extends StatefulWidget {
  final ActivityStep step;
  final bool allowExit;
  final String title;
  final Map<String, Widget> widgetMap;

  const HorizontalTextScaleTemplate(
      this.step, this.allowExit, this.title, this.widgetMap,
      {Key? key})
      : super(key: key);

  @override
  _HorizontalTextScaleTemplateState createState() =>
      _HorizontalTextScaleTemplateState();
}

class _HorizontalTextScaleTemplateState
    extends State<HorizontalTextScaleTemplate> {
  String? _selectedValue;
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
    var textChoiceList = widget.step.textChoice.textChoices;
    var defaultValue =
        textChoiceList[widget.step.textChoice.defaultValue - 1].value;
    _selectedValue ??= defaultValue;
    var selectedValueLabel = _selectedValue;
    var selectedValueIndex = textChoiceList
        .indexWhere((element) => element.value == selectedValueLabel);
    var maxValueLabel = textChoiceList.last.text;
    var minValueLabel = textChoiceList.first.text;
    int? divisions = textChoiceList.length;

    List<Widget> widgetList = [];

    if (getIt<Config>().isIOS) {
      widgetList = [
        Center(
            child: Text(textChoiceList[selectedValueIndex].text,
                style: CupertinoTheme.of(context).textTheme.pickerTextStyle)),
        CupertinoSlider(
            value: selectedValueIndex.toDouble(),
            min: 0,
            max: (textChoiceList.length - 1).toDouble(),
            divisions: divisions,
            onChanged: (double value) {
              setState(() {
                _selectedValue = textChoiceList[value.toInt()].value;
              });
            }),
        Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                      width: (MediaQuery.of(context).size.width - 120) / 2,
                      child: Text(minValueLabel,
                          maxLines: 10,
                          textAlign: TextAlign.start,
                          style: CupertinoTheme.of(context)
                              .textTheme
                              .pickerTextStyle)),
                  SizedBox(
                      width: (MediaQuery.of(context).size.width - 120) / 2,
                      child: Text(maxValueLabel,
                          maxLines: 10,
                          textAlign: TextAlign.end,
                          style: CupertinoTheme.of(context)
                              .textTheme
                              .pickerTextStyle))
                ]))
      ];
    } else if (getIt<Config>().isAndroid) {
      widgetList = [
        Center(
            child: Text(textChoiceList[selectedValueIndex].text,
                style: Theme.of(context).textTheme.headline6)),
        Slider(
            value: selectedValueIndex.toDouble(),
            min: 0,
            max: (textChoiceList.length - 1).toDouble(),
            divisions: divisions - 1,
            onChanged: (double value) {
              setState(() {
                _selectedValue = textChoiceList[value.toInt()].value;
              });
            }),
        Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                    width: (MediaQuery.of(context).size.width - 120) / 2,
                    child: Text(minValueLabel,
                        maxLines: 10,
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.headline6)),
                SizedBox(
                    width: (MediaQuery.of(context).size.width - 120) / 2,
                    child: Text(maxValueLabel,
                        maxLines: 10,
                        textAlign: TextAlign.end,
                        style: Theme.of(context).textTheme.headline6))
              ],
            ))
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
