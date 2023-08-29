import 'activity_states_table.dart';
import 'activity_step_responses_table.dart';

class DBTables {
  static const activityStepResponses = 'ActivityStepResponses';
  static const activityStates = 'ActivityStates';

  static ActivityStepResponsesTable activityStepResponsesTable =
      ActivityStepResponsesTable();
  static ActivityStatesTable activityStatesTable = ActivityStatesTable();
}
