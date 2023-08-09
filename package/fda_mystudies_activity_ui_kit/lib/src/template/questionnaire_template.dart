import 'dart:developer' as developer;
import 'dart:math';

import 'package:fda_mystudies_design_system/block/page_text_block.dart';
import 'package:fda_mystudies_design_system/block/page_title_block.dart';
import 'package:fda_mystudies_design_system/block/primary_button_block.dart';
import 'package:fda_mystudies_design_system/block/text_button_block.dart';
import 'package:fda_mystudies_spec/response_datastore_service/process_response.pb.dart';
import 'package:fda_mystudies_spec/study_datastore_service/activity_step.pb.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../activity_response_processor.dart';
import '../activity_builder_impl.dart';
import '../storage/local_storage_util.dart';
import 'unimplemented_template.dart';

class QuestionnaireTemplate extends StatelessWidget {
  static var dateFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
  static final Map<String, ActivityResponse_Data_StepResult> _answers = {};

  final ActivityStep _step;
  final bool _allowExit;
  final String _title;
  final Map<String, Widget> _widgetMap;
  final List<Widget> _children;
  final dynamic selectedValue;
  final String _startTime;

  const QuestionnaireTemplate(this._step, this._allowExit, this._title,
      this._widgetMap, this._children, this._startTime,
      {this.selectedValue, Key? key})
      : super(key: key);

  Widget _findNextScreen(bool skipped) {
    if (_step.destinations.isEmpty) {
      return _widgetMap[''] ??
          UnimplementedTemplate(_step.destinations.first.destination);
    } else if (_step.destinations.length == 1) {
      return _widgetMap[_step.destinations.first.destination] ??
          UnimplementedTemplate(_step.destinations.first.destination);
    } else {
      var val = '';
      if (!skipped) {
        if (selectedValue is List) {
          if (selectedValue.length > 0) {
            val = selectedValue.first.toString();
          }
        } else if (selectedValue is double) {
          val = selectedValue.toInt().toString();
        } else if (selectedValue is Map<String, dynamic>) {
          val = selectedValue['other'] as String;
        } else {
          val = selectedValue.toString();
        }
      }
      for (var destination in _step.destinations) {
        var isConditionMet = false;
        if (destination.operator == 'e' || destination.operator == '') {
          isConditionMet = (val == destination.condition);
          // TODO (cg2092): Add support for gt, lt, gte, lte operators for branching.
          // } else if (destination.operator == 'gt') {
          //   isConditionMet = (val > destination.condition);
          // } else if (destination.operator == 'lt') {
          //   isConditionMet = (val < destination.condition);
          // } else if (destination.operator == 'gte') {
          //   isConditionMet = (val >= destination.condition);
          // } else if (destination.operator == 'lte') {
          //   isConditionMet = (val <= destination.condition);
        } else if (destination.operator == 'ne') {
          isConditionMet = (val != destination.condition);
        }
        if (isConditionMet) {
          return _widgetMap[destination.destination] ??
              UnimplementedTemplate(_step.destinations.first.destination);
        }
      }
    }
    return _widgetMap[_step.destinations.first.destination] ??
        UnimplementedTemplate(_step.destinations.first.destination);
  }

  void _navigateToNextScreen(BuildContext context, bool skipped) {
    if (!skipped) {
      LocalStorageUtil.saveTemporaryResult(
              stepKey: _step.key,
              selectedValue: selectedValue,
              resultType: _step.resultType,
              startTime: _startTime)
          .then((value) => developer.log('TEMPORARY RESULT SAVED'));
    } else {
      LocalStorageUtil.discardTemporaryResult(_step.key)
          .then((value) => developer.log('TEMPORARY RESULT DISCARDED'));
    }
    var nextScreen = _findNextScreen(skipped);
    if (_step.type.toLowerCase() == 'question') {
      var stepResult = LocalStorageUtil.createStepResult(
          stepKey: _step.key,
          resultType: _step.resultType,
          startTime: _startTime,
          selectedValue: selectedValue,
          skipped: skipped);
      _answers[_step.key] = stepResult;
    }
    if (nextScreen is ActivityResponseProcessor) {
      List<ActivityResponse_Data_StepResult> stepResultList = [];
      for (String key in ActivityBuilderImpl.stepKeys) {
        if (_answers.containsKey(key)) {
          stepResultList.add(_answers[key]!);
        }
      }
      nextScreen.processResponses(stepResultList);
    }
    Navigator.of(context).push<void>(
        MaterialPageRoute<void>(builder: (BuildContext context) => nextScreen));
  }

  @override
  Widget build(BuildContext context) {
    var stepTitle = _step.title;
    var subTitle = _step.text;
    var scaleFactor = MediaQuery.of(context).textScaleFactor;
    double bottomPaddingHeight = max(150, 90 * scaleFactor) + 92;
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
            appBar: AppBar(
                title:
                    Text(_title, style: Theme.of(context).textTheme.bodyLarge),
                elevation: 0,
                actions: _allowExit
                    ? [
                        TextButton(
                            onPressed: () {
                              ActivityBuilderImpl().quickExitFlow(context);
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red,
                              padding: EdgeInsets.zero,
                            ),
                            child: const Icon(Icons.exit_to_app))
                      ]
                    : []),
            body: Stack(children: [
              ListView(
                  children: <Widget>[
                        PageTitleBlock(title: stepTitle),
                      ] +
                      (_step.type == 'instruction'
                          ? []
                          : [
                              PageTextBlock(
                                  text: subTitle, textAlign: TextAlign.left),
                              const SizedBox(height: 24)
                            ]) +
                      _children +
                      [SizedBox(height: bottomPaddingHeight)]),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                      child: Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: const [0.1, 0.2, 0.6],
                            colors: [
                              Theme.of(context)
                                  .colorScheme
                                  .background
                                  .withOpacity(0.7),
                              Theme.of(context)
                                  .colorScheme
                                  .background
                                  .withOpacity(0.9),
                              Theme.of(context).colorScheme.background
                            ],
                          )),
                          height: max(150, 90 * scaleFactor),
                          child: Column(
                              children: <Widget>[
                                    PrimaryButtonBlock(
                                        title: 'Next',
                                        onPressed: selectedValue == null &&
                                                _step.type.toLowerCase() ==
                                                    'question'
                                            ? null
                                            : () => _navigateToNextScreen(
                                                context, false)),
                                  ] +
                                  (_step.skippable
                                      ? <Widget>[
                                          TextButtonBlock(
                                              title: 'Skip',
                                              onPressed: () =>
                                                  _navigateToNextScreen(
                                                      context, true))
                                        ]
                                      : <Widget>[])))))
            ])));
  }
}
