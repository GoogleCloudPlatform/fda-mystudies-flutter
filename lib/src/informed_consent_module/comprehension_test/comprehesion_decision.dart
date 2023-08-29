import 'package:fda_mystudies_activity_ui_kit/activity_response_processor.dart';
import 'package:fda_mystudies_design_system/block/page_text_block.dart';
import 'package:fda_mystudies_design_system/block/page_title_block.dart';
import 'package:fda_mystudies_design_system/block/primary_button_block.dart';
import 'package:fda_mystudies_spec/response_datastore_service/process_response.pb.dart';
import 'package:fda_mystudies_spec/study_datastore_service/get_eligibility_and_consent.pb.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../route/route_name.dart';

class ComprehensionDecision extends StatelessWidget
    implements ActivityResponseProcessor {
  final GetEligibilityAndConsentResponse_Consent consent;
  final ValueNotifier<bool> userPassedComprehensionTest = ValueNotifier(false);

  ComprehensionDecision(this.consent, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var scaleFactor = MediaQuery.of(context).textScaleFactor;
    return ValueListenableBuilder(
        valueListenable: userPassedComprehensionTest,
        builder: (BuildContext context, bool testPassed, Widget? child) {
          return Scaffold(
              appBar: AppBar(),
              body: ListView(
                children: [
                  Padding(
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                      child: Row(children: [
                        Image(
                          image: AssetImage(
                              'assets/images/${testPassed ? 'check' : 'error'}.png'),
                          color: testPassed
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.error,
                          width: 60 * scaleFactor,
                          height: 60 * scaleFactor,
                        ),
                      ])),
                  PageTitleBlock(
                      title: testPassed ? 'Great job!' : 'Try again'),
                  PageTextBlock(
                      text: testPassed
                          ? 'You answered all of the questions correctly. Tap next to continue'
                          : 'You answered one or more questions wrong. We want to make sure you understand what this study is about and what is involved. Review the consent information screens and try again.',
                      textAlign: TextAlign.left),
                  const SizedBox(height: 92),
                  PrimaryButtonBlock(
                      title: testPassed ? 'Continue' : 'Try Again',
                      onPressed: () {
                        if (testPassed) {
                          if (consent.sharingScreen.title.isEmpty &&
                              consent.sharingScreen.text.isEmpty) {
                            context.pushNamed(RouteName.consentDocument);
                          } else {
                            context.pushNamed(RouteName.sharingOptions);
                          }
                        } else {
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                        }
                      })
                ],
              ));
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
