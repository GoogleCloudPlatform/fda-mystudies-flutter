import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:fda_mystudies_http_client/study_datastore_service.dart';
import 'package:fda_mystudies_spec/study_datastore_service/activity_step.pb.dart';
import 'package:fda_mystudies_spec/study_datastore_service/fetch_activity_steps.pb.dart';
import 'package:fda_mystudies_spec/study_datastore_service/get_activity_list.pb.dart';
import 'package:fda_mystudies_spec/study_datastore_service/get_consent_document.pb.dart';
import 'package:fda_mystudies_spec/study_datastore_service/get_eligibility_and_consent.pb.dart';
import 'package:fda_mystudies_spec/study_datastore_service/get_study_dashboard.pb.dart';
import 'package:fda_mystudies_spec/study_datastore_service/get_study_list.pb.dart';
import 'package:fda_mystudies_spec/study_datastore_service/study_info.pb.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../common/common_test_object.dart';

void main() {
  StudyDatastoreService? studyDatastoreService;
  final config = DemoConfig();

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    configureDependencies(config);
    FlutterSecureStorage.setMockInitialValues({});
    studyDatastoreService = getIt<StudyDatastoreService>();
  });

  group('get version info tests', () {
    test('test default scenario', () async {
      var response = await studyDatastoreService!.getVersionInfo('userId');
      expect(response, CommonTestObject.commonSuccessResponse);
    });
  });

  group('get study list tests', () {
    test('test default scenario', () async {
      var response = await studyDatastoreService!.getStudyList('userId');
      expect(
          response,
          GetStudyListResponse()
            ..message = 'success'
            ..studies.add(GetStudyListResponse_Study()
              ..category = 'test'
              ..logo = 'test_logo_url'
              ..sponsorName = 'test_org'
              ..settings = (GetStudyListResponse_Study_StudySettings()
                ..enrolling = true
                ..platform = 'all')
              ..status = 'Active'
              ..studyId = 'fda-mystudies'
              ..studyVersion = '1.0'
              ..tagLine = 'Demo study to test the app'
              ..title = 'Sample Study'));
    });
  });

  group('fetch activity steps tests', () {
    test('test default scenario', () async {
      var response = await studyDatastoreService!
          .fetchActivitySteps('study_id', 'default', '1.0', 'userId');

      expect(
          response,
          FetchActivityStepsResponse()
            ..message = 'SUCCESS'
            ..activity =
                (FetchActivityStepsResponse_ActivityWithMetadataAndSteps()
                  ..type = 'questionnaire'
                  ..metadata =
                      (FetchActivityStepsResponse_ActivityWithMetadataAndSteps_ActivityMetadata()
                        ..studyId = 'demo-study'
                        ..activityId = 'test-activity'
                        ..name = 'Test Activity'
                        ..version = '1.1'
                        ..lastModified = '2021-05-06T10:23:29.000+0000'
                        ..startDate = '2021-05-06T07:00:00.000+0000'
                        ..endDate = '2024-01-29T23:59:59.000+0000')
                  ..steps.add(ActivityStep()
                    ..type = 'question'
                    ..resultType = 'scale'
                    ..key = 'vertical-scale'
                    ..title = 'Vertical Scale'
                    ..text = ''
                    ..skippable = true
                    ..groupName = ''
                    ..repeatable = false
                    ..repeatableText = ''
                    ..destinations.add(ActivityStep_StepDestination()
                      ..condition = ''
                      ..operator = ''
                      ..destination = '')
                    ..healthDataKey = ''
                    ..scaleFormat = (ScaleFormat()
                      ..maxValue = 5
                      ..minValue = 0
                      ..step = 1
                      ..defaultValue = 0
                      ..vertical = true
                      ..minDesc = ''
                      ..minImage = ''
                      ..maxDesc = ''
                      ..maxImage = ''))));
    });
  });

  group('get activity list tests', () {
    test('test default scenario', () async {
      var response =
          await studyDatastoreService!.getActivityList('studyId', 'userId');

      expect(
          response,
          GetActivityListResponse()
            ..message = 'SUCCESS'
            ..activities.addAll([
              GetActivityListResponse_Activity()
                ..activityId = 'ui-test'
                ..activityVersion = '1.1'
                ..title = 'Questionnaire to test all the UI Elements'
                ..type = 'questionnaire'
                ..startTime = '2021-05-06T07:00:00.000+0000'
                ..endTime = '2024-01-29T23:59:59.000+0000'
                ..branching = false
                ..isLaunchStudy = false
                ..isStudyLifeTime = false
                ..lastModified = '2021-05-06T10:23:29.000+0000'
                ..state = 'active'
                ..taskSubType = ''
                ..schedulingType = 'Regular'
                ..frequency = (GetActivityListResponse_Activity_Frequency()
                  ..type = 'Daily'
                  ..runs.add(
                      GetActivityListResponse_Activity_Frequency_FrequencyRuns()
                        ..startTime = '07:00:00'
                        ..endTime = '23:59:59')),
              GetActivityListResponse_Activity()
                ..activityId = 'default'
                ..activityVersion = '1.2'
                ..title = 'Study Tasks'
                ..type = 'questionnaire'
                ..startTime = '2021-04-06T00:00:00.000+0000'
                ..endTime = ''
                ..branching = true
                ..isLaunchStudy = true
                ..isStudyLifeTime = true
                ..lastModified = '2021-04-09T10:35:06.000+0000'
                ..state = 'active'
                ..taskSubType = ''
                ..schedulingType = 'Regular'
                ..frequency = (GetActivityListResponse_Activity_Frequency()
                  ..type = 'One time'),
            ]));
    });
  });

  group('get consent document tests', () {
    test('test default scenario', () async {
      var response =
          await studyDatastoreService!.getConsentDocument('studyId', 'userId');

      expect(
          response,
          GetConsentDocumentResponse()
            ..message = 'SUCCESS'
            ..consent = (GetConsentDocumentResponse_ConsentDocument()
              ..version = '1.1'
              ..type = 'text/html'
              ..content = '<span>Sample Consent Form</span>'));
    });
  });

  group('get eligibility and consent tests', () {
    test('test default scenario', () async {
      var response = await studyDatastoreService!
          .getEligibilityAndConsent('studyId', 'userId');

      expect(
          response,
          GetEligibilityAndConsentResponse()
            ..message = 'SUCCESS'
            ..eligibility = (GetEligibilityAndConsentResponse_Eligibility()
              ..type = 'combined'
              ..tokenTitle =
                  'Participating in this study requires an invitation. If you have received one, please enter the token provided.'
              ..tests.add(ActivityStep()
                ..type = 'Question'
                ..resultType = 'boolean'
                ..key = 'age'
                ..title = 'Are you 18 years or older?'
                ..text =
                    'Answer these questions to determine your eligibility for the study'
                ..skippable = false
                ..repeatable = false)
              ..correctAnswers.add(CorrectAnswers()
                ..key = 'age'
                ..boolAnswer = true))
            ..consent = (GetEligibilityAndConsentResponse_Consent()
              ..version = '1.1'
              ..visualScreens
                  .add(GetEligibilityAndConsentResponse_Consent_VisualScreen()
                    ..type = 'overview'
                    ..title =
                        'Review this information and consent to participate in this study'
                    ..text =
                        'This consent form gives you important information about a research study.'
                    ..html =
                        'We are asking you to participate in this research study. Participation in this research study is voluntary.'
                    ..visualStep = true)
              ..sharingScreen =
                  (GetEligibilityAndConsentResponse_Consent_SharingScreen()
                    ..title = 'Sharing Options'
                    ..text =
                        'The host and its partners will receive your study data from participation in this study. Sharing your coded data more broadly (without information such as your name) may benefit this and future research.'
                    ..shortDesc =
                        'Only Share my data with the host and partners'
                    ..longDesc =
                        'Share my data with the host and qualified researchers worldwide.'
                    ..learnMore = ''
                    ..allowWithoutSharing = false)
              ..comprehension =
                  (GetEligibilityAndConsentResponse_Consent_Comprehension()
                    ..passScore = 1
                    ..questions.add(ActivityStep()
                      ..type = 'Question'
                      ..resultType = 'textChoice'
                      ..key = '123'
                      ..title =
                          'I can choose not to participate in the study at any time.'
                      ..text =
                          'Take this comprehension test to assess your understanding of the study'
                      ..skippable = false
                      ..repeatable = false
                      ..textChoice = (TextChoiceFormat()
                        ..textChoices.addAll([
                          (TextChoiceFormat_TextChoice()
                            ..text = 'Yes'
                            ..value = 'Yes'
                            ..exclusive = false),
                          (TextChoiceFormat_TextChoice()
                            ..text = 'No'
                            ..value = 'No'
                            ..exclusive = false)
                        ])
                        ..selectionStyle = 'Multiple'))
                    ..correctAnswers.add(CorrectAnswers()
                      ..key = '123'
                      ..evaluation = 'all'
                      ..textChoiceAnswers.add("Yes")))));
    });
  });

  group('get study dashboard tests', () {
    test('test default scenario', () async {
      var response = await studyDatastoreService!.getStudyDashboard('studyId');

      expect(
          response,
          GetStudyDashboardResponse()
            ..message = 'SUCCESS'
            ..dashboard = (GetStudyDashboardResponse_Dashboard()
              ..statistics.add(GetStudyDashboardResponse_Dashboard_Statistics()
                ..title = 'Step-Count'
                ..displayName = 'Step Count'
                ..statType = 'Activity'
                ..unit = 'steps'
                ..calculation = 'Average'
                ..dataSource = (DataSource()
                  ..type = 'questionnaire'
                  ..key = 'step-count'
                  ..activity = (DataSource_Activity()
                    ..activityId = 'ui-test'
                    ..version = '1.1')))
              ..charts.add(GetStudyDashboardResponse_Dashboard_Chart()
                ..title = 'leg-pain'
                ..displayName = 'Leg Pain'
                ..type = 'line-chart'
                ..scrollable = false
                ..dataSource = (DataSource()
                  ..type = 'questionnaire'
                  ..key = 'leg-pain'
                  ..activity = (DataSource_Activity()
                    ..activityId = 'ui-test'
                    ..version = '1.1')
                  ..timeRangeType = 'days_of_week'))));
    });
  });

  group('get study info tests', () {
    test('test default scenario', () async {
      var response =
          await studyDatastoreService!.getStudyInfo('studyId', 'userId');

      expect(
          response,
          StudyInfoResponse()
            ..message = 'SUCCESS'
            ..infos.add(StudyInfoResponse_StudyInfoItem()
              ..type = 'image'
              ..image =
                  'https://images.unsplash.com/photo-1529310399831-ed472b81d589?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=774&q=80'
              ..title = 'FDA MyStudies'
              ..text =
                  'The FDA MyStudies platform enables you to quickly build and deploy studies that interact with participants through apps on iOS and Android.'));
    });
  });
}
