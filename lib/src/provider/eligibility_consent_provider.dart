import 'package:fda_mystudies_spec/study_datastore_service/get_eligibility_and_consent.pb.dart';
import 'package:flutter/material.dart';

class EligibilityConsentProvider extends ChangeNotifier {
  GetEligibilityAndConsentResponse_Eligibility? _eligibility;
  GetEligibilityAndConsentResponse_Consent? _consent;

  EligibilityConsentProvider(
      {GetEligibilityAndConsentResponse_Eligibility? eligibility,
      GetEligibilityAndConsentResponse_Consent? consent}) {
    _eligibility =
        eligibility ?? GetEligibilityAndConsentResponse_Eligibility();
    _consent = consent ?? GetEligibilityAndConsentResponse_Consent();
  }

  void updateContent(
      {GetEligibilityAndConsentResponse_Eligibility? eligibility,
      GetEligibilityAndConsentResponse_Consent? consent}) {
    if (eligibility != null) {
      _eligibility = eligibility;
    }
    if (consent != null) {
      _consent = consent;
    }
    notifyListeners();
  }

  GetEligibilityAndConsentResponse_Eligibility get eligibility =>
      _eligibility ?? GetEligibilityAndConsentResponse_Eligibility();
  GetEligibilityAndConsentResponse_Consent get consent =>
      _consent ?? GetEligibilityAndConsentResponse_Consent();
}
