import 'dart:convert';
import 'dart:io';
import 'dart:developer' as developer;

import 'package:fda_mystudies_spec/response_datastore_service/process_response.pb.dart';
import 'package:fda_mystudies_spec/study_datastore_service/activity_step.pb.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

import '../../activity_response_processor.dart';
import '../activity_builder_impl.dart';
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
      _saveTemporaryResult()
          .then((value) => developer.log('TEMPORARY RESULT SAVED'));
    } else {
      _discardTemporaryResult()
          .then((value) => developer.log('TEMPORARY RESULT DISCARDED'));
    }
    var nextScreen = _findNextScreen(skipped);
    if (_step.type == 'question') {
      var stepResult = _createStepResult(skipped);
      _answers[_step.key] = stepResult;
    }
    if (nextScreen is ActivityResponseProcessor) {
      List<ActivityResponse_Data_StepResult> stepResultList = [];
      for (String key in ActivityBuilderImpl.stepKeys) {
        if (_answers.containsKey(key)) {
          stepResultList.add(_answers[key]!);
        }
      }
      _savePastResult()
          .then((value) => nextScreen.processResponses(stepResultList));
    }
    if (Platform.isIOS) {
      Navigator.of(context).push(CupertinoPageRoute<void>(
          builder: (BuildContext context) => nextScreen));
    } else if (Platform.isAndroid) {
      Navigator.of(context).push<void>(MaterialPageRoute<void>(
          builder: (BuildContext context) => nextScreen));
    }
  }

  static String _generateStepKey(bool temporary, String stepKey) {
    return ActivityBuilderImpl.prefixUniqueActivityStepId +
        (temporary ? 'temp' : '') +
        stepKey;
  }

  Future<void> _saveTemporaryResult() {
    var securedStorage = const FlutterSecureStorage();
    var tempKey = _generateStepKey(true, _step.key);
    return securedStorage.write(
        key: tempKey,
        value: jsonEncode(_createStepResult(false).toProto3Json()));
  }

  Future<void> _discardTemporaryResult() {
    var securedStorage = const FlutterSecureStorage();
    var tempKey = _generateStepKey(true, _step.key);
    return securedStorage.delete(key: tempKey);
  }

  Future<void> _discardAllTemporaryResults() {
    var securedStorage = const FlutterSecureStorage();
    return Future.wait(ActivityBuilderImpl.stepKeys.map((curStepKey) {
      var tempKey = _generateStepKey(true, curStepKey);
      return securedStorage.delete(key: tempKey);
    })).then((value) => developer.log('DISCARDED'));
  }

  Future<void> _savePastResult() {
    var securedStorage = const FlutterSecureStorage();
    return Future.wait(ActivityBuilderImpl.stepKeys.map((curStepKey) {
      var tempKey = _generateStepKey(true, curStepKey);
      return securedStorage.containsKey(key: tempKey).then((hasTemporaryValue) {
        if (hasTemporaryValue) {
          var permanentKey = _generateStepKey(false, curStepKey);
          return securedStorage.read(key: tempKey).then((tempValue) =>
              securedStorage.write(key: permanentKey, value: tempValue));
        }
      });
    })).then((value) => developer.log('SAVED'));
  }

  static Future<dynamic> readSavedResult(String curKey) {
    var securedStorage = const FlutterSecureStorage();
    String tempKey = _generateStepKey(true, curKey);
    return securedStorage.containsKey(key: tempKey).then((containsKey) {
      if (containsKey) {
        return securedStorage
            .read(key: tempKey)
            .then((jsonStr) => _valueFromStepResult(jsonStr));
      }
      String permKey = _generateStepKey(false, curKey);
      return securedStorage
          .read(key: permKey)
          .then((jsonStr) => _valueFromStepResult(jsonStr));
    });
  }

  static String currentTimeToString() {
    var currentTime = DateTime.now();
    return '${dateFormat.format(currentTime)}.${currentTime.millisecond}';
  }

  static dynamic _valueFromStepResult(String? jsonStr) {
    if (jsonStr != null) {
      var stepResult = ActivityResponse_Data_StepResult.create()
        ..mergeFromProto3Json(jsonDecode(jsonStr));
      if (stepResult.hasIntValue()) {
        return stepResult.intValue;
      } else if (stepResult.hasDoubleValue()) {
        return stepResult.doubleValue;
      } else if (stepResult.hasBoolValue()) {
        return stepResult.boolValue;
      } else if (stepResult.hasStringValue()) {
        return stepResult.stringValue;
      } else if (stepResult.listValues.isNotEmpty) {
        return stepResult.listValues;
      }
    }
    return null;
  }

  ActivityResponse_Data_StepResult _createStepResult(bool skipped) {
    var stepResult = ActivityResponse_Data_StepResult()
      ..key = _step.key
      ..skipped = skipped
      ..resultType = _step.resultType
      ..startTime = _startTime
      ..endTime = currentTimeToString();
    if (!skipped) {
      if (selectedValue is int) {
        stepResult.intValue = selectedValue;
      } else if (selectedValue is double) {
        stepResult.doubleValue = selectedValue;
      } else if (selectedValue is bool) {
        stepResult.boolValue = selectedValue;
      } else if (selectedValue is String) {
        stepResult.stringValue = selectedValue;
      } else if (selectedValue is List<String>) {
        stepResult.listValues.addAll(selectedValue);
      }
    }
    return stepResult;
  }

  @override
  Widget build(BuildContext context) {
    var stepTitle = _step.title;
    var subTitle = _step.text;
    if (Platform.isIOS) {
      var titleStyle =
          CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle;
      var subTitleStyle = CupertinoTheme.of(context).textTheme.textStyle;
      return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Stack(children: [
            CupertinoPageScaffold(
                navigationBar: CupertinoNavigationBar(
                    middle: Text(_title,
                        style:
                            const TextStyle(color: CupertinoColors.systemGrey)),
                    trailing: CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          showCupertinoModalPopup<void>(
                            context: context,
                            builder: (BuildContext context) =>
                                CupertinoActionSheet(
                              actions: <CupertinoActionSheetAction>[
                                CupertinoActionSheetAction(
                                  child: const Text('Save for Later'),
                                  onPressed: () {
                                    Navigator.of(context).popUntil(
                                        ModalRoute.withName(
                                            ActivityBuilderImpl.exitRoute));
                                  },
                                ),
                                CupertinoActionSheetAction(
                                  child: const Text('Discard Results'),
                                  isDestructiveAction: true,
                                  onPressed: () {
                                    _discardAllTemporaryResults();
                                    Navigator.of(context).popUntil(
                                        ModalRoute.withName(
                                            ActivityBuilderImpl.exitRoute));
                                  },
                                )
                              ],
                              cancelButton: CupertinoActionSheetAction(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  isDefaultAction: true,
                                  child: const Text('Cancel')),
                            ),
                          );
                        },
                        child: _allowExit
                            ? const Icon(Icons.exit_to_app,
                                color: CupertinoColors.destructiveRed)
                            : const SizedBox(width: 0))),
                child: SafeArea(
                  bottom: false,
                  maintainBottomViewPadding: true,
                  child: ListView(
                      padding: const EdgeInsets.all(20),
                      children: [
                            Text(stepTitle, style: titleStyle),
                            SizedBox(height: subTitle.isEmpty ? 0 : 12),
                          ] +
                          (_step.type == 'instruction'
                              ? []
                              : [
                                  Text(subTitle, style: subTitleStyle),
                                  SizedBox(height: subTitle.isEmpty ? 12 : 36)
                                ]) +
                          _children +
                          [
                            // This sized box is to add padding to the bottom of
                            // the scaffold view to allow it to scroll over the
                            // view that holds the NEXT and SKIP buttons i.e. BOTTOM_VIEW.
                            // We are using bottom viewInset to detect if keyboard is
                            // showing. If keyboard is showing remove the extra padding
                            // meant for scrolling over the BOTTOM_VIEW.
                            //
                            // 20 - Default padding so that widgets from this component
                            //      doesn't stick to the BOTTOM_VIEW.
                            // 142 + 40 x textScaleFactor - This Padding is to match the
                            //      height of the BOTTOM_VIEW. Hacky solution, but it works
                            //      at all textScaleFactors.
                            SizedBox(
                                height: 20 +
                                    (MediaQuery.of(context).viewInsets.bottom ==
                                            0
                                        ? 142 +
                                            40 *
                                                MediaQuery.of(context)
                                                    .textScaleFactor
                                        : 0))
                          ]),
                )),
            Positioned(
                bottom: 0,
                width: MediaQuery.of(context).size.width,
                child: Container(
                    decoration: BoxDecoration(
                        color: CupertinoTheme.of(context).barBackgroundColor),
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                                  CupertinoButton.filled(
                                      child: const Text('NEXT',
                                          style: TextStyle(
                                              color: CupertinoColors.white)),
                                      onPressed: selectedValue == null &&
                                              _step.type == 'question'
                                          ? null
                                          : () => _navigateToNextScreen(
                                              context, false))
                                ].cast<Widget>() +
                                (_step.skippable
                                    ? [
                                        const SizedBox(height: 20),
                                        Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: CupertinoColors
                                                        .activeBlue),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(8.0))),
                                            child: CupertinoButton(
                                                child: const Text('SKIP',
                                                    style: TextStyle(
                                                        color: CupertinoColors
                                                            .activeBlue)),
                                                onPressed: () =>
                                                    _navigateToNextScreen(
                                                        context, true)))
                                      ]
                                    : [])))))
          ]));
    }
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
            appBar: AppBar(
                title: Text(_title),
                actions: _allowExit
                    ? [
                        TextButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext buildContext) {
                                    return AlertDialog(
                                      content: const Text(
                                          'Your responses are stored on the app if you `Save for Later` (unless you sign out) so you can resume and complete the activity before it expires.'),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).popUntil(
                                                  ModalRoute.withName(
                                                      ActivityBuilderImpl
                                                          .exitRoute));
                                            },
                                            child:
                                                const Text('Save for Later')),
                                        TextButton(
                                            onPressed: () {
                                              _discardAllTemporaryResults();
                                              Navigator.of(context).popUntil(
                                                  ModalRoute.withName(
                                                      ActivityBuilderImpl
                                                          .exitRoute));
                                            },
                                            child: const Text('Discard Results',
                                                style: TextStyle(
                                                    color: Colors.red))),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Cancel'))
                                      ],
                                    );
                                  });
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              primary: Colors.red,
                            ),
                            child: const Icon(Icons.exit_to_app))
                      ]
                    : [],
                backgroundColor: Theme.of(context).colorScheme.surface),
            body: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                      Text(stepTitle,
                          style: Theme.of(context).textTheme.headline4),
                      SizedBox(height: subTitle.isEmpty ? 0 : 12),
                    ] +
                    (_step.type == 'instruction'
                        ? []
                        : [
                            Text(subTitle,
                                style: Theme.of(context).textTheme.headline6),
                            const SizedBox(height: 24)
                          ]) +
                    _children),
            bottomNavigationBar: BottomAppBar(
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: (_step.skippable
                                ? [
                                    OutlinedButton(
                                        onPressed: () => _navigateToNextScreen(
                                            context, true),
                                        child: const Text('SKIP'),
                                        style: Theme.of(context)
                                            .textButtonTheme
                                            .style)
                                  ].cast<Widget>()
                                : [].cast<Widget>()) +
                            [
                              const SizedBox(width: 20),
                              ElevatedButton(
                                onPressed: selectedValue == null &&
                                        _step.type == 'question'
                                    ? null
                                    : () =>
                                        _navigateToNextScreen(context, false),
                                child: const Text('NEXT'),
                              )
                            ])))));
  }
}
