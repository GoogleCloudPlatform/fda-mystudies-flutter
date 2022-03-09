import 'package:fda_mystudies_activity_ui_kit/activity_response_processor.dart';
import 'package:fda_mystudies_spec/response_datastore_service/process_response.pb.dart';
import 'package:fda_mystudies_spec/study_datastore_service/get_eligibility_and_consent.pb.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../common/widget_util.dart';
import '../../theme/fda_text_theme.dart';
import '../../widget/fda_button.dart';
import '../../widget/fda_scaffold.dart';
import '../sharing_options/sharing_options.dart';

class ComprehensionDecision extends StatelessWidget
    implements ActivityResponseProcessor {
  final GetEligibilityAndConsentResponse_Consent consent;
  final ValueNotifier<bool> userPassedComprehensionTest = ValueNotifier(false);

  ComprehensionDecision(this.consent, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: userPassedComprehensionTest,
        builder: (BuildContext context, bool newValue, Widget? child) {
          return FDAScaffold(
              child: SafeArea(
                  child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const SizedBox(height: 84),
              Text(newValue ? 'Great job!' : 'Try again',
                  textAlign: TextAlign.center,
                  style: FDATextTheme.headerTextStyle(context)),
              const SizedBox(height: 22),
              Text(
                  newValue
                      ? 'You answered all of the questions correctly. Tap next to continue'
                      : 'You answered one or more questions wrong. We want to make sure you understand what this study is about and what is involved. Review the consent information screens and try again.',
                  textAlign: TextAlign.center,
                  style: FDATextTheme.bodyTextStyle(context)),
              const SizedBox(height: 22),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        color: newValue
                            ? (isPlatformIos(context)
                                ? CupertinoColors.activeBlue
                                : Theme.of(context).colorScheme.primary)
                            : (isPlatformIos(context)
                                ? CupertinoColors.destructiveRed
                                : Theme.of(context).colorScheme.error),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(50))),
                    child: Icon(newValue ? Icons.check : Icons.error,
                        color: Colors.white, size: 50))
              ]),
              const SizedBox(height: 22),
              FDAButton(
                  title: newValue ? 'Continue' : 'Try Again',
                  onPressed: () {
                    if (newValue) {
                      pushAndRemoveUntil(
                          context,
                          SharingOptions(
                              consent.sharingScreen, consent.visualScreens));
                    } else {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    }
                  })
            ],
          )));
        });
  }

  @override
  Future<void> processResponses(
      List<ActivityResponse_Data_StepResult> responses) {
    final correctAnswers = consent.comprehension.correctAnswers;
    final passScore = consent.comprehension.passScore;
    var score = 0;
    for (var userResponse in responses) {
      var matchingAnswers =
          correctAnswers.where((e) => e.key == userResponse.key);
      if (_evaluate(userResponse,
          matchingAnswers.isNotEmpty ? matchingAnswers.first : null)) {
        score += 1;
      }
    }
    userPassedComprehensionTest.value = (score >= passScore);
    return Future.value();
  }

  bool _evaluate(
      ActivityResponse_Data_StepResult userResponse, CorrectAnswers? answer) {
    if (answer == null) {
      return false;
    }
    if (answer.evaluation == "all") {
      if (userResponse.listValues.length != answer.textChoiceAnswers.length) {
        return false;
      }
      for (var value in answer.textChoiceAnswers) {
        if (!userResponse.listValues.contains(value)) {
          return false;
        }
      }
    } else {
      if (userResponse.listValues.isEmpty) {
        return false;
      }
      for (var value in userResponse.listValues) {
        if (!answer.textChoiceAnswers.contains(value)) {
          return false;
        }
      }
    }
    return true;
  }
}
