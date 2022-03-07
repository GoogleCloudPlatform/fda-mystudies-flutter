enum PbUserStudyStatus {
  yetToEnroll,
  notEligible,
  enrolled,
  completed,
  withdrawn
}

extension PbUserStudyStatusStringExtension on String {
  PbUserStudyStatus get userStudyStatus {
    return PbUserStudyStatus.values.firstWhere((e) => e.toString() == this,
        orElse: () => PbUserStudyStatus.yetToEnroll);
  }
}

extension PbUserStudyStatusExtension on PbUserStudyStatus {
  String get paramValue {
    return toString();
  }

  String get description {
    switch (this) {
      case PbUserStudyStatus.yetToEnroll:
        return 'Yet to enroll';
      case PbUserStudyStatus.notEligible:
        return 'Not eligible';
      case PbUserStudyStatus.enrolled:
        return 'Enrolled';
      case PbUserStudyStatus.completed:
        return 'Completed';
      case PbUserStudyStatus.withdrawn:
        return 'Withdrawn';
    }
  }
}
