import 'dart:convert';

import 'package:fda_mystudies_spec/response_datastore_service/process_response.pbserver.dart';
import 'package:fda_mystudies_spec/study_datastore_service/activity_step.pb.dart';
import 'package:fda_mystudies_spec/study_datastore_service/fetch_activity_steps.pb.dart';
import 'package:protobuf/protobuf.dart';

extension ProtoJson on GeneratedMessage {
  void fromJson(String json) {
    Map<String, dynamic> map = jsonDecode(json);
    if (this is FetchActivityStepsResponse) {
      map['activity']['steps'] = _updateStepValue(map['activity']['steps']);
    } else if (this is ActivityStep) {
      map = _updateStepFormat(map);
    }
    mergeFromProto3Json(map, ignoreUnknownFields: true);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = toProto3Json() as Map<String, dynamic>;
    if (this is ActivityResponse_Data_StepResult) {
      print('ActivityResponse_Data_StepResult');
      if (map['intValue'] != null) {
        map['value'] = map['intValue'];
        map.remove('intValue');
      } else if (map['doubleValue'] != null) {
        map['value'] = map['doubleValue'];
        map.remove('doubleValue');
      } else if (map['stringValue'] != null) {
        map['value'] = map['stringValue'];
        map.remove('stringValue');
      } else if (map['boolValue'] != null) {
        map['value'] = map['boolValue'];
        map.remove('boolValue');
      } else if (map['listValue'] != null) {
        map['value'] = map['listValue'];
        map.remove('listValue');
      }
    }
    return map;
  }

  Map<String, String> toHeaderJson() {
    var protoJsonMap = toProto3Json() as Map<String, dynamic>;
    return protoJsonMap.map((key, value) => MapEntry(key, value.toString()));
  }

  List<Map<String, dynamic>> _updateStepValue(List<dynamic> activitySteps) {
    List<Map<String, dynamic>> updatedList = [];
    for (var step in activitySteps) {
      updatedList.add(_updateStepFormat(step));
    }
    return updatedList;
  }

  Map<String, dynamic> _updateStepFormat(Map<String, dynamic> map) {
    var resultType = map['resultType'];
    var format = map['format'];
    if (resultType == 'scale') {
      map['scaleFormat'] = format;
    } else if (resultType == 'continuousScale') {
      map['continuousScale'] = format;
    } else if (resultType == 'textScale') {
      map['textChoice'] = format;
    } else if (resultType == 'valuePicker') {
      map['textChoice'] = format;
    } else if (resultType == 'imageChoice') {
      map['imageChoice'] = format;
    } else if (resultType == 'textChoice') {
      map['textChoice'] = format;
    } else if (resultType == 'numeric') {
      map['numericalFormat'] = format;
    } else if (resultType == 'date') {
      map['dateTime'] = format;
    } else if (resultType == 'timeInterval') {
      map['timeInterval'] = format;
    } else if (resultType == 'text') {
      map['textFormat'] = format;
    } else if (resultType == 'email') {
      map['textFormat'] = format;
    }
    return map;
  }
}
