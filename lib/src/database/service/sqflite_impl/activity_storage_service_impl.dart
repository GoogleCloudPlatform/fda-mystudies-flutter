import 'dart:convert';

import 'package:fda_mystudies_spec/database_model/activity.pb.dart';
import 'package:fda_mystudies_spec/fda_mystudies_spec.dart';
import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';

import '../../database_helper.dart';
import '../../service/activity_storage_service.dart';
import '../../table/db_tables.dart';

@Injectable(as: ActivityStorageService)
class ActivityStorageServiceImpl implements ActivityStorageService {
  @override
  Future<void> upsert(Activity activity) {
    return DatabaseHelper.shared.database.then((database) => database.insert(
        DBTables.activities, activity.toProto3Json() as Map<String, dynamic>,
        conflictAlgorithm: ConflictAlgorithm.replace));
  }

  @override
  Future<List<Activity>> listActivityForStudy(String studyId) {
    return DatabaseHelper.shared.database.then((database) => database.query(
            DBTables.activities,
            where: '${DBTables.activitiesTable.studyId} = ?',
            whereArgs: [
              studyId
            ]).then((activityJsonList) => List.generate(
            activityJsonList.length,
            (index) =>
                Activity()..fromJson(jsonEncode(activityJsonList[index])))));
  }
}
