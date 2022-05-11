import 'activities_table.dart';
import 'activity_step_responses_table.dart';
import 'activity_steps_table.dart';
import 'studies_table.dart';

class DBTables {
  static const studies = 'Studies';
  static const activities = 'Activities';
  static const activitySteps = 'ActivitySteps';
  static const activityStepResponses = 'ActivityStepResponses';

  static StudiesTable studiesTable = StudiesTable();
  static ActivitiesTable activitiesTable = ActivitiesTable();
  static ActivityStepsTable activityStepsTable = ActivityStepsTable();
  static ActivityStepResponsesTable activityStepResponsesTable =
      ActivityStepResponsesTable();
}
