import 'package:fda_mystudies_activity_ui_kit/activity_builder.dart';
import 'package:fda_mystudies_activity_ui_kit/src/injection/injection.dart';
import 'package:fda_mystudies_activity_ui_kit/src/template/unimplemented_template.dart';
import 'package:fda_mystudies_spec/study_datastore_service/activity_step.pb.dart';
import 'package:flutter_test/flutter_test.dart';

import 'actvity_response_processor_sample.dart';
import 'test_utils.dart';

void main() {
  ActivityBuilder? activityBuilder;

  setUpAll(() {
    configureDependencies();
    activityBuilder = getIt<ActivityBuilder>();
  });
  group('Activity Builder Unimpleted Widget Tests', () {
    test('no steps supplied, returns activityResponseProcessor', () {
      const responseProcessor = ActivityResponseProcessorSample();
      var returnedWidget =
          activityBuilder!.buildActivity([], true, responseProcessor);

      expect(returnedWidget, responseProcessor);
    });

    testWidgets('unimplemented step supplied, returns UnimplementedTemplate',
        (WidgetTester tester) async {
      const activityStepKey = 'Scaled Activity';
      const responseProcessor = ActivityResponseProcessorSample();
      var returnedWidget = activityBuilder!.buildActivity([
        ActivityStep.create()
          ..type = 'question'
          ..resultType = 'scale'
          ..key = activityStepKey
      ], true, responseProcessor);
      await tester.pumpWidget(TestUtils.createWidgetForTesting(returnedWidget));

      final scaffoldTitleFinder = find.text('Unimplemented $activityStepKey');
      final bodyTextFinder = find.text(UnimplementedTemplate.pageContent);

      expect(returnedWidget is UnimplementedTemplate, true);
      expect(scaffoldTitleFinder, findsOneWidget);
      expect(bodyTextFinder, findsOneWidget);
    });
  });
}
