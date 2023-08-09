import 'package:fda_mystudies_spec/study_datastore_service/activity_step.pb.dart';
import 'package:flutter/material.dart';

import '../../storage/local_storage_util.dart';
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
  State<VerticalTextScaleTemplate> createState() =>
      _VerticalTextScaleTemplateState();
}

class _VerticalTextScaleTemplateState extends State<VerticalTextScaleTemplate> {
  String? _selectedValue;
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
    int? divisions = textChoiceList.length;

    List<Widget> widgetList = [];

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
                        style: Theme.of(context).textTheme.bodyLarge)))
                .toList()));
    widgetList = [
      Center(
          child: Text(textChoiceList[selectedValueIndex].text,
              style: Theme.of(context).textTheme.bodyLarge)),
      const SizedBox(height: 24),
      SizedBox(
          height: (Theme.of(context).textTheme.bodyLarge?.fontSize ?? 20) *
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

    return QuestionnaireTemplate(
        widget.step,
        widget.allowExit,
        widget.title,
        widget.widgetMap,
        widgetList,
        _startTime ?? LocalStorageUtil.currentTimeToString(),
        selectedValue: _selectedValue);
  }
}
