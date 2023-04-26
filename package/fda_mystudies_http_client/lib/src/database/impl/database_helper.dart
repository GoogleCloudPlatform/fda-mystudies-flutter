import 'dart:developer' as developer;

import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import 'tables/db_tables.dart';

class DatabaseHelper {
  static const _dbName = 'fda_mystudies.db';
  static const _dbVersion = 2;

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
        onUpgrade: _onUpgrade,
        onOpen: _onOpen));
  }

  void _onOpen(Database db) {
    developer.log('PATH: ${db.path}');
  }

  Future _onCreate(Database db, int version) {
    developer.log('EXECUTE ON CREATE');
    Future<void> createActivityStepResponsesTable = db
        .execute('''
      CREATE TABLE IF NOT EXISTS ${DBTables.activityStepResponses} (
        ${DBTables.activityStepResponsesTable.participantStudyActivityStepId} INTEGER NOT NULL,
        ${DBTables.activityStepResponsesTable.recordedAt} DATE NOT NULL,
        ${DBTables.activityStepResponsesTable.value} TEXT,
        PRIMARY KEY (${DBTables.activityStepResponsesTable.participantStudyActivityStepId}, ${DBTables.activityStepResponsesTable.recordedAt})
      );
    ''')
        .onError((error, stackTrace) => developer.log(error.toString()))
        .whenComplete(() => developer
            .log('DATABASE ACTIVITY_STEP_RESPONSES CREATION COMPLETED'));
    Future<void> createActivityStatesTable = db
        .execute('''
      CREATE TABLE IF NOT EXISTS ${DBTables.activityStates} (
        ${DBTables.activityStatesTable.participantStudyActivityId} INTEGER NOT NULL,
        ${DBTables.activityStatesTable.recordedAt} DATE NOT NULL,
        ${DBTables.activityStatesTable.state} TEXT,
        PRIMARY KEY (${DBTables.activityStatesTable.participantStudyActivityId}, ${DBTables.activityStatesTable.recordedAt})
      );
    ''')
        .onError((error, stackTrace) => developer.log(error.toString()))
        .whenComplete(
            () => developer.log('DATABASE ACTIVITY_STATES CREATION COMPLETED'));

    return Future.wait(
            [createActivityStepResponsesTable, createActivityStatesTable])
        .then((value) => developer.log('ALL TABLE CREATION COMPLETED'));
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) {
    developer.log('EXECUTE ON UPDATE');
    Future<void> createActivityStatesTable = db
        .execute('''
      CREATE TABLE IF NOT EXISTS ${DBTables.activityStates} (
        ${DBTables.activityStatesTable.participantStudyActivityId} INTEGER NOT NULL,
        ${DBTables.activityStatesTable.recordedAt} DATE NOT NULL,
        ${DBTables.activityStatesTable.state} TEXT,
        PRIMARY KEY (${DBTables.activityStatesTable.participantStudyActivityId}, ${DBTables.activityStatesTable.recordedAt})
      );
    ''')
        .onError((error, stackTrace) => developer.log(error.toString()))
        .whenComplete(
            () => developer.log('DATABASE ACTIVITY_STATES CREATION COMPLETED'));

    return Future.wait(
            [createActivityStatesTable])
        .then((value) => developer.log('ALL TABLE UPDATES COMPLETED'));
  }
}
