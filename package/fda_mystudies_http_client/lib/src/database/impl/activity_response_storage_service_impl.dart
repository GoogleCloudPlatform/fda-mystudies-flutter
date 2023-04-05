import 'dart:convert';
import 'dart:developer' as developer;

import 'package:fda_mystudies_spec/database_model/activity_response.pb.dart';
import 'package:fda_mystudies_spec/fda_mystudies_spec.dart';
import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';

import 'database_helper.dart';
import '../activity_response_storage_service.dart';
import 'tables/db_tables.dart';

@Injectable(as: ActivityResponseStorageService)
class ActivityResponseStorageServiceImpl
    implements ActivityResponseStorageService {
  @override
  Future<void> upsert(
      {required String participantId,
      required String studyId,
      required String activityId,
      required String stepKey,
      required DateTime recordedAt,
      required String value}) {
    final participantStudyActivityStepId =
        '$studyId$activityId$stepKey$participantId'.hashCode;
    return DatabaseHelper.shared.database.then((database) => database
            .insert(
                DBTables.activityStepResponses,
                (ActivityResponse.create()
                      ..participantStudyActivityStepId =
                          participantStudyActivityStepId
                      ..recordedAt = recordedAt.toIso8601String()
                      ..value = value)
                    .toProto3Json() as Map<String, dynamic>,
                conflictAlgorithm: ConflictAlgorithm.replace)
            .onError((error, stackTrace) {
          developer.log('ERROR : ${error.toString()}');
          return Future.value(0);
        }).whenComplete(() => developer.log('SAVED : ')));
  }

  @override
  Future<List<ActivityResponse>> list(
      {required String participantId,
      required String studyId,
      required String activityId,
      required String stepKey}) {
    final participantStudyActivityStepId =
        '$studyId$activityId$stepKey$participantId'.hashCode;
    return DatabaseHelper.shared.database.then((database) => database
        .query(DBTables.activityStepResponses,
            where:
                '${DBTables.activityStepResponsesTable.participantStudyActivityStepId} = ?',
            whereArgs: [participantStudyActivityStepId],
            orderBy: '${DBTables.activityStepResponsesTable.recordedAt} ASC')
        .then((activityResponseJsonList) => List.generate(
            activityResponseJsonList.length,
            (index) => ActivityResponse()
              ..fromJson(jsonEncode(activityResponseJsonList[index])))));
  }
}
