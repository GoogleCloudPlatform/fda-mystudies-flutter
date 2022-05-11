import 'package:fda_mystudies_spec/database_model/activity_step.pb.dart';

abstract class ActivityStepStorageService {
  Future<void> upsert(ActivityStep activityStep);

  Future<List<ActivityStep>> listStepsForActivity(
      String studyId, String activityId);
}
