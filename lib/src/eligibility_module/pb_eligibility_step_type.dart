enum PbEligibilityStepType { token, test, combined, unknown }

extension EligibilityStepTypeStringExtension on String {
  PbEligibilityStepType get eligibilityStepType {
    return PbEligibilityStepType.values.firstWhere(
        (e) => e.toString().split('.').last == this,
        orElse: () => PbEligibilityStepType.unknown);
  }
}
