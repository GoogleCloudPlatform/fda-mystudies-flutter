import 'package:fda_mystudies_http_client/injection/injection.dart';
import 'package:fda_mystudies_http_client/mock/demo_config.dart';
import 'package:fda_mystudies_http_client/service/study_datastore_service/study_datastore_service.dart';
import 'package:fda_mystudies_spec/common_specs/common_response.pb.dart';
import 'package:fda_mystudies_spec/study_datastore_service/activity_step.pb.dart';
import 'package:fda_mystudies_spec/study_datastore_service/fetch_activity_steps.pb.dart';
import 'package:fda_mystudies_spec/study_datastore_service/get_activity_list.pb.dart';
import 'package:fda_mystudies_spec/study_datastore_service/get_study_list.pb.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  StudyDatastoreService? studyDatastoreService;
  final config = DemoConfig();

  setUpAll(() {
    configureDependencies(config);
    studyDatastoreService = getIt<StudyDatastoreService>();
  });

  group('get version info tests', () {
    test('test default scenario', () async {
      var response = await studyDatastoreService!.getVersionInfo('userId');
      expect(
          response,
          CommonResponse.create()
            ..code = 200
            ..message = 'success');
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
              ..status = 'enrolling'
              ..studyId = 'test_study_id'
              ..studyVersion = '1.0'
              ..tagLine = 'Demo study to test the app'
              ..title = 'Sample Study'));
    });
  });

  group('fetch activity steps tests', () {
    test('test default scenario', () async {
      var response = await studyDatastoreService!
          .fetchActivitySteps('study_id', 'activity_id', '1.0', 'userId');

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
                      ..destination = 'horizontal-scale')
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
            ..activities.add(GetActivityListResponse_Activity()
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
                      ..endTime = '23:59:59'))));
    });
  });

  group('get consent document tests', () {
    test('test default scenario', () {});
  });

  group('get eligibility and consent tests', () {
    test('test default scenario', () {});
  });

  group('get study dashboard tests', () {
    test('test default scenario', () {});
  });

  group('get study info tests', () {
    test('test default scenario', () {});
  });
}
