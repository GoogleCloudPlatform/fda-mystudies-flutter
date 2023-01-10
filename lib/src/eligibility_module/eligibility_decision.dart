import 'dart:developer' as developer;

import 'package:fda_mystudies_activity_ui_kit/activity_response_processor.dart';
import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:fda_mystudies_http_client/participant_enroll_datastore_service.dart';
import 'package:fda_mystudies_spec/response_datastore_service/process_response.pb.dart';
import 'package:fda_mystudies_spec/study_datastore_service/get_eligibility_and_consent.pb.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../main.dart';
import '../route/route_name.dart';
import '../study_module/study_tile/pb_user_study_status.dart';
import '../theme/fda_text_theme.dart';
import '../user/user_data.dart';
import '../widget/fda_button.dart';
import '../widget/fda_scaffold.dart';
import 'pb_eligibility_step_type.dart';

class EligibilityDecision extends StatefulWidget
    implements ActivityResponseProcessor {
  final ValueNotifier<bool> userIsEligible = ValueNotifier(true);
  final List<CorrectAnswers> correctAnswers;
  final PbEligibilityStepType stepType;
  final GetEligibilityAndConsentResponse_Consent consent;

  EligibilityDecision(this.correctAnswers, this.stepType, this.consent,
      {Key? key})
      : super(key: key);

  @override
  State<EligibilityDecision> createState() => _EligibilityDecisionState();

  @override
  Future<void> processResponses(
      List<ActivityResponse_Data_StepResult> responses) {
    developer.log('USER IS ELIGIBLE: ${_userRespondedCorrectly(responses)}');
    userIsEligible.value = _userRespondedCorrectly(responses);
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

class _EligibilityDecisionState extends State<EligibilityDecision> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: widget.userIsEligible,
        builder: (BuildContext context, bool newValue, Widget? child) {
          return FDAScaffold(
              child: SafeArea(
                  child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const SizedBox(height: 84),
              Text(newValue ? 'Eligibility Confirmed' : 'Ineligible',
                  textAlign: TextAlign.center,
                  style: FDATextTheme.headerTextStyle(context)),
              const SizedBox(height: 22),
              Text(
                  newValue
                      ? (widget.stepType == PbEligibilityStepType.token
                          ? 'Your eligibility to participate in this study has been successfully verified.\nYou may proceed to the next steps.'
                          : 'Based on the answers you provided, you are eligible to participate in this study. You may proceed to the next steps.')
                      : 'Sorry! Based on the answers you provided, you are not eligible to participate in this study',
                  textAlign: TextAlign.center,
                  style: FDATextTheme.bodyTextStyle(context)),
              const SizedBox(height: 22),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        color: newValue
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.error,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(50))),
                    child: Icon(newValue ? Icons.check : Icons.error,
                        color: Colors.white, size: 50))
              ]),
              const SizedBox(height: 22),
              FDAButton(
                  isLoading: _isLoading,
                  title: newValue ? 'Continue' : 'Exit',
                  onPressed: _goToNextStep(
                    newValue,
                  ))
            ],
          )));
        });
  }

  void Function()? _goToNextStep(bool isUserEligible) {
    return _isLoading
        ? null
        : () {
            setState(() {
              _isLoading = true;
            });
            var participantEnrollDatastoreService =
                getIt<ParticipantEnrollDatastoreService>();
            participantEnrollDatastoreService
                .updateStudyState(
                    UserData.shared.userId, UserData.shared.curStudyId,
                    studyStatus: isUserEligible
                        ? PbUserStudyStatus.yetToEnroll.stringValue
                        : PbUserStudyStatus.notEligible.stringValue)
                .then((value) {
              setState(() {
                _isLoading = false;
              });
              if (isUserEligible) {
                context.pushNamed(RouteName.visualScreen);
              } else {
                if (curConfig.appType == AppType.standalone) {
                  context.goNamed(RouteName.standaloneHome);
                } else {
                  context.goNamed(RouteName.gatewayHome);
                }
              }
            });
          };
  }
}
