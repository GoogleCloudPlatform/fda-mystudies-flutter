import 'dart:convert';

import 'package:fda_mystudies_spec/database_model/activity_step.pb.dart';
import 'package:fda_mystudies_spec/fda_mystudies_spec.dart';
import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';

import '../../database_helper.dart';
import '../../service/activity_step_storage_service.dart';
import '../../table/db_tables.dart';

@Injectable(as: ActivityStepStorageService)
class ActivityStepStorageServiceImpl implements ActivityStepStorageService {
  @override
  Future<void> upsert(ActivityStep activityStep) {
    return DatabaseHelper.shared.database.then((database) => database.insert(
        DBTables.activitySteps,
        activityStep.toProto3Json() as Map<String, dynamic>,
        conflictAlgorithm: ConflictAlgorithm.replace));
  }

  @override
  Future<List<ActivityStep>> listStepsForActivity(
      String studyId, String activityId) {
    return DatabaseHelper.shared.database.then((database) => database.query(
            DBTables.activitySteps,
            where:
                '${DBTables.activityStepsTable.studyId} = ? AND ${DBTables.activityStepsTable.activityId} = ?',
            whereArgs: [
              studyId,
              activityId
            ]).then((activityStepJsonList) => List.generate(
            activityStepJsonList.length,
            (index) => ActivityStep()
              ..fromJson(jsonEncode(activityStepJsonList[index])))));
  }
}
