import 'dart:developer' as developer;

import 'package:fda_mystudies_activity_ui_kit/activity_response_processor.dart';
import 'package:fda_mystudies_spec/response_datastore_service/process_response.pb.dart';
import 'package:fda_mystudies_spec/study_datastore_service/get_eligibility_and_consent.pb.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../common/widget_util.dart';
import '../theme/fda_text_theme.dart';
import '../widget/fda_button.dart';
import '../widget/fda_scaffold.dart';
import 'pb_eligibility_step_type.dart';

class EligibilityDecision extends StatelessWidget
    implements ActivityResponseProcessor {
  final List<CorrectAnswers> correctAnswers;
  final PbEligibilityStepType stepType;
  const EligibilityDecision(this.correctAnswers, this.stepType, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FDAScaffold(
        child: SafeArea(
            child: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(height: 84),
        Text('Eligibility Confirmed',
            textAlign: TextAlign.center,
            style: FDATextTheme.headerTextStyle(context)),
        const SizedBox(height: 22),
        Text(
            stepType == PbEligibilityStepType.token
                ? 'Your eligibility to participate in this study has been successfully verified.\nYou may proceed to the next steps.'
                : 'Based on the answers you provided, you are eligible to participate in this study. You may proceed to the next steps.',
            textAlign: TextAlign.center,
            style: FDATextTheme.bodyTextStyle(context)),
        const SizedBox(height: 22),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                  color: isPlatformIos(context)
                      ? CupertinoColors.activeBlue
                      : Theme.of(context).colorScheme.primary,
                  borderRadius: const BorderRadius.all(Radius.circular(50))),
              child: const Icon(Icons.check, color: Colors.white, size: 50))
        ]),
        const SizedBox(height: 22),
        FDAButton(title: 'Continue', onPressed: () {})
      ],
    )));
  }

  @override
  Future<void> processResponses(
      List<ActivityResponse_Data_StepResult> responses) {
    developer.log('USER IS ELIGIBLE: ${_userRespondedCorrectly(responses)}');
    return Future.value();
  }

  bool _userRespondedCorrectly(
      List<ActivityResponse_Data_StepResult> userResponses) {
    Map<String, dynamic> correctAnswerMap = {};
    for (var ans in correctAnswers) {
      correctAnswerMap[ans.key] =
          (ans.hasBoolAnswer() ? ans.boolAnswer : ans.textChoiceAnswers);
    }
    for (var response in userResponses) {
      if (response.hasBoolValue()) {
        if (response.boolValue != correctAnswerMap[response.key]) {
          return false;
        }
      } else {
        if (!listEquals(response.listValues..sort(),
            (correctAnswerMap[response.key] as List<String>)..sort())) {
          return false;
        }
      }
    }
    return true;
  }
}
