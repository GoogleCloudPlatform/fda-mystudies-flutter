import 'package:fda_mystudies_spec/study_datastore_service/get_eligibility_and_consent.pb.dart';
import 'package:flutter/material.dart';

class EligibilityConsentProvider extends ChangeNotifier {
  GetEligibilityAndConsentResponse_Eligibility? _eligibility;
  GetEligibilityAndConsentResponse_Consent? _consent;

  String? _firstName;
  String? _lastName;
  String? _selectedSharingOption;
  List<Offset>? _signaturePoints;

  EligibilityConsentProvider(
      {GetEligibilityAndConsentResponse_Eligibility? eligibility,
      GetEligibilityAndConsentResponse_Consent? consent,
      String? firstName,
      String? lastName,
      String? selectedSharingOption,
      List<Offset>? signaturePoints}) {
    _eligibility =
        eligibility ?? GetEligibilityAndConsentResponse_Eligibility();
    _consent = consent ?? GetEligibilityAndConsentResponse_Consent();
    _firstName = firstName ?? '';
    _lastName = lastName ?? '';
    _selectedSharingOption = selectedSharingOption ?? '';
    _signaturePoints = signaturePoints ?? [];
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

  void updateUserInfo(
      {String? firstName,
      String? lastName,
      String? selectedSharingOption,
      List<Offset>? signaturePoints}) {
    if (firstName != null) {
      _firstName = firstName;
    }
    if (lastName != null) {
      _lastName = lastName;
    }
    if (selectedSharingOption != null) {
      _selectedSharingOption = selectedSharingOption;
    }
    if (signaturePoints != null) {
      _signaturePoints = signaturePoints;
    }
    notifyListeners();
  }

  GetEligibilityAndConsentResponse_Eligibility get eligibility =>
      _eligibility ?? GetEligibilityAndConsentResponse_Eligibility();
  GetEligibilityAndConsentResponse_Consent get consent =>
      _consent ?? GetEligibilityAndConsentResponse_Consent();
  String get firstName => _firstName ?? '';
  String get lastName => _lastName ?? '';
  String get selectedSharingOption => _selectedSharingOption ?? '';
  List<Offset> get signaturePoints => _signaturePoints ?? [];
}
