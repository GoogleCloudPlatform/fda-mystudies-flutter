import 'package:fda_mystudies_spec/participant_enroll_datastore_service/get_study_state.pb.dart';
import 'package:fda_mystudies_spec/study_datastore_service/get_study_list.pb.dart';
import 'package:flutter/material.dart';

class UserStudyStateProvider extends ChangeNotifier {
  Map<String, GetStudyListResponse_Study?> _studyIdToStudyState = {};
  Map<String, GetStudyStateResponse_StudyState?> _studyIdToUserState = {};

  UserStudyStateProvider(
      {Map<String, GetStudyListResponse_Study?>? studyIdToStudyState,
      Map<String, GetStudyStateResponse_StudyState?>? studyIdToUserState}) {
    _studyIdToStudyState = studyIdToStudyState ?? {};
    _studyIdToUserState = studyIdToUserState ?? {};
  }

  void assignStudyState(
      String studyId, GetStudyListResponse_Study? studyState) {
    if (studyState != null) {
      _studyIdToStudyState[studyId] = studyState;
      notifyListeners();
    }
  }

  void assignUserState(
      String studyId, GetStudyStateResponse_StudyState? userState) {
    if (userState != null) {
      _studyIdToUserState[studyId] = userState;
      notifyListeners();
    }
  }

  List<String> get studyIds => _studyIdToStudyState.keys.toList();

  GetStudyListResponse_Study? studyState(String studyId) =>
      _studyIdToStudyState[studyId];

  GetStudyStateResponse_StudyState? userState(String studyId) =>
      _studyIdToUserState[studyId];
}
