import 'dart:convert';
import 'dart:developer' as developer;

import 'package:fda_mystudies_spec/response_datastore_service/process_response.pb.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

import '../activity_builder_impl.dart';

class LocalStorageUtil {
  static const securedStorage = FlutterSecureStorage(
      iOptions: IOSOptions(),
      aOptions: AndroidOptions(encryptedSharedPreferences: true));

  static Future<void> saveTemporaryResult(
      {required String stepKey,
      required dynamic selectedValue,
      required String resultType,
      required String startTime}) {
    var tempKey = _generateStepKey(true, stepKey);
    var tempValue = jsonEncode(createStepResult(
            skipped: false,
            stepKey: stepKey,
            resultType: resultType,
            startTime: startTime,
            selectedValue: selectedValue)
        .toProto3Json());
    return securedStorage.write(key: tempKey, value: tempValue);
  }

  static Future<void> discardTemporaryResult(String stepKey) {
    var tempKey = _generateStepKey(true, stepKey);
    return securedStorage.delete(key: tempKey);
  }

  static Future<void> discardAllTemporaryResults() {
    return Future.wait(ActivityBuilderImpl.stepKeys.map((curStepKey) {
      var tempKey = _generateStepKey(true, curStepKey);
      return securedStorage.delete(key: tempKey);
    })).then((value) => developer.log('DISCARDED'));
  }

  static Future<void> savePastResult() {
    return Future.wait(ActivityBuilderImpl.stepKeys.map((curStepKey) {
      var tempKey = _generateStepKey(true, curStepKey);
      return securedStorage.containsKey(key: tempKey).then((hasTemporaryValue) {
        if (hasTemporaryValue) {
          var permanentKey = _generateStepKey(false, curStepKey);
          return securedStorage.read(key: tempKey).then((tempValue) {
            return securedStorage.write(key: permanentKey, value: tempValue);
          });
        }
      });
    })).then((value) => developer.log('SAVED'));
  }

  static String _generateStepKey(bool temporary, String stepKey) {
    return ActivityBuilderImpl.prefixUniqueActivityStepId +
        (temporary ? 'temp' : '') +
        stepKey;
  }

  static String currentTimeToString() {
    final dateFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
    var currentTime = DateTime.now();
    return '${dateFormat.format(currentTime)}.${currentTime.millisecond}';
  }

  static Future<dynamic> readSavedResult(String curKey) {
    String tempKey = _generateStepKey(true, curKey);
    return securedStorage.containsKey(key: tempKey).then((containsKey) {
      if (containsKey) {
        return securedStorage
            .read(key: tempKey)
            .then((jsonStr) => _valueFromStepResult(jsonStr));
      }
      String permKey = _generateStepKey(false, curKey);
      return securedStorage.read(key: permKey).then((jsonStr) {
        var result = _valueFromStepResult(jsonStr);
        return result;
      });
    });
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

  static ActivityResponse_Data_StepResult createStepResult(
      {required String stepKey,
      required String resultType,
      required String startTime,
      required dynamic selectedValue,
      required bool skipped}) {
    var stepResult = ActivityResponse_Data_StepResult()
      ..key = stepKey
      ..skipped = skipped
      ..resultType = resultType
      ..startTime = startTime
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
}
