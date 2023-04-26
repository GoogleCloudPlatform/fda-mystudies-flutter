import 'dart:developer' as developer;

import 'package:fda_mystudies_spec/database_model/activity_state.pb.dart';
import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';

import 'database_helper.dart';
import '../activity_state_storage_service.dart';
import 'tables/db_tables.dart';

@Injectable(as: ActivityStateStorageService)
class ActivityStateStorageServiceImpl implements ActivityStateStorageService {
  @override
  Future<String> fetch(
      {required String participantId,
      required String studyId,
      required String activityId,
      required DateTime recordedAt}) {
    final participantStudyActivityId =
        '$studyId$activityId$participantId'.hashCode;
    return DatabaseHelper.shared.database.then((database) => database
        .query(DBTables.activityStates,
            where:
                '${DBTables.activityStatesTable.participantStudyActivityId} = ? AND ${DBTables.activityStatesTable.recordedAt} = ?',
            whereArgs: [participantStudyActivityId, recordedAt.toIso8601String()],
            limit: 1,
            columns: [DBTables.activityStatesTable.state])
        .then((activityState) {
          if (activityState.length == 1) {
            return '${activityState[0]['state']}';
          }
          return '';
        }));
  }

  @override
  Future<void> upsert(
      {required String participantId,
      required String studyId,
      required String activityId,
      required DateTime recordedAt,
      required String state}) {
    final participantStudyActivityId =
        '$studyId$activityId$participantId'.hashCode;
    return DatabaseHelper.shared.database.then((database) => database
            .insert(
                DBTables.activityStates,
                (ActivityState.create()
                      ..participantStudyActivityId = participantStudyActivityId
                      ..recordedAt = recordedAt.toIso8601String()
                      ..state = state)
                    .toProto3Json() as Map<String, dynamic>,
                conflictAlgorithm: ConflictAlgorithm.replace)
            .onError((error, stackTrace) {
          developer.log('ERROR : ${error.toString()}');
          return Future.value(0);
        }).whenComplete(() => developer.log('SAVED ACTIVITY STATE')));
  }
}
