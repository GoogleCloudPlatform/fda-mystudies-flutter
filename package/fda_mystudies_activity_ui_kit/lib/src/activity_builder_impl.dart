import 'package:fda_mystudies_spec/study_datastore_service/activity_step.pb.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../activity_builder.dart';
import '../activity_response_processor.dart';
import 'template/questionnaire_template.dart';
import 'template/unimplemented_template.dart';

@Injectable(as: ActivityBuilder)
class ActivityBuilderImpl implements ActivityBuilder {
  @override
  Widget buildActivity(List<ActivityStep> steps, bool allowExit,
      ActivityResponseProcessor activityResponseProcessor) {
    if (steps.isEmpty) {
      return activityResponseProcessor;
    }
    Map<String, Widget> widgetMap = {'': activityResponseProcessor};
    for (int i = 0; i < steps.length; ++i) {
      if (steps[i].destinations.isEmpty) {
        steps[i].destinations.add(ActivityStep_StepDestination(
            condition: '',
            destination: (i == steps.length - 1) ? '' : steps[i + 1].key,
            operator: ''));
      }
      widgetMap[steps[i].key] = _generateUIForStep(
          steps[i], widgetMap, allowExit, 'Step ${i + 1} of ${steps.length}');
    }
    return widgetMap[steps.first.key] ?? activityResponseProcessor;
  }

  Widget _generateUIForStep(ActivityStep step, Map<String, Widget> widgetMap,
      bool allowExit, String title) {
    if (step.type == 'instruction') {
      return QuestionnaireTemplate(step, allowExit, title, widgetMap);
    } else if (step.type == 'question') {
      return QuestionnaireTemplate(step, allowExit, title, widgetMap);
      // if (step.resultType == 'scale') {
      // } else if (step.resultType == 'continuousScale') {
      // } else if (step.resultType == 'textScale') {
      // } else if (step.resultType == 'valuePicker') {
      // } else if (step.resultType == 'imageChoice') {
      // } else if (step.resultType == 'textChoice') {
      // } else if (step.resultType == 'boolean') {
      // } else if (step.resultType == 'numeric') {
      // } else if (step.resultType == 'timeOfDay') {
      // } else if (step.resultType == 'date') {
      // } else if (step.resultType == 'text') {
      // } else if (step.resultType == 'email') {
      // } else if (step.resultType == 'timeInterval') {}
    }
    return UnimplementedTemplate(step.key);
  }
}
