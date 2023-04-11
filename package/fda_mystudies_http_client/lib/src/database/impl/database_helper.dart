import 'dart:developer' as developer;

import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import 'tables/db_tables.dart';

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

    return Future.wait([createActivityStepResponsesTable])
        .then((value) => developer.log('ALL TABLE CREATION COMPLETED'));
  }
}
