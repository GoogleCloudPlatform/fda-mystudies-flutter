import 'dart:developer' as developer;

import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import 'table/db_tables.dart';

class DatabaseHelper {
  static const _dbName = 'fda_mystudies.db';
  static const _dbVersion = 1;

  DatabaseHelper._init();
  static final DatabaseHelper shared = DatabaseHelper._init();

  static Database? _database;
  Future<Database> get database {
    if (_database != null) {
      return Future.value(_database);
    }
    return initDatabase();
  }

  Future<Database> initDatabase() {
    return getDatabasesPath().then((dbPath) => openDatabase(
        p.join(dbPath, _dbName),
        version: _dbVersion,
        onCreate: _onCreate,
        onOpen: _onOpen));
  }

  void _onOpen(Database db) {
    developer.log('PATH: ${db.path}');
  }

  Future _onCreate(Database db, int version) {
    developer.log('EXECUTE ON CREATE');

    Future<void> createStudiesTable = db
        .execute('''
      CREATE TABLE IF NOT EXISTS ${DBTables.studies} (
        ${DBTables.studiesTable.id} TEXT PRIMARY KEY,
        ${DBTables.studiesTable.title} TEXT NOT NULL,
        ${DBTables.studiesTable.version} TEXT NOT NULL,
        ${DBTables.studiesTable.status} TEXT NOT NULL
      );
      ''')
        .onError((error, stackTrace) => developer.log(error.toString()))
        .whenComplete(
            () => developer.log('DATABASE STUDIES CREATION COMPLETED'));

    Future<void> createActivitiesTable = db
        .execute('''
      CREATE TABLE IF NOT EXISTS ${DBTables.activities} (
        ${DBTables.activitiesTable.studyId} TEXT NOT NULL,
        ${DBTables.activitiesTable.id} TEXT NOT NULL,
        ${DBTables.activitiesTable.title} TEXT NOT NULL,
        ${DBTables.activitiesTable.version} TEXT NOT NULL,
        ${DBTables.activitiesTable.type} TEXT NOT NULL,
        ${DBTables.activitiesTable.startTime} DATETIME,
        ${DBTables.activitiesTable.endTime} DATETIME,
        ${DBTables.activitiesTable.state} TEXT NOT NULL,
        ${DBTables.activitiesTable.frequency} TEXT NOT NULL,
        PRIMARY KEY(${DBTables.activitiesTable.studyId}, ${DBTables.activitiesTable.id})
      );
      ''')
        .onError((error, stackTrace) => developer.log(error.toString()))
        .whenComplete(
            () => developer.log('DATABASE ACTIVITIES CREATION COMPLETED'));

    Future<void> createActivityStepsTable = db
        .execute('''
      CREATE TABLE IF NOT EXISTS ${DBTables.activitySteps} (
        ${DBTables.activityStepsTable.studyId} TEXT NOT NULL,
        ${DBTables.activityStepsTable.activityId} TEXT NOT NULL,
        ${DBTables.activityStepsTable.id} TEXT NOT NULL,
        ${DBTables.activityStepsTable.version} TEXT NOT NULL,
        ${DBTables.activityStepsTable.title} TEXT NOT NULL,
        ${DBTables.activityStepsTable.text} TEXT,
        ${DBTables.activityStepsTable.skippable} INTEGER NOT NULL,
        ${DBTables.activityStepsTable.stepType} TEXT NOT NULL,
        ${DBTables.activityStepsTable.resultType} TEXT NOT NULL,
        ${DBTables.activityStepsTable.destinations} TEXT NOT NULL,
        ${DBTables.activityStepsTable.format} TEXT NOT NULL,
        PRIMARY KEY(${DBTables.activityStepsTable.studyId}, ${DBTables.activityStepsTable.activityId}, ${DBTables.activityStepsTable.id})
      );
      ''')
        .onError((error, stackTrace) => developer.log(error.toString()))
        .whenComplete(
            () => developer.log('DATABASE ACTIVITY_STEPS CREATION COMPLETED'));

    Future<void> createActivityStepResponsesTable = db
        .execute('''
      CREATE TABLE IF NOT EXISTS ${DBTables.activityStepResponses} (
        ${DBTables.activityStepResponsesTable.participantStudyActivityStepId} INTEGER NOT NULL,
        ${DBTables.activityStepResponsesTable.recordedAt} DATE NOT NULL,
        ${DBTables.activityStepResponsesTable.value} TEXT
      );
    ''')
        .onError((error, stackTrace) => developer.log(error.toString()))
        .whenComplete(() => developer
            .log('DATABASE ACTIVITY_STEP_RESPONSES CREATION COMPLETED'));

    return Future.wait([
      createStudiesTable,
      createActivitiesTable,
      createActivityStepsTable,
      createActivityStepResponsesTable
    ]).then((value) => developer.log('ALL TABLE CREATION COMPLETED'));
  }
}
