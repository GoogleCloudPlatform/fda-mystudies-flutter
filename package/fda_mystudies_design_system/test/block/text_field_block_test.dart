import 'package:fda_mystudies_design_system/block/text_field_block.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../test_util.dart';

void main() {
  const placeholder = 'Enter some text';

  testGoldens('TextField should be displayed correctly', (tester) async {
    final textField = Scaffold(
        appBar: AppBar(),
        body: ListView(children: [
          TextFieldBlock(
              controller: TextEditingController(), placeholder: placeholder)
        ]));
    await TestUtil.testWidgetInBothThemes(
        tester: tester, testWidget: textField, widgetId: 'text_field_block');

    final textFieldWithInfo = Scaffold(
        appBar: AppBar(),
        body: ListView(children: [
          TextFieldBlock(
              controller: TextEditingController(),
              placeholder: placeholder,
              helperText:
                  'Some helpful information on the data expected from the users.')
        ]));
    await TestUtil.testWidgetInBothThemes(
        tester: tester,
        testWidget: textFieldWithInfo,
        widgetId: 'text_field_block.with_info');

    final textFieldFilled = Scaffold(
        appBar: AppBar(),
        body: ListView(children: [
          TextFieldBlock(
              controller: TextEditingController(), placeholder: placeholder)
        ]));
    await TestUtil.testWidgetInBothThemes(
        tester: tester,
        testWidget: textFieldFilled,
        action: () async {
          for (final element in find
              .byWidgetPredicate((widget) => widget is TextField)
              .evaluate()) {
            await tester.enterText(
                find.byWidget(element.widget), 'Hello World!');
            await tester.pumpAndSettle();
          }
        },
        widgetId: 'text_field_block.filled');

    final obscuredTextField = Scaffold(
        appBar: AppBar(),
        body: ListView(children: [
          TextFieldBlock(
              controller: TextEditingController(),
              placeholder: 'Password',
              obscureText: true)
        ]));
    await TestUtil.testWidgetInBothThemes(
        tester: tester,
        testWidget: obscuredTextField,
        action: () async {
          for (final element in find
              .byWidgetPredicate((widget) => widget is TextField)
              .evaluate()) {
            await tester.enterText(find.byWidget(element.widget), 'password');
            await tester.pumpAndSettle();
          }
        },
        widgetId: 'text_field_block.obscured');
    await TestUtil.testWidgetInBothThemes(
        tester: tester,
        testWidget: obscuredTextField,
        action: () async {
          await TestUtil.tapIconButton(tester: tester, icon: Icons.visibility);
        },
        widgetId: 'text_field_block.obscured_visible');

    final requiredTextField = Scaffold(
        appBar: AppBar(),
        body: ListView(children: [
          TextFieldBlock(
              required: true,
              controller: TextEditingController(),
              placeholder: 'Required')
        ]));
    await TestUtil.testWidgetInBothThemes(
        tester: tester,
        testWidget: requiredTextField,
        action: () async {
          for (final element in find
              .byWidgetPredicate((widget) => widget is TextField)
              .evaluate()) {
            await tester.enterText(find.byWidget(element.widget), '');
            await tester.testTextInput.receiveAction(TextInputAction.done);
            await tester.pumpAndSettle();
          }
        },
        widgetId: 'text_field_block.required');
  });
}
