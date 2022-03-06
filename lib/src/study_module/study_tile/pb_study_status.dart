import 'package:flutter/material.dart';

enum PbStudyStatus { active, paused, closed }

extension PbStudyStatusStringExtension on String {
  PbStudyStatus? get studyStatus {
    if (this == 'Active') {
      return PbStudyStatus.active;
    } else if (this == 'Paused') {
      return PbStudyStatus.paused;
    } else if (this == 'Closed') {
      return PbStudyStatus.closed;
    }
  }
}

extension PbStudyStatusExtension on PbStudyStatus {
  Color get color {
    switch (this) {
      case PbStudyStatus.active:
        return Colors.green;
      case PbStudyStatus.paused:
        return Colors.yellow;
      case PbStudyStatus.closed:
        return Colors.red;
      default:
        return Colors.black;
    }
  }
}
