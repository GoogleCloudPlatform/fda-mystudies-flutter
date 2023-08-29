import 'package:fda_mystudies_activity_ui_kit/activity_response_processor.dart';
import 'package:fda_mystudies_design_system/block/page_text_block.dart';
import 'package:fda_mystudies_design_system/block/page_title_block.dart';
import 'package:fda_mystudies_design_system/block/primary_button_block.dart';
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
import '../user/user_data.dart';
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
    userIsEligible.value = _userRespondedCorrectly(responses);
    return Future.value();
  }

  bool _userRespondedCorrectly(
      List<ActivityResponse_Data_StepResult> userResponses) {
    Map<String, List<dynamic>> correctAnswerMap = {};
    for (var ans in correctAnswers) {
      if (correctAnswerMap[ans.key] == null) {
        correctAnswerMap[ans.key] = [];
      }
      correctAnswerMap[ans.key]
          ?.add(ans.hasBoolAnswer() ? ans.boolAnswer : ans.textChoiceAnswers);
    }
    for (var response in userResponses) {
      if (response.hasBoolValue()) {
        if (correctAnswerMap[response.key]?.contains(response.boolValue) !=
            true) {
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
    var scaleFactor = MediaQuery.of(context).textScaleFactor;
    return ValueListenableBuilder(
        valueListenable: widget.userIsEligible,
        builder: (BuildContext context, bool eligible, Widget? child) {
          return Scaffold(
              appBar: AppBar(),
              body: ListView(
                children: [
                  Padding(
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                      child: Row(children: [
                        Image(
                          image: AssetImage(
                              'assets/images/${eligible ? 'check' : 'error'}.png'),
                          color: eligible
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.error,
                          width: 60 * scaleFactor,
                          height: 60 * scaleFactor,
                        ),
                      ])),
                  PageTitleBlock(
                      title:
                          eligible ? 'You are eligible' : 'You are ineligible'),
                  PageTextBlock(
                      text: eligible
                          ? (widget.stepType == PbEligibilityStepType.token
                              ? 'Your eligibility to participate in this study has been successfully verified. You may proceed to the next steps.'
                              : 'Based on the answers you provided, you are eligible to participate in this study. You may proceed to the next steps.')
                          : 'Sorry! Based on the answers you provided, you are not eligible to participate in this study.',
                      textAlign: TextAlign.left),
                  const SizedBox(height: 92),
                  PrimaryButtonBlock(
                      title: eligible ? 'Continue' : 'Exit',
                      onPressed: _isLoading ? null : _goToNextStep(eligible))
                ],
              ));
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
                  context.goNamed(RouteName.studyIntro);
                } else {
                  context.goNamed(RouteName.gatewayHome);
                }
              }
            });
          };
  }
}
