import 'package:flutter/material.dart';

enum PbStudyEnrollmentStatus { active, paused, closed }

extension PbStudyStatusStringExtension on String {
  PbStudyEnrollmentStatus? get studyStatus {
    if (this == 'Active') {
      return PbStudyEnrollmentStatus.active;
    } else if (this == 'Paused') {
      return PbStudyEnrollmentStatus.paused;
    } else if (this == 'Closed') {
      return PbStudyEnrollmentStatus.closed;
    }
    return null;
  }
}

extension PbStudyStatusExtension on PbStudyEnrollmentStatus {
  Color get color {
    switch (this) {
      case PbStudyEnrollmentStatus.active:
        return Colors.green;
      case PbStudyEnrollmentStatus.paused:
        return Colors.yellow;
      case PbStudyEnrollmentStatus.closed:
        return Colors.red;
      default:
        return Colors.black;
    }
  }
}
