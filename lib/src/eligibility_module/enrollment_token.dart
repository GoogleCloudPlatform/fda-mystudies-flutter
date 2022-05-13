import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:fda_mystudies_http_client/participant_enroll_datastore_service.dart';
import 'package:fda_mystudies_spec/common_specs/common_error_response.pb.dart';
import 'package:fda_mystudies_spec/participant_enroll_datastore_service/validate_enrollment_token.pb.dart';
import 'package:flutter/widgets.dart';

import '../common/home_scaffold.dart';
import '../common/widget_util.dart';
import '../theme/fda_text_theme.dart';
import '../user/user_data.dart';
import '../widget/fda_button.dart';
import '../widget/fda_text_field.dart';

class EnrollmentToken extends StatefulWidget {
  final String title;
  final void Function(bool) moveToNextStep;
  const EnrollmentToken(this.title, this.moveToNextStep, {Key? key})
      : super(key: key);

  @override
  State<EnrollmentToken> createState() => _EnrollmentTokenState();
}

class _EnrollmentTokenState extends State<EnrollmentToken> {
  var _isLoading = false;
  var _enrollmentToken = '';
  final _enrollmentTokenTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const enrollmentTokenPlaceholder = 'Enrollment Token';
    return HomeScaffold(
        title: '',
        showDrawer: false,
        child: SafeArea(
            child: ListView(padding: const EdgeInsets.all(16), children: [
          const SizedBox(height: 84),
          Text('Eligibility',
              textAlign: TextAlign.center,
              style: FDATextTheme.headerTextStyle(context)),
          const SizedBox(height: 22),
          Text(widget.title, style: FDATextTheme.bodyTextStyle(context)),
          const SizedBox(height: 22),
          FDATextField(
              placeholder: enrollmentTokenPlaceholder,
              textEditingController: _enrollmentTokenTextController,
              onChanged: (value) {
                setState(() {
                  _enrollmentToken = value;
                });
              },
              readOnly: _isLoading,
              maxLines: 1,
              autocorrect: false),
          const SizedBox(height: 22),
          FDAButton(
              isLoading: _isLoading,
              title: 'Submit',
              onPressed: _proceedToNextStep())
        ])));
  }

  void Function()? _proceedToNextStep() {
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
                widget.moveToNextStep(true);
              } else {
                showUserMessage(
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
  }
}
