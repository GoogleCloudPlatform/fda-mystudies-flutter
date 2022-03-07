import 'package:fda_mystudies_spec/participant_enroll_datastore_service/get_study_state.pb.dart';
import 'package:fda_mystudies_spec/study_datastore_service/get_study_list.pb.dart';

class PbUserStudyData {
  final String studyId;
  final GetStudyListResponse_Study study;
  final GetStudyStateResponse_StudyState userState;

  PbUserStudyData(this.studyId, this.study, this.userState);
}
