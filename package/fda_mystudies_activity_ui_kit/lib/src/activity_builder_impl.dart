import 'package:fda_mystudies_spec/study_datastore_service/activity_step.pb.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../activity_builder.dart';
import '../activity_response_processor.dart';
import 'template/questionnaire_template.dart';
import 'template/questionnaire/boolean_template.dart';
import 'template/questionnaire/horizontal_scale_template.dart';
import 'template/questionnaire/vertical_scale_template.dart';
import 'template/questionnaire/vertical_text_scale_template.dart';
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
      return QuestionnaireTemplate(step, allowExit, title, widgetMap, const []);
    } else if (step.type == 'question') {
      if (step.resultType == 'scale') {
        if (step.scaleFormat.vertical) {
          return VerticalScaleTemplate(step, allowExit, title, widgetMap);
        }
        return HorizontalScaleTemplate(step, allowExit, title, widgetMap);
      } else if (step.resultType == 'continuousScale') {
        if (step.continuousScale.vertical) {
          return VerticalScaleTemplate(step, allowExit, title, widgetMap);
        }
        return HorizontalScaleTemplate(step, allowExit, title, widgetMap);
      } else if (step.resultType == 'textScale') {
        // if (step.textChoice.vertical) {
        return VerticalTextScaleTemplate(step, allowExit, title, widgetMap);
        // }
        // } else if (step.resultType == 'valuePicker') {
        // } else if (step.resultType == 'imageChoice') {
        // } else if (step.resultType == 'textChoice') {
      } else if (step.resultType == 'boolean') {
        return BooleanTemplate(step, allowExit, title, widgetMap);
      }
      // else if (step.resultType == 'numeric') {
      // } else if (step.resultType == 'timeOfDay') {
      // } else if (step.resultType == 'date') {
      // } else if (step.resultType == 'text') {
      // } else if (step.resultType == 'email') {
      // } else if (step.resultType == 'timeInterval') {}
      return QuestionnaireTemplate(step, allowExit, title, widgetMap, const []);
    }
    return UnimplementedTemplate(step.key);
  }
}
