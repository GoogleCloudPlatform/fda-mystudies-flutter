import 'model/activity_response.dart';

abstract class UserActivitiesJourney {
  Future<Object> getActivityListWithCurrentState();

  Future<Object> fetchActivitySteps({String activityId});

  Future<Object> submitResponses({ActivityResponse response, bool? upload});

  Future<Object> getDashboardData();
}
