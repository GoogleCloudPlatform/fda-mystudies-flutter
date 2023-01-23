import 'package:fda_mystudies_design_system/block/page_text_block.dart';
import 'package:fda_mystudies_design_system/block/primary_button_block.dart';
import 'package:fda_mystudies_design_system/block/text_field_block.dart';
import 'package:fda_mystudies_design_system/component/error_scenario.dart';
import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:fda_mystudies_http_client/participant_enroll_datastore_service.dart';
import 'package:fda_mystudies_spec/common_specs/common_error_response.pb.dart';
import 'package:fda_mystudies_spec/participant_enroll_datastore_service/validate_enrollment_token.pb.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../common/widget_util.dart';
import '../eligibility_module/pb_eligibility_step_type.dart';
import '../provider/eligibility_consent_provider.dart';
import '../route/route_name.dart';
import '../user/user_data.dart';

class EnrollmentToken extends StatefulWidget {
  const EnrollmentToken({Key? key}) : super(key: key);

  @override
  State<EnrollmentToken> createState() => _EnrollmentTokenState();
}

class _EnrollmentTokenState extends State<EnrollmentToken> {
  var _isLoading = false;
  var _enrollmentToken = '';
  final _enrollmentTokenTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final eligibility =
        Provider.of<EligibilityConsentProvider>(context, listen: false)
            .eligibility;
    const enrollmentTokenPlaceholder = 'Enrollment Token';

    return Scaffold(
      appBar: AppBar(title: const Text('Eligibility')),
      body: ListView(children: [
        PageTextBlock(text: eligibility.tokenTitle, textAlign: TextAlign.left),
        TextFieldBlock(
            controller: _enrollmentTokenTextController,
            placeholder: enrollmentTokenPlaceholder,
            onChanged: (value) {
              setState(() {
                _enrollmentToken = value;
              });
            },
            readOnly: _isLoading,
            maxLines: 1,
            autocorrect: false),
        const SizedBox(height: 92),
        PrimaryButtonBlock(
            title: 'Submit',
            onPressed: _isLoading
                ? null
                : _proceedToNextStep(eligibility.type.eligibilityStepType))
      ]),
    );
  }

  void Function()? _proceedToNextStep(PbEligibilityStepType type) {
    return _isLoading
        ? null
        : () {
            var alertMessage = _alertMessage();
            if (alertMessage != null) {
              showUserMessage(context, alertMessage);
              return;
            }
            setState(() {
              _isLoading = true;
            });
            ParticipantEnrollDatastoreService
                participantEnrollDatastoreService =
                getIt<ParticipantEnrollDatastoreService>();
            participantEnrollDatastoreService
                .validateEnrollmentToken(UserData.shared.userId,
                    UserData.shared.curStudyId, _enrollmentToken)
                .then((value) {
              if (value is ValidateEnrollmentTokenResponse) {
                if (type == PbEligibilityStepType.combined) {
                  context.goNamed(RouteName.eligibilityTest);
                  return;
                }
                context.goNamed(RouteName.eligibilityDecision);
              } else {
                ErrorScenario.displayErrorMessageWithOKAction(
                    context, (value as CommonErrorResponse).errorDescription);
              }
              setState(() {
                _enrollmentToken = '';
                _enrollmentTokenTextController.text = '';
                _isLoading = false;
              });
              return;
            });
          };
  }

  String? _alertMessage() {
    if (_enrollmentToken.isEmpty) {
      return 'Please enter a valid enrollment token!';
    }
    return null;
  }
}
