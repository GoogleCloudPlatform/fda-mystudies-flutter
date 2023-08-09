import 'package:fda_mystudies_spec/study_datastore_service/activity_step.pb.dart';
import 'package:fda_mystudies_spec/study_datastore_service/get_eligibility_and_consent.pb.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../activity_builder.dart';
import '../activity_response_processor.dart';
import 'storage/local_storage_util.dart';
import 'template/questionnaire_template.dart';
import 'template/questionnaire/boolean_template.dart';
import 'template/questionnaire/date_template.dart';
import 'template/questionnaire/horizontal_scale_template.dart';
import 'template/questionnaire/horizontal_text_scale_template.dart';
import 'template/questionnaire/image_choice_template.dart';
import 'template/questionnaire/instruction_template.dart';
import 'template/questionnaire/multiple_text_choice_template.dart';
import 'template/questionnaire/numerical_text_template.dart';
import 'template/questionnaire/single_text_choice_template.dart';
import 'template/questionnaire/text_template.dart';
import 'template/questionnaire/time_interval_template.dart';
import 'template/questionnaire/time_of_day_template.dart';
import 'template/questionnaire/value_picker_template.dart';
import 'template/questionnaire/vertical_scale_template.dart';
import 'template/questionnaire/vertical_text_scale_template.dart';
import 'template/unimplemented_template.dart';

@Injectable(as: ActivityBuilder)
class ActivityBuilderImpl implements ActivityBuilder {
  static String exitRoute = '';
  static List<String> stepKeys = [];
  static String prefixUniqueActivityStepId = '';

  @override
  Widget buildActivity(
      List<ActivityStep> steps,
      ActivityResponseProcessor activityResponseProcessor,
      String uniqueActivityId,
      {bool allowExit = false,
      String? exitRouteName}) {
    prefixUniqueActivityStepId = uniqueActivityId;
    if (exitRouteName != null) {
      exitRoute = exitRouteName;
    }
    if (steps.isEmpty) {
      return activityResponseProcessor;
    }
    Map<String, Widget> widgetMap = {'': activityResponseProcessor};
    for (int i = 0; i < steps.length; ++i) {
      if (steps[i].destinations.isEmpty) {
        steps[i].destinations.add(ActivityStep_StepDestination()
          ..condition = ''
          ..destination = (i == steps.length - 1) ? '' : steps[i + 1].key
          ..operator = '');
      }
      widgetMap[steps[i].key] = _generateUIForStep(
          steps[i], widgetMap, allowExit, '${i + 1} of ${steps.length}');
    }
    stepKeys.clear();
    stepKeys.addAll(steps.map((e) => e.key).toList());
    return widgetMap[steps.first.key] ?? activityResponseProcessor;
  }

  @override
  Widget buildFailFastTest(
      {required List<ActivityStep> steps,
      required List<CorrectAnswers> answers,
      required ActivityResponseProcessor activityResponseProcessor,
      required String uniqueActivityId,
      bool allowExit = false,
      String? exitRouteName}) {
    prefixUniqueActivityStepId = uniqueActivityId;
    if (exitRouteName != null) {
      exitRoute = exitRouteName;
    }
    if (steps.isEmpty) {
      return activityResponseProcessor;
    }
    Map<String, String> answerMap = {};
    for (var answer in answers) {
      answerMap[answer.key] = '${answer.boolAnswer}';
    }
    Map<String, Widget> widgetMap = {'': activityResponseProcessor};
    for (int i = 0; i < steps.length; ++i) {
      if (steps[i].destinations.isEmpty) {
        steps[i].destinations.add(ActivityStep_StepDestination()
          ..condition = ''
          ..destination = (i == steps.length - 1) ? '' : steps[i + 1].key
          ..operator = '');
        steps[i].destinations.add(ActivityStep_StepDestination()
          ..condition = '${answerMap[steps[i].key]}'
          ..destination = ''
          ..operator = 'ne');
      }
      widgetMap[steps[i].key] = _generateUIForStep(
          steps[i], widgetMap, allowExit, '${i + 1} of ${steps.length}');
    }
    stepKeys.clear();
    stepKeys.addAll(steps.map((e) => e.key).toList());
    return widgetMap[steps.first.key] ?? activityResponseProcessor;
  }

  @override
  Widget buildRetriableTestWithSuggtestions(
      {required List<ActivityStep> steps,
      required List<CorrectAnswers> answers,
      required ActivityResponseProcessor activityResponseProcessor,
      required String uniqueActivityId,
      bool allowExit = false,
      String? exitRouteName}) {
    prefixUniqueActivityStepId = uniqueActivityId;
    if (exitRouteName != null) {
      exitRoute = exitRouteName;
    }
    if (steps.isEmpty) {
      return activityResponseProcessor;
    }
    Map<String, Widget> widgetMap = {'': activityResponseProcessor};
    for (int i = 0; i < steps.length; ++i) {
      if (steps[i].destinations.isEmpty) {
        steps[i].destinations.add(ActivityStep_StepDestination()
          ..condition = ''
          ..destination = (i == steps.length - 1) ? '' : steps[i + 1].key
          ..operator = '');
      }
      widgetMap[steps[i].key] = _generateUIForStep(
          steps[i], widgetMap, allowExit, '${i + 1} of ${steps.length}',
          answers: answers);
    }
    stepKeys.clear();
    stepKeys.addAll(steps.map((e) => e.key).toList());
    return widgetMap[steps.first.key] ?? activityResponseProcessor;
  }

  Widget _generateUIForStep(ActivityStep step, Map<String, Widget> widgetMap,
      bool allowExit, String title,
      {List<CorrectAnswers>? answers}) {
    if (step.type == 'instruction') {
      return InstructionTemplate(step, allowExit, title, widgetMap);
    } else if (step.type.toLowerCase() == 'question') {
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
        if (step.textChoice.vertical) {
          return VerticalTextScaleTemplate(step, allowExit, title, widgetMap);
        }
        return HorizontalTextScaleTemplate(step, allowExit, title, widgetMap);
      } else if (step.resultType == 'valuePicker') {
        return ValuePickerTemplate(step, allowExit, title, widgetMap);
      } else if (step.resultType == 'imageChoice') {
        return ImageChoiceTemplate(step, allowExit, title, widgetMap);
      } else if (step.resultType == 'textChoice') {
        if (step.textChoice.selectionStyle == 'Single') {
          return SingleTextChoiceTemplate(step, allowExit, title, widgetMap);
        } else if (step.textChoice.selectionStyle == 'Multiple') {
          // Comprehension tests are exclusively comprised of MutlipleTextChoice question.
          return MultipleTextChoiceTemplate(step, allowExit, title, widgetMap,
              answers: answers);
        }
      } else if (step.resultType == 'boolean') {
        return BooleanTemplate(step, allowExit, title, widgetMap);
      } else if (step.resultType == 'numeric') {
        return NumericalTextTemplate(step, allowExit, title, widgetMap);
      } else if (step.resultType == 'timeOfDay') {
        return TimeOfDayTemplate(step, allowExit, title, widgetMap);
      } else if (step.resultType == 'date') {
        return DateTemplate(step, allowExit, title, widgetMap);
      } else if (step.resultType == 'text') {
        return TextTemplate(step, allowExit, title, widgetMap);
      } else if (step.resultType == 'email') {
        step.textFormat
          ..maxLength = 320
          ..multipleLines = false;
        return TextTemplate(step, allowExit, title, widgetMap);
      } else if (step.resultType == 'timeInterval') {
        return TimeIntervalTemplate(step, allowExit, title, widgetMap);
      }
      return QuestionnaireTemplate(
          step, allowExit, title, widgetMap, const [], '');
    }
    return UnimplementedTemplate(step.key);
  }

  @override
  void quickExitFlow(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext buildContext) {
        return AlertDialog(
          content: const Text(
              'Your responses are stored on the app if you '
              '`Save for Later` (unless you sign out) so you '
              'can resume and complete the activity before it '
              'expires.'),
          actions: [
            TextButton(
                onPressed: () {
                  LocalStorageUtil.savePastResult();
                  Navigator.of(context).popUntil(
                      ModalRoute.withName(
                          ActivityBuilderImpl
                              .exitRoute));
                },
                child:
                    const Text('Save for Later')),
            TextButton(
                onPressed: () {
                  LocalStorageUtil.discardAllTemporaryResults();
                  Navigator.of(context).popUntil(
                      ModalRoute.withName(
                          ActivityBuilderImpl
                              .exitRoute));
                },
                child: const Text('Discard Results',
                    style: TextStyle(
                        color: Colors.red))),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'))
          ],
        );
      });
  }

  @override
  void makeCurrentResponsesDefaultValues() {
    LocalStorageUtil.savePastResult();
  }
}
