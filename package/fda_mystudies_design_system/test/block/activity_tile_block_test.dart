import 'package:fda_mystudies_design_system/block/activity_tile_block.dart';
import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../test_util.dart';

void main() {
  testGoldens(
      'ActivityTile block with In Progress status should be displayed correctly',
      (tester) async {
    final testWidget = Scaffold(
        appBar: AppBar(),
        body: ListView(children: [
          ActivityTileBlock(
              title: 'Baseline Study',
              status: ActivityStatus.inProgress,
              frequency: ActivityFrequency.oneTime,
              onTap: () {})
        ]));

    await TestUtil.testWidgetInBothThemes(
        tester: tester,
        testWidget: testWidget,
        widgetId: 'activity_tile.in_progress');
  });

  testGoldens(
      'ActivityTile block with long title & Start status should be displayed correctly',
      (tester) async {
    final testWidget = Scaffold(
        appBar: AppBar(),
        body: ListView(children: [
          ActivityTileBlock(
              title: 'Questionnaire to test all the UI elements',
              status: ActivityStatus.yetToJoin,
              frequency: ActivityFrequency.weekly,
              onTap: () {})
        ]));

    await TestUtil.testWidgetInBothThemes(
        tester: tester,
        testWidget: testWidget,
        widgetId: 'activity_tile.start');
  });
}
