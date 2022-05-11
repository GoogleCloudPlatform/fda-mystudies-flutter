import 'package:fda_mystudies_spec/database_model/activity.pb.dart';

abstract class ActivityStorageService {
  Future<void> upsert(Activity activity);

  Future<List<Activity>> listActivityForStudy(String studyId);
}
