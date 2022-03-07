import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:fda_mystudies_http_client/participant_enroll_datastore_service.dart';
import 'package:fda_mystudies_spec/participant_enroll_datastore_service/enroll_in_study.pb.dart';
import 'package:fda_mystudies_spec/participant_enroll_datastore_service/get_study_state.pb.dart';
import 'package:fda_mystudies_spec/participant_enroll_datastore_service/validate_enrollment_token.pb.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../common/common_test_object.dart';

void main() {
  ParticipantEnrollDatastoreService? participantEnrollDatastoreService;
  final config = DemoConfig();

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    configureDependencies(config);
    participantEnrollDatastoreService =
        getIt<ParticipantEnrollDatastoreService>();
  });

  group('get study state tests', () {
    test('test default scenario', () async {
      var response =
          await participantEnrollDatastoreService!.getStudyState('userId');

      expect(
          response,
          GetStudyStateResponse.create()
            ..message = 'SUCCESS'
            ..studies.add(GetStudyStateResponse_StudyState.create()
              ..studyId = 'test_study_id'
              ..status = 'enrolled'
              ..enrolledDate = '2021-10-31T14:40:07.000+02:00'
              ..completion = 7
              ..adherence = 10
              ..participantId = 'participant_id'
              ..hashedToken = 'hashed_token'
              ..siteId = 'test_site_id'));
    });
  });

  group('update study state tests', () {
    test('test default scenario', () async {
      var response = await participantEnrollDatastoreService!.updateStudyState(
          'userId', 'studyId', 'studyStatus', 'siteId', 'participantId');

      expect(response, CommonTestObject.commonSuccessResponse);
    });
  });

  group('withdraw from study tests', () {
    test('test default scenario', () async {
      var response = await participantEnrollDatastoreService!
          .withdrawFromStudy('userId', 'studyId', 'participantId');

      expect(response, CommonTestObject.commonSuccessResponse);
    });
  });

  group('enroll in study tests', () {
    test('test default scenario', () async {
      var response = await participantEnrollDatastoreService!
          .enrollInStudy('userId', 'enrollmentToken', 'studyId');

      expect(
          response,
          EnrollInStudyResponse()
            ..appToken = 'app_token'
            ..code = 200
            ..hashedToken = 'hashed_token'
            ..message = 'success'
            ..participantId = 'participant_id'
            ..siteId = 'site_id');
    });
  });

  group('validate enrollment token tests', () {
    test('test default scenario', () async {
      var response = await participantEnrollDatastoreService!
          .validateEnrollmentToken('userId', 'studyId', 'enrollmentToken');

      expect(
          response,
          ValidateEnrollmentTokenResponse()
            ..code = 200
            ..message = 'success'
            ..siteId = 'site_id');
    });
  });
}
