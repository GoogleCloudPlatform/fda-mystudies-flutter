import 'package:clock/clock.dart';
import 'package:fda_mystudies_spec/response_datastore_service/get_activity_state.pbserver.dart';
import 'package:fda_mystudies_spec/study_datastore_service/get_activity_list.pb.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum PbActivityStatus { completed, missed, start, ended, inPorgress, upcoming }

class PbActivity {
  final String activityId;
  final GetActivityListResponse_Activity activity;
  final GetActivityStateResponse_ActivityState state;

  PbActivity(this.activityId, this.activity, this.state);

  PbActivityStatus get status {
    var runId =
        int.parse(state.activityRunId.isEmpty ? '1' : state.activityRunId);
    var completed = state.activityRun.completed;
    var missed = state.activityRun.missed;
    if (runId == completed + missed) {
      if (state.activityState == 'completed') {
        return PbActivityStatus.completed;
      } else {
        return PbActivityStatus.missed;
      }
    } else if (runId == completed + missed + 1 &&
        state.activityState == "inProgress") {
      return PbActivityStatus.inPorgress;
    }
    var dateFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
    var nowDateTimeString = dateFormat.format(clock.now());
    if (activity.endTime.isNotEmpty &&
        _countDays(nowDateTimeString, activity.endTime.substring(0, 19)) <= 0) {
      return PbActivityStatus.ended;
    } else if (activity.startTime.isNotEmpty &&
        _countDays(nowDateTimeString, activity.startTime.substring(0, 19)) >
            0) {
      return PbActivityStatus.upcoming;
    }
    return PbActivityStatus.start;
  }

  static int _countDays(String startDate, String endDate) {
    var start = DateTime.parse(startDate);
    var end = DateTime.parse(endDate);
    return (end.difference(start).inHours / 24.0).round();
  }
}

extension PbActivityStatusExtension on PbActivityStatus {
  String get name {
    switch (this) {
      case PbActivityStatus.completed:
        return 'COMPLETED';
      case PbActivityStatus.ended:
        return 'ENDED';
      case PbActivityStatus.inPorgress:
        return 'IN-PROGRESS';
      case PbActivityStatus.missed:
        return 'MISSED';
      case PbActivityStatus.start:
        return 'START';
      case PbActivityStatus.upcoming:
        return 'UPCOMING';
    }
  }

  Color get badgeBackground {
    switch (this) {
      case PbActivityStatus.completed:
        return Colors.green.shade800;
      case PbActivityStatus.missed:
        return Colors.red.shade50;
      case PbActivityStatus.start:
        return Colors.blue.shade50;
      case PbActivityStatus.ended:
        return Colors.red.shade800;
      case PbActivityStatus.inPorgress:
        return Colors.green.shade50;
      case PbActivityStatus.upcoming:
        return Colors.yellow.shade100;
    }
  }

  Color get badgeText {
    switch (this) {
      case PbActivityStatus.completed:
        return Colors.white;
      case PbActivityStatus.missed:
        return Colors.red.shade700;
      case PbActivityStatus.start:
        return Colors.blue.shade800;
      case PbActivityStatus.ended:
        return Colors.white;
      case PbActivityStatus.inPorgress:
        return Colors.green.shade800;
      case PbActivityStatus.upcoming:
        return Colors.grey.shade900;
    }
  }

  String? get inactiveActivityText {
    switch (this) {
      case PbActivityStatus.completed:
        return 'You have already completed this activity!';
      case PbActivityStatus.ended:
        return 'This activity has ended!';
      case PbActivityStatus.missed:
        return 'The next run of this activity is not available yet. Please try again later.';
      case PbActivityStatus.upcoming:
        return 'This activity has not started yet!';
      default:
        return null;
    }
  }
}
