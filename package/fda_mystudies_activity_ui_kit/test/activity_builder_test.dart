import 'package:fda_mystudies_activity_ui_kit/activity_builder.dart';
import 'package:fda_mystudies_activity_ui_kit/src/injection/injection.dart';
import 'package:fda_mystudies_activity_ui_kit/src/template/questionnaire/boolean_template.dart';
import 'package:fda_mystudies_activity_ui_kit/src/template/questionnaire/date_template.dart';
import 'package:fda_mystudies_activity_ui_kit/src/template/questionnaire/horizontal_scale_template.dart';
import 'package:fda_mystudies_activity_ui_kit/src/template/questionnaire/horizontal_text_scale_template.dart';
import 'package:fda_mystudies_activity_ui_kit/src/template/questionnaire/image_choice_template.dart';
import 'package:fda_mystudies_activity_ui_kit/src/template/questionnaire/instruction_template.dart';
import 'package:fda_mystudies_activity_ui_kit/src/template/questionnaire/multiple_text_choice_template.dart';
import 'package:fda_mystudies_activity_ui_kit/src/template/questionnaire/numerical_text_template.dart';
import 'package:fda_mystudies_activity_ui_kit/src/template/questionnaire/single_text_choice_template.dart';
import 'package:fda_mystudies_activity_ui_kit/src/template/questionnaire/text_template.dart';
import 'package:fda_mystudies_activity_ui_kit/src/template/questionnaire/time_interval_template.dart';
import 'package:fda_mystudies_activity_ui_kit/src/template/questionnaire/time_of_day_template.dart';
import 'package:fda_mystudies_activity_ui_kit/src/template/questionnaire/value_picker_template.dart';
import 'package:fda_mystudies_activity_ui_kit/src/template/questionnaire/vertical_scale_template.dart';
import 'package:fda_mystudies_activity_ui_kit/src/template/questionnaire/vertical_text_scale_template.dart';
import 'package:fda_mystudies_activity_ui_kit/src/template/questionnaire_template.dart';
import 'package:fda_mystudies_spec/fda_mystudies_spec.dart';
import 'package:fda_mystudies_spec/study_datastore_service/activity_step.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'actvity_response_processor_sample.dart';
import 'config_object/android_config.dart';
import 'test_utils.dart';

void main() {
  ActivityBuilder? activityBuilder;

  setUpAll(() {
    configureDependencies(AndroidConfig());
    activityBuilder = getIt<ActivityBuilder>();
  });
  group('Activity Builder Unimpleted Widget Tests', () {
    test('no steps supplied, returns activityResponseProcessor', () {
      const responseProcessor = ActivityResponseProcessorSample();
      var returnedWidget = activityBuilder!.buildActivity(
          [], responseProcessor, 'uniqueActivityId',
          allowExit: true, exitRouteName: '/');

      expect(returnedWidget, responseProcessor);
    });

    testWidgets('unimplemented step supplied, returns UnimplementedTemplate',
        (WidgetTester tester) async {
      const activityStepKey = 'Scaled Activity';
      const responseProcessor = ActivityResponseProcessorSample();
      var returnedWidget = activityBuilder!.buildActivity([
        ActivityStep.create()
          ..type = 'question'
          ..resultType = 'location'
          ..key = activityStepKey
      ], responseProcessor, 'uniqueActivityId',
          allowExit: true, exitRouteName: '/');
      await tester.pumpWidget(TestUtils.createWidgetForTesting(returnedWidget));

      final scaffoldTitleFinder = find.text('Step 1 of 1');

      expect(returnedWidget is QuestionnaireTemplate, true);
      expect(scaffoldTitleFinder, findsOneWidget);
    });
  });

  group('Activity Builder Widget sequence tests', () {
    testWidgets('Vertical Scale test', (WidgetTester tester) async {
      const responseProcessor = ActivityResponseProcessorSample();
      var returnedWidget = activityBuilder!.buildActivity([
        ActivityStep()..fromJson('''
            {
                "type": "question",
                "resultType": "scale",
                "key": "vertical-scale",
                "title": "Vertical Scale",
                "text": "",
                "skippable": true,
                "groupName": "",
                "repeatable": false,
                "repeatableText": "",
                "destinations": [
                    {
                        "condition": "",
                        "operator": "",
                        "destination": "horizont-scale"
                    }
                ],
                "healthDataKey": "",
                "format": {
                    "maxValue": 5,
                    "minValue": 0,
                    "step": 1,
                    "default": 3,
                    "vertical": true,
                    "maxDesc": "",
                    "minDesc": "",
                    "maxImage": "",
                    "minImage": ""
                },
                "steps": [],
                "options": []
            }
          ''')
      ], responseProcessor, 'uniqueActivityId',
          allowExit: true, exitRouteName: '/');

      await tester.pumpWidget(MaterialApp(home: returnedWidget));

      expect(returnedWidget is VerticalScaleTemplate, true);
      expect(find.text('Step 1 of 1'), findsOneWidget);
      expect(find.text('Vertical Scale'), findsOneWidget);
      expect(find.text('0'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'NEXT'), findsOneWidget);
      expect(find.widgetWithText(OutlinedButton, 'SKIP'), findsOneWidget);
    });

    testWidgets('Horizontal Scale test', (WidgetTester tester) async {
      const responseProcessor = ActivityResponseProcessorSample();
      var returnedWidget = activityBuilder!.buildActivity([
        ActivityStep()..fromJson('''
            {
                "type": "question",
                "resultType": "scale",
                "key": "horizont-scale",
                "title": "Horizontal Scale",
                "text": "",
                "skippable": false,
                "groupName": "",
                "repeatable": false,
                "repeatableText": "",
                "destinations": [
                    {
                        "condition": "",
                        "operator": "",
                        "destination": "c-vert-scale"
                    }
                ],
                "healthDataKey": "",
                "format": {
                    "maxValue": 5,
                    "minValue": 0,
                    "step": 1,
                    "default": 3,
                    "vertical": false,
                    "maxDesc": "",
                    "minDesc": "",
                    "maxImage": "",
                    "minImage": ""
                },
                "steps": [],
                "options": []
            }
          ''')
      ], responseProcessor, 'uniqueActivityId',
          allowExit: true, exitRouteName: '/');

      await tester.pumpWidget(MaterialApp(home: returnedWidget));

      expect(returnedWidget is HorizontalScaleTemplate, true);
      expect(find.text('Horizontal Scale'), findsOneWidget);
      expect(find.text('0'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'NEXT'), findsOneWidget);
      expect(find.widgetWithText(OutlinedButton, 'SKIP'), findsNothing);
    });

    testWidgets('Vertical Continuous Scale test', (WidgetTester tester) async {
      const responseProcessor = ActivityResponseProcessorSample();
      var returnedWidget = activityBuilder!.buildActivity([
        ActivityStep()..fromJson('''
            {
                "type": "question",
                "resultType": "continuousScale",
                "key": "c-vert-scale",
                "title": "Vertical Continuous Scale",
                "text": "",
                "skippable": true,
                "groupName": "",
                "repeatable": false,
                "repeatableText": "",
                "destinations": [
                    {
                        "condition": "",
                        "operator": "",
                        "destination": "c-hori-scale"
                    }
                ],
                "healthDataKey": "",
                "format": {
                    "maxValue": 5.0,
                    "minValue": 0.0,
                    "default": 3.0,
                    "maxFractionDigits": 2,
                    "vertical": true,
                    "maxDesc": "",
                    "minDesc": "",
                    "maxImage": "",
                    "minImage": ""
                },
                "steps": [],
                "options": []
            }
          ''')
      ], responseProcessor, 'uniqueActivityId',
          allowExit: true, exitRouteName: '/');

      await tester.pumpWidget(MaterialApp(home: returnedWidget));

      expect(returnedWidget is VerticalScaleTemplate, true);
      expect(find.text('Vertical Continuous Scale'), findsOneWidget);
      expect(find.text('0.0'), findsOneWidget);
      expect(find.text('5.0'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'NEXT'), findsOneWidget);
      expect(find.widgetWithText(OutlinedButton, 'SKIP'), findsOneWidget);
    });

    testWidgets('Horizontal Continuous Scale test',
        (WidgetTester tester) async {
      const responseProcessor = ActivityResponseProcessorSample();
      var returnedWidget = activityBuilder!.buildActivity([
        ActivityStep()..fromJson('''
            {
                "type": "question",
                "resultType": "continuousScale",
                "key": "c-hori-scale",
                "title": "Horizontal Continuous Scale",
                "text": "",
                "skippable": false,
                "groupName": "",
                "repeatable": false,
                "repeatableText": "",
                "destinations": [
                    {
                        "condition": "",
                        "operator": "",
                        "destination": "v-text-sclae"
                    }
                ],
                "healthDataKey": "",
                "format": {
                    "maxValue": 5.0,
                    "minValue": 0.0,
                    "default": 3.0,
                    "maxFractionDigits": 2,
                    "vertical": false,
                    "maxDesc": "",
                    "minDesc": "",
                    "maxImage": "",
                    "minImage": ""
                },
                "steps": [],
                "options": []
            }
          ''')
      ], responseProcessor, 'uniqueActivityId',
          allowExit: true, exitRouteName: '/');

      await tester.pumpWidget(MaterialApp(home: returnedWidget));

      expect(returnedWidget is HorizontalScaleTemplate, true);
      expect(find.text('Horizontal Continuous Scale'), findsOneWidget);
      expect(find.text('0.0'), findsOneWidget);
      expect(find.text('5.0'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'NEXT'), findsOneWidget);
      expect(find.widgetWithText(OutlinedButton, 'SKIP'), findsNothing);
    });

    testWidgets('Vertical Text Scale test', (WidgetTester tester) async {
      const responseProcessor = ActivityResponseProcessorSample();
      var returnedWidget = activityBuilder!.buildActivity([
        ActivityStep()..fromJson('''
            {
                "type": "question",
                "resultType": "textScale",
                "key": "v-text-sclae",
                "title": "Vertical Text Scale",
                "text": "",
                "skippable": true,
                "groupName": "",
                "repeatable": false,
                "repeatableText": "",
                "destinations": [
                    {
                        "condition": "2",
                        "operator": "",
                        "destination": "hori-text-scale"
                    },
                    {
                        "condition": "1",
                        "operator": "",
                        "destination": "hori-text-scale"
                    },
                    {
                        "condition": "0",
                        "operator": "",
                        "destination": "hori-text-scale"
                    },
                    {
                        "condition": "-1",
                        "operator": "",
                        "destination": "hori-text-scale"
                    },
                    {
                        "condition": "-2",
                        "operator": "",
                        "destination": "hori-text-scale"
                    },
                    {
                        "condition": "",
                        "operator": "",
                        "destination": "hori-text-scale"
                    }
                ],
                "healthDataKey": "",
                "format": {
                    "textChoices": [
                        {
                            "text": "Strongly Agree",
                            "value": "2",
                            "detail": "",
                            "exclusive": true
                        },
                        {
                            "text": "Agree",
                            "value": "1",
                            "detail": "",
                            "exclusive": true
                        },
                        {
                            "text": "Neutral",
                            "value": "0",
                            "detail": "",
                            "exclusive": true
                        },
                        {
                            "text": "Disagree",
                            "value": "-1",
                            "detail": "",
                            "exclusive": true
                        },
                        {
                            "text": "Strongly Disagree",
                            "value": "-2",
                            "detail": "",
                            "exclusive": true
                        }
                    ],
                    "default": 2,
                    "vertical": true
                },
                "steps": [],
                "options": []
            }
          ''')
      ], responseProcessor, 'uniqueActivityId',
          allowExit: true, exitRouteName: '/');

      await tester.pumpWidget(MaterialApp(home: returnedWidget));

      expect(returnedWidget is VerticalTextScaleTemplate, true);
      expect(find.text('Vertical Text Scale'), findsOneWidget);
      expect(find.text('Strongly Disagree'), findsOneWidget);
      expect(find.text('Disagree'), findsOneWidget);
      expect(find.text('Neutral'), findsOneWidget);
      // Since default value is 2, Agree the second item is selected value.
      expect(find.text('Agree'), findsNWidgets(2));
      expect(find.text('Strongly Agree'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'NEXT'), findsOneWidget);
      expect(find.widgetWithText(OutlinedButton, 'SKIP'), findsOneWidget);
    });

    testWidgets('Horizontal Text Scale test', (WidgetTester tester) async {
      const responseProcessor = ActivityResponseProcessorSample();
      var returnedWidget = activityBuilder!.buildActivity([
        ActivityStep()..fromJson('''
            {
                "type": "question",
                "resultType": "textScale",
                "key": "hori-text-scale",
                "title": "Horizontal Text Scale",
                "text": "",
                "skippable": true,
                "groupName": "",
                "repeatable": false,
                "repeatableText": "",
                "destinations": [
                    {
                        "condition": "-2",
                        "operator": "",
                        "destination": "value-picker"
                    },
                    {
                        "condition": "-1",
                        "operator": "",
                        "destination": "value-picker"
                    },
                    {
                        "condition": "0",
                        "operator": "",
                        "destination": "value-picker"
                    },
                    {
                        "condition": "1",
                        "operator": "",
                        "destination": "value-picker"
                    },
                    {
                        "condition": "2",
                        "operator": "",
                        "destination": "value-picker"
                    },
                    {
                        "condition": "",
                        "operator": "",
                        "destination": "value-picker"
                    }
                ],
                "healthDataKey": "",
                "format": {
                    "textChoices": [
                        {
                            "text": "Strongly Disagree",
                            "value": "-2",
                            "detail": "",
                            "exclusive": true
                        },
                        {
                            "text": "Disagree",
                            "value": "-1",
                            "detail": "",
                            "exclusive": true
                        },
                        {
                            "text": "Neutral",
                            "value": "0",
                            "detail": "",
                            "exclusive": true
                        },
                        {
                            "text": "Agree",
                            "value": "1",
                            "detail": "",
                            "exclusive": true
                        },
                        {
                            "text": "Strongly Agree",
                            "value": "2",
                            "detail": "",
                            "exclusive": true
                        }
                    ],
                    "default": 2,
                    "vertical": false
                },
                "steps": [],
                "options": []
            }
          ''')
      ], responseProcessor, 'uniqueActivityId',
          allowExit: true, exitRouteName: '/');

      await tester.pumpWidget(MaterialApp(home: returnedWidget));

      expect(returnedWidget is HorizontalTextScaleTemplate, true);
      expect(find.text('Horizontal Text Scale'), findsOneWidget);
      expect(find.text('Strongly Disagree'), findsOneWidget);
      expect(find.text('Disagree'), findsOneWidget); // Selected Item
      expect(find.text('Strongly Agree'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'NEXT'), findsOneWidget);
      expect(find.widgetWithText(OutlinedButton, 'SKIP'), findsOneWidget);
    });

    testWidgets('Value Picker test', (WidgetTester tester) async {
      const responseProcessor = ActivityResponseProcessorSample();
      var returnedWidget = activityBuilder!.buildActivity([
        ActivityStep()..fromJson('''
            {
                "type": "question",
                "resultType": "valuePicker",
                "key": "value-picker",
                "title": "Value Picker",
                "text": "",
                "skippable": true,
                "groupName": "",
                "repeatable": false,
                "repeatableText": "",
                "destinations": [
                    {
                        "condition": "",
                        "operator": "",
                        "destination": "image-choice"
                    }
                ],
                "healthDataKey": "",
                "format": {
                    "textChoices": [
                        {
                            "text": "Ice cream",
                            "value": "ice-cream",
                            "detail": "",
                            "exclusive": true
                        },
                        {
                            "text": "Cookies",
                            "value": "cookies",
                            "detail": "",
                            "exclusive": true
                        },
                        {
                            "text": "Cake",
                            "value": "cake",
                            "detail": "",
                            "exclusive": true
                        },
                        {
                            "text": "Candies",
                            "value": "candies",
                            "detail": "",
                            "exclusive": true
                        },
                        {
                            "text": "Cold Drinks",
                            "value": "cold-drinks",
                            "detail": "",
                            "exclusive": true
                        }
                    ]
                },
                "steps": [],
                "options": []
            }
          ''')
      ], responseProcessor, 'uniqueActivityId',
          allowExit: true, exitRouteName: '/');

      await tester.pumpWidget(MaterialApp(home: returnedWidget));

      expect(returnedWidget is ValuePickerTemplate, true);
      expect(find.text('Value Picker'), findsOneWidget);
      expect(find.text(''), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'NEXT'), findsOneWidget);
      expect(find.widgetWithText(OutlinedButton, 'SKIP'), findsOneWidget);

      await tester.tap(find.text(''));
      await tester.pumpAndSettle();

      expect(find.text('Ice cream'), findsOneWidget);
      expect(find.text('Cookies'), findsOneWidget);
      expect(find.text('Cake'), findsOneWidget);
      expect(find.text('Candies'), findsOneWidget);
      expect(find.text('Cold Drinks'), findsOneWidget);
    });

    testWidgets('Image Choice test', (WidgetTester tester) async {
      const responseProcessor = ActivityResponseProcessorSample();
      var returnedWidget = activityBuilder!.buildActivity([
        ActivityStep()..fromJson('''
            {
                "type": "question",
                "resultType": "imageChoice",
                "key": "image-choice",
                "title": "Image Choice",
                "text": "",
                "skippable": true,
                "groupName": "",
                "repeatable": false,
                "repeatableText": "",
                "destinations": [
                    {
                        "condition": "square",
                        "operator": "",
                        "destination": "sin-text-choice"
                    },
                    {
                        "condition": "circle",
                        "operator": "",
                        "destination": "sin-text-choice"
                    },
                    {
                        "condition": "triangle",
                        "operator": "",
                        "destination": "sin-text-choice"
                    },
                    {
                        "condition": "star",
                        "operator": "",
                        "destination": "sin-text-choice"
                    },
                    {
                        "condition": "",
                        "operator": "",
                        "destination": "sin-text-choice"
                    }
                ],
                "healthDataKey": "",
                "format": {
                    "imageChoices": [
                        {
                            "image": "iVBORw0KGgoAAAANSUhEUgAAAGQAAABkCAYAAABw4pVUAAAAAXNSR0IArs4c6QAAAERlWElmTU0AKgAAAAgAAYdpAAQAAAABAAAAGgAAAAAAA6ABAAMAAAABAAEAAKACAAQAAAABAAAAZKADAAQAAAABAAAAZAAAAAAvu95BAAABsUlEQVR4Ae3cwW3CABREQRKlMcqhIpfj0pIGOC15Ek6GI9JfmXnyldvNhwABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIEHgm8PHsy1e+O47j+5X7q90+Ho9fNfy8GsBff96v6gfe7/dq+i12z/NMnsMbkrDuo4LsdsmlIAnrPirIbpdcCpKw7qOC7HbJpSAJ6z4qyG6XXAqSsO6jgux2yaUgCes+Kshul1wKkrDuo4LsdsmlIAnrPirIbpdcCpKw7qOC7HbJpSAJ6z4qyG6XXAqSsO6jgux2yaUgCes+Kshul1wKkrDuo4LsdsmlIAnrPirIbpdcCpKw7qOC7HbJpSAJ6z4qyG6XXAqSsO6jgux2yaUgCes+Kshul1wKkrDuo4LsdsmlIAnrPirIbpdcCpKw7qOC7HbJpSAJ6z4qyG6XXAqSsO6jgux2yaUgCes+Kshul1wKkrDuo4LsdsmlIAnrPirIbpdcCpKw7qOC7HbJpSAJ6z6a/W9v9b+2+0+9xqU35BqdPCUBAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIEPj3Aj9TUwm5QS0eyQAAAABJRU5ErkJggg==",
                            "selectedImage": "iVBORw0KGgoAAAANSUhEUgAAAGQAAABkCAYAAABw4pVUAAAAAXNSR0IArs4c6QAAAERlWElmTU0AKgAAAAgAAYdpAAQAAAABAAAAGgAAAAAAA6ABAAMAAAABAAEAAKACAAQAAAABAAAAZKADAAQAAAABAAAAZAAAAAAvu95BAAABrklEQVR4Ae3cwW3CABREQRJRbFyR021ogNOSJ+FkOCL9lZknX7ndfAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAIFnAh/Pvnzlu/M8f165v9rtcRy/avh5NYC//rz36gd+HUc1/Ra73+eZPIc3JGHdRwXZ7ZJLQRLWfVSQ3S65FCRh3UcF2e2SS0ES1n1UkN0uuRQkYd1HBdntkktBEtZ9VJDdLrkUJGHdRwXZ7ZJLQRLWfVSQ3S65FCRh3UcF2e2SS0ES1n1UkN0uuRQkYd1HBdntkktBEtZ9VJDdLrkUJGHdRwXZ7ZJLQRLWfVSQ3S65FCRh3UcF2e2SS0ES1n1UkN0uuRQkYd1HBdntkktBEtZ9VJDdLrkUJGHdRwXZ7ZJLQRLWfVSQ3S65FCRh3UcF2e2SS0ES1n1UkN0uuRQkYd1HBdntkktBEtZ9VJDdLrkUJGHdRwXZ7ZJLQRLWfVSQ3S65FCRh3UcF2e2SS0ES1n00+9/e6n9t9596jUtvyDU6eUoCBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIPDvBR7fgAlCT4DnIAAAAABJRU5ErkJggg==",
                            "text": "Square",
                            "value": "square"
                        },
                        {
                            "image": "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",
                            "selectedImage": "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",
                            "text": "Circle",
                            "value": "circle"
                        },
                        {
                            "image": "iVBORw0KGgoAAAANSUhEUgAAAGQAAABkCAYAAABw4pVUAAAAAXNSR0IArs4c6QAAAERlWElmTU0AKgAAAAgAAYdpAAQAAAABAAAAGgAAAAAAA6ABAAMAAAABAAEAAKACAAQAAAABAAAAZKADAAQAAAABAAAAZAAAAAAvu95BAAADOUlEQVR4Ae2Ti03DUBAEA0kbqQUoJ11cFykHSuM2Z0sREuLn927X7ElJDAT73YzmcPCYgAmYgAmYgAmYgAmYgAmYgAmYgAmYgAmYgAmYgAmYgAmYgAmYgAmYgAmYgAnslsD1en3Gaw8LnvawRO4Qyx7Py6fsx6PsyZeDL2U85Y9Pe6hEXkiKiMUNPu6v736tcyktZK3jdDod8MqRr0RaSAoIWDifz7cXrnPi9i76Jivkvo5VyB4qkRWylgAZx+Px9sL1MrFeqH1KCvlYxwodQtQrkRSSAgIS1jpwjUEp6pXICfmsjlJSkpQrkROS4APwP9aB32HUK5ES8lUdpUS7EikhCTwA/bM68DeMciUyQr5bRynRrURGSIIOwP6qDnwHo1qJhJCf1lFKNCuREJKAA5C/Wwe+i1GshF7Ib+soJXqV0AtJsAG4P60D/4NRq4RayF/rKCValVALSaABqL+tA/+LUaqEVshWdZQSnUpohSTIAMy/1oF7YFQqoRSydR2lRKMSSiEJMABxqzpwL4xCJXRCRtVRSvgroROS4ALwtq4D98SwV0IlZHQdpYS7EiohCSwAbVQduDeGuRIaIbPqKCW8ldAISVABWKPrwDMwrJVQCJldRynhrIRCSAIKQJpVB56FYaykXUhXHaWEr5J2IQkmAGd2HXgmhq2SViHddZQSrkpahSSQAJSuOvBsDFMlbUJY6iglPJW0CUkQARjddeAMGJZKWoSw1VFKOCppEZIAAhBY6sBZMAyVTBfCWkcp6a9kupBcPLA8Wx04E6a7kqlC2OsoJb2VTBWSCweWZq0DZ8N0VjJNiEodpaSvkmlCctHAsux14IyYrkqmCFGro5T0VDJFSC4YWFKlDpwV01HJcCGqdZSS+ZUMF5KLBZZTqwNnxsyuZKgQ9TpKydxKhgrJhQJLqdaBs2NmVjJMyF7qKCXzKhkmJBcJLKNeB3bAzKpkiJC91VFK5lQyREguEFhiL3VgF8yMSh7qUdu9L3W8bndH6ju9XC6Xty1POKKQ2PKA5Pf6T7uSq/DxTMAETMAETMAETMAETMAETMAETMAETMAETMAETMAETMAETMAETMAETMAE9k7gHWFFzoQcWiLXAAAAAElFTkSuQmCC",
                            "selectedImage": "iVBORw0KGgoAAAANSUhEUgAAAGQAAABkCAYAAABw4pVUAAAAAXNSR0IArs4c6QAAAERlWElmTU0AKgAAAAgAAYdpAAQAAAABAAAAGgAAAAAAA6ABAAMAAAABAAEAAKACAAQAAAABAAAAZKADAAQAAAABAAAAZAAAAAAvu95BAAADRElEQVR4Ae2V223bUBBEmSBBqglSgp1y1MV2oWoMuSr7NztaEhAMGH7x7p1hZgFK9Iu6ew4OvCweEzABEzABEzABEzABEzABEzABEzABEzABEzABEzABEzABEzABEzABEzABEzCBwxI4n8/3uI6w4I8jLJE7xLrH/fou+/Zd9uTrwdcy7vLLuyNUIi8kRcTqBm+39zff1rmVFrLV8evpacGVI1+JtJAUELDw5+HheuE+J66voi+yQm7r+H25LLiOUImskK0E1PHz+fl64X6d2G7U3iWFvKxjg36ESiSFpICAhK0O3GNQinolckJeq6OULPL/S+SEJPgA/Jd14HsY9UqkhLxVRynRrkRKSAIPQH+tDvwMo1yJjJD31lFKdCuREZKgA7DfqgO/g1GtRELIR+soJZqVSAhJwAHI760Dv4tRrIReyGfrKCV6ldALSbABuB+tA3+DUauEWshX6yglWpVQC0mgAaifrQN/i1GqhFbIXnWUEp1KaIUkyADMr9aBZ2BUKqEUsncdpUSjEkohCTAAca868CyMQiV0QkbVUUr4K6ETkuAC8PauA8/EsFdCJWR0HaWEuxIqIQksAG1UHXg2hrkSGiFddZQS3kpohCSoAKzRdeAzMKyVUAjprqOUcFZCISQBBSB11YHPwjBWMl3IrDpKCV8l04UkmACc7jrwmRi2SqYKmV1HKeGqZKqQBBKAMqsOfDaGqZJpQljqKCU8lUwTkiACMGbXgTNgWCqZIoStjlLCUckUIQkgAIGlDpwFw1BJuxDWOkrJ/EraheTigeXZ6sCZMLMraRXCXkcpmVtJq5BcOLA0ax04G2ZmJW1CVOooJfMqaROSiwaWZa8DZ8TMqqRFiFodpWROJS1CcsHAkip14KyYGZUMF6JaRynpr2S4kFwssJxaHTgzpruSoULU6yglvZUMFZILBZZSrQNnx3RWMkzIUeooJX2VDBOSiwSWUa8DO2C6Khki5Gh1lJKeSoYIyQUCSxylDuyC6ajkW33Ufq9rHZf9nkj9pL+n0+lxzxOOKCT2PCD5s/6nXclV+HgmYAImYAImYAImYAImYAImYAImYAImYAImYAImYAImYAImYAImYAImYAJHJ/APQt8lQEcp0OkAAAAASUVORK5CYII=",
                            "text": "Triangle",
                            "value": "triangle"
                        },
                        {
                            "image": "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",
                            "selectedImage": "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",
                            "text": "Star",
                            "value": "star"
                        }
                    ]
                },
                "steps": [],
                "options": []
            }
          ''')
      ], responseProcessor, 'uniqueActivityId',
          allowExit: true, exitRouteName: '/');

      await tester.pumpWidget(MaterialApp(home: returnedWidget));

      expect(returnedWidget is ImageChoiceTemplate, true);
      expect(find.text('Image Choice'), findsOneWidget);
      expect(find.byWidgetPredicate((widget) => widget is Image),
          findsNWidgets(4));
      expect(find.widgetWithText(ElevatedButton, 'NEXT'), findsOneWidget);
      expect(find.widgetWithText(OutlinedButton, 'SKIP'), findsOneWidget);
    });

    testWidgets('Single Text Choice test', (WidgetTester tester) async {
      const responseProcessor = ActivityResponseProcessorSample();
      var returnedWidget = activityBuilder!.buildActivity([
        ActivityStep()..fromJson('''
            {
                "type": "question",
                "resultType": "textChoice",
                "key": "sin-text-choice",
                "title": "Single Text Choice",
                "text": "",
                "skippable": true,
                "groupName": "",
                "repeatable": false,
                "repeatableText": "",
                "destinations": [
                    {
                        "condition": "square",
                        "operator": "",
                        "destination": "mult-text-choic"
                    },
                    {
                        "condition": "circle",
                        "operator": "",
                        "destination": "mult-text-choic"
                    },
                    {
                        "condition": "triangle",
                        "operator": "",
                        "destination": "mult-text-choic"
                    },
                    {
                        "condition": "",
                        "operator": "",
                        "destination": "mult-text-choic"
                    },
                    {
                        "condition": "other-shape",
                        "operator": "",
                        "destination": "mult-text-choic"
                    }
                ],
                "healthDataKey": "",
                "format": {
                    "textChoices": [
                        {
                            "text": "Square",
                            "value": "square",
                            "detail": "All Sides are equal",
                            "exclusive": false
                        },
                        {
                            "text": "Circle",
                            "value": "circle",
                            "detail": "Centred and every point is equidistant",
                            "exclusive": false
                        },
                        {
                            "text": "Triangle",
                            "value": "triangle",
                            "detail": "The most stable shape",
                            "exclusive": false
                        },
                        {
                            "text": "Other Shape",
                            "value": "other-shape",
                            "detail": "Write down something about the shape you listed",
                            "exclusive": false,
                            "other": {
                                "placeholder": "Rhombus",
                                "isMandatory": false,
                                "textfieldReq": true
                            }
                        }
                    ],
                    "selectionStyle": "Single"
                },
                "steps": [],
                "options": []
            }
          ''')
      ], responseProcessor, 'uniqueActivityId',
          allowExit: true, exitRouteName: '/');

      await tester.pumpWidget(MaterialApp(home: returnedWidget));

      expect(returnedWidget is SingleTextChoiceTemplate, true);
      expect(find.text('Single Text Choice'), findsOneWidget);
      expect(find.text('Square'), findsOneWidget);
      expect(find.text('All Sides are equal'), findsOneWidget);
      expect(find.text('Circle'), findsOneWidget);
      expect(
          find.text('Centred and every point is equidistant'), findsOneWidget);
      expect(find.text('Triangle'), findsOneWidget);
      expect(find.text('The most stable shape'), findsOneWidget);
      expect(find.text('Other Shape'), findsOneWidget);
      expect(find.text('Write down something about the shape you listed'),
          findsOneWidget);
      expect(find.text('Rhombus'), findsNothing);
      expect(find.widgetWithText(ElevatedButton, 'NEXT'), findsOneWidget);
      expect(find.widgetWithText(OutlinedButton, 'SKIP'), findsOneWidget);

      await tester.tap(find.text('Other Shape'));
      await tester.pumpAndSettle();
      expect(find.text('Rhombus'), findsOneWidget);
    });

    testWidgets('Multiple Text Choice test', (WidgetTester tester) async {
      const responseProcessor = ActivityResponseProcessorSample();
      var returnedWidget = activityBuilder!.buildActivity([
        ActivityStep()..fromJson('''
            {
                "type": "question",
                "resultType": "textChoice",
                "key": "mult-text-choic",
                "title": "Multiple Text Choice",
                "text": "",
                "skippable": true,
                "groupName": "",
                "repeatable": false,
                "repeatableText": "",
                "destinations": [
                    {
                        "condition": "1dim",
                        "operator": "",
                        "destination": "boolean"
                    },
                    {
                        "condition": "2dim",
                        "operator": "",
                        "destination": "boolean"
                    },
                    {
                        "condition": "3dim",
                        "operator": "",
                        "destination": "boolean"
                    },
                    {
                        "condition": "4dim",
                        "operator": "",
                        "destination": "boolean"
                    },
                    {
                        "condition": "",
                        "operator": "",
                        "destination": "boolean"
                    }
                ],
                "healthDataKey": "",
                "format": {
                    "textChoices": [
                        {
                            "text": "1-D",
                            "value": "1dim",
                            "detail": "That is the point",
                            "exclusive": false
                        },
                        {
                            "text": "2-D",
                            "value": "2dim",
                            "detail": "Over the line",
                            "exclusive": false
                        },
                        {
                            "text": "3-D",
                            "value": "3dim",
                            "detail": "WYSIWYG",
                            "exclusive": false
                        },
                        {
                            "text": "4-D",
                            "value": "4dim",
                            "detail": "Where time stops",
                            "exclusive": true
                        }
                    ],
                    "selectionStyle": "Multiple"
                },
                "steps": [],
                "options": []
            }
          ''')
      ], responseProcessor, 'uniqueActivityId',
          allowExit: true, exitRouteName: '/');

      await tester.pumpWidget(MaterialApp(home: returnedWidget));

      expect(returnedWidget is MultipleTextChoiceTemplate, true);
      expect(find.text('Multiple Text Choice'), findsOneWidget);
      expect(find.text('1-D'), findsOneWidget);
      expect(find.text('That is the point'), findsOneWidget);
      expect(find.text('2-D'), findsOneWidget);
      expect(find.text('Over the line'), findsOneWidget);
      expect(find.text('3-D'), findsOneWidget);
      expect(find.text('WYSIWYG'), findsOneWidget);
      expect(find.text('4-D'), findsOneWidget);
      expect(find.text('Where time stops'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'NEXT'), findsOneWidget);
      expect(find.widgetWithText(OutlinedButton, 'SKIP'), findsOneWidget);
    });

    testWidgets('Boolean test', (WidgetTester tester) async {
      const responseProcessor = ActivityResponseProcessorSample();
      var returnedWidget = activityBuilder!.buildActivity([
        ActivityStep()..fromJson('''
            {
                "type": "question",
                "resultType": "boolean",
                "key": "boolean",
                "title": "Boolean",
                "text": "Quite black and white. We can't change the Display-text or values here.",
                "skippable": true,
                "groupName": "",
                "repeatable": false,
                "repeatableText": "",
                "destinations": [
                    {
                        "condition": "true",
                        "operator": "",
                        "destination": "decimal-numeric"
                    },
                    {
                        "condition": "false",
                        "operator": "",
                        "destination": "decimal-numeric"
                    },
                    {
                        "condition": "",
                        "operator": "",
                        "destination": "decimal-numeric"
                    }
                ],
                "healthDataKey": "",
                "format": {},
                "steps": [],
                "options": []
            }
          ''')
      ], responseProcessor, 'uniqueActivityId',
          allowExit: true, exitRouteName: '/');

      await tester.pumpWidget(MaterialApp(home: returnedWidget));

      expect(returnedWidget is BooleanTemplate, true);
      expect(find.text('Boolean'), findsOneWidget);
      expect(find.text('Yes'), findsOneWidget);
      expect(find.text('No'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'NEXT'), findsOneWidget);
      expect(find.widgetWithText(OutlinedButton, 'SKIP'), findsOneWidget);
    });

    testWidgets('Numerical Text test', (WidgetTester tester) async {
      const responseProcessor = ActivityResponseProcessorSample();
      var returnedWidget = activityBuilder!.buildActivity([
        ActivityStep()..fromJson('''
            {
                "type": "question",
                "resultType": "numeric",
                "key": "decimal-numeric",
                "title": "Decimal Numeric",
                "text": "For this time you are allowed to fetch data via HealthKit",
                "skippable": true,
                "groupName": "",
                "repeatable": false,
                "repeatableText": "",
                "destinations": [
                    {
                        "condition": "",
                        "operator": "",
                        "destination": "int-numeric"
                    }
                ],
                "healthDataKey": "",
                "format": {
                    "style": "Decimal",
                    "unit": "unit",
                    "minValue": 0.0,
                    "maxValue": 10000.0,
                    "placeholder": "placeholder"
                },
                "steps": [],
                "options": []
            }
          ''')
      ], responseProcessor, 'uniqueActivityId',
          allowExit: true, exitRouteName: '/');

      await tester.pumpWidget(MaterialApp(home: returnedWidget));

      expect(returnedWidget is NumericalTextTemplate, true);
      expect(find.text('Decimal Numeric'), findsOneWidget);
      expect(find.text('placeholder'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'NEXT'), findsOneWidget);
      expect(find.widgetWithText(OutlinedButton, 'SKIP'), findsOneWidget);
    });

    testWidgets('Time of day test', (WidgetTester tester) async {
      const responseProcessor = ActivityResponseProcessorSample();
      var returnedWidget = activityBuilder!.buildActivity([
        ActivityStep()..fromJson('''
            {
                "type": "question",
                "resultType": "timeOfDay",
                "key": "time-of-the-day",
                "title": "Time of the day",
                "text": "",
                "skippable": true,
                "groupName": "",
                "repeatable": false,
                "repeatableText": "",
                "destinations": [
                    {
                        "condition": "",
                        "operator": "",
                        "destination": "date"
                    }
                ],
                "healthDataKey": "",
                "format": {},
                "steps": [],
                "options": []
            }
          ''')
      ], responseProcessor, 'uniqueActivityId',
          allowExit: true, exitRouteName: '/');

      await tester.pumpWidget(MaterialApp(home: returnedWidget));

      expect(returnedWidget is TimeOfDayTemplate, true);
      expect(find.text('Time of the day'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'NEXT'), findsOneWidget);
      expect(find.widgetWithText(OutlinedButton, 'SKIP'), findsOneWidget);
    });

    testWidgets('Date test', (WidgetTester tester) async {
      const responseProcessor = ActivityResponseProcessorSample();
      var returnedWidget = activityBuilder!.buildActivity([
        ActivityStep()..fromJson('''
            {
                "type": "question",
                "resultType": "date",
                "key": "date",
                "title": "Date",
                "text": "",
                "skippable": true,
                "groupName": "",
                "repeatable": false,
                "repeatableText": "",
                "destinations": [
                    {
                        "condition": "",
                        "operator": "",
                        "destination": "date-time"
                    }
                ],
                "healthDataKey": "",
                "format": {
                    "style": "Date",
                    "minDate": "",
                    "maxDate": "",
                    "default": "",
                    "dateRange": "custom"
                },
                "steps": [],
                "options": []
            }
          ''')
      ], responseProcessor, 'uniqueActivityId',
          allowExit: true, exitRouteName: '/');

      await tester.pumpWidget(MaterialApp(home: returnedWidget));

      expect(returnedWidget is DateTemplate, true);
      expect(find.text('Date'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'NEXT'), findsOneWidget);
      expect(find.widgetWithText(OutlinedButton, 'SKIP'), findsOneWidget);
    });

    testWidgets('Text test', (WidgetTester tester) async {
      const responseProcessor = ActivityResponseProcessorSample();
      var returnedWidget = activityBuilder!.buildActivity([
        ActivityStep()..fromJson('''
            {
                "type": "question",
                "resultType": "text",
                "key": "sin-line-text",
                "title": "SIngle Line Text",
                "text": "",
                "skippable": true,
                "groupName": "",
                "repeatable": false,
                "repeatableText": "",
                "destinations": [
                    {
                        "condition": "",
                        "operator": "",
                        "destination": "v-sin-lin-text"
                    }
                ],
                "healthDataKey": "",
                "format": {
                    "maxLength": 80,
                    "validationRegex": "",
                    "invalidMessage": "Invalid Input. Please try again.",
                    "multipleLines": false,
                    "placeholder": "Single line text"
                },
                "steps": [],
                "options": []
            }
          ''')
      ], responseProcessor, 'uniqueActivityId',
          allowExit: true, exitRouteName: '/');

      await tester.pumpWidget(MaterialApp(home: returnedWidget));

      expect(returnedWidget is TextTemplate, true);
      expect(find.text('SIngle Line Text'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'NEXT'), findsOneWidget);
      expect(find.widgetWithText(OutlinedButton, 'SKIP'), findsOneWidget);
    });

    testWidgets('Time Interval test', (WidgetTester tester) async {
      const responseProcessor = ActivityResponseProcessorSample();
      var returnedWidget = activityBuilder!.buildActivity([
        ActivityStep()..fromJson('''
            {
                "type": "question",
                "resultType": "timeInterval",
                "key": "time-interval",
                "title": "Time Interval",
                "text": "",
                "skippable": true,
                "groupName": "",
                "repeatable": false,
                "repeatableText": "",
                "destinations": [
                    {
                        "condition": "",
                        "operator": "",
                        "destination": "height"
                    }
                ],
                "healthDataKey": "",
                "format": {
                    "default": 420,
                    "step": 1
                },
                "steps": [],
                "options": []
            }
          ''')
      ], responseProcessor, 'uniqueActivityId',
          allowExit: true, exitRouteName: '/');

      await tester.pumpWidget(MaterialApp(home: returnedWidget));

      expect(returnedWidget is TimeIntervalTemplate, true);
      expect(find.text('Time Interval'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'NEXT'), findsOneWidget);
      expect(find.widgetWithText(OutlinedButton, 'SKIP'), findsOneWidget);
    });

    testWidgets('Instruction test', (WidgetTester tester) async {
      const responseProcessor = ActivityResponseProcessorSample();
      var returnedWidget = activityBuilder!.buildActivity([
        ActivityStep()..fromJson('''
            {
                "type": "instruction",
                "resultType": "",
                "key": "GoBack",
                "title": "Go Back",
                "text": "<p><b>DO NOT CLICK NEXT!</b></p><p><b>DO NOT SUBMIT</b></p>",
                "skippable": false,
                "groupName": "",
                "repeatable": false,
                "repeatableText": "",
                "destinations": [
                    {
                        "condition": "",
                        "operator": "",
                        "destination": ""
                    }
                ],
                "healthDataKey": "",
                "format": {},
                "steps": [],
                "options": []
            }
          ''')
      ], responseProcessor, 'uniqueActivityId',
          allowExit: true, exitRouteName: '/');

      await tester.pumpWidget(MaterialApp(home: returnedWidget));

      expect(returnedWidget is InstructionTemplate, true);
      expect(find.text('Go Back'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'NEXT'), findsOneWidget);
      expect(find.widgetWithText(OutlinedButton, 'SKIP'), findsNothing);
    });
  });
}
