import 'dart:convert';

import 'package:fda_mystudies_spec/database_model/study.pb.dart';
import 'package:fda_mystudies_spec/fda_mystudies_spec.dart';
import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';

import '../../database_helper.dart';
import '../../table/db_tables.dart';
import '../study_storage_service.dart';

@Injectable(as: StudyStorageService)
class StudyStorageServiceImpl implements StudyStorageService {
  @override
  Future<void> upsert(Study study) {
    return DatabaseHelper.shared.database.then((database) => database.insert(
        DBTables.studies, study.toProto3Json() as Map<String, dynamic>,
        conflictAlgorithm: ConflictAlgorithm.replace));
  }

  @override
  Future<List<Study>> list() {
    return DatabaseHelper.shared.database.then((database) => database
        .query(DBTables.studies)
        .then((studyJsonList) => List.generate(studyJsonList.length,
            (index) => Study()..fromJson(jsonEncode(studyJsonList[index])))));
  }
}
