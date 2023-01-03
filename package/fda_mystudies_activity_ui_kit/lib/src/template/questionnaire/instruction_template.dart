import 'package:fda_mystudies_design_system/block/page_html_text_block.dart';
import 'package:fda_mystudies_spec/study_datastore_service/activity_step.pb.dart';
import 'package:flutter/material.dart';

import '../questionnaire_template.dart';

class InstructionTemplate extends StatefulWidget {
  final ActivityStep step;
  final bool allowExit;
  final String title;
  final Map<String, Widget> widgetMap;

  const InstructionTemplate(
      this.step, this.allowExit, this.title, this.widgetMap,
      {Key? key})
      : super(key: key);

  @override
  _InstructionTemplateState createState() => _InstructionTemplateState();
}

class _InstructionTemplateState extends State<InstructionTemplate> {
  String? _startTime;
  double? _sizedBoxHeight;

  @override
  void initState() {
    super.initState();
    setState(() {
      _startTime = QuestionnaireTemplate.currentTimeToString();
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [
      SizedBox(
          height: _sizedBoxHeight ?? 400,
          child: PageHtmlTextBlock(text: widget.step.text))
    ];

    return QuestionnaireTemplate(
        widget.step,
        widget.allowExit,
        widget.title,
        widget.widgetMap,
        widgetList,
        _startTime ?? QuestionnaireTemplate.currentTimeToString());
  }
}
