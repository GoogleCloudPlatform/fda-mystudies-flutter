import 'package:fda_mystudies_spec/database_model/study.pb.dart';

abstract class StudyStorageService {
  Future<void> upsert(Study study);

  Future<List<Study>> list();
}
