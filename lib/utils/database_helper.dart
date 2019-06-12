import 'dart:async';
import 'dart:io';

import 'package:playground/models/student.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();

  static Database _db;

  final String studentTable = 'students';

  final String columnId = 'id';
  final String columnFirstName = 'firstName';
  final String columnLastName = 'lastName';
  final String columnContactNumber = 'contactNumber';

  factory DatabaseHelper() => _instance;

  DatabaseHelper.internal();

  Future<Database> get db async {
    if (_db == null) {
      _db = await initDB();
    }
    return _db;
  }

  Future<int> deleteRecord(int id) async {
    var dbClient = await db;
    return await dbClient
        .delete(studentTable, where: "$columnId = ?", whereArgs: [id]);
  }

  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(
        await dbClient.rawQuery("SELECT COUNT(*) FROM $studentTable"));
  }

  Future<Student> getStudentRecord(int id) async {
    var dbClient = await db;
    List<Map<String, dynamic>> result = await dbClient
        .rawQuery("SELECT * FROM $studentTable WHERE $columnId = $id");
    if (result.length == 0) {
      return null;
    }
    return Student.fromMap(result.first);
  }

  Future<List> getStudentRecords() async {
    var dbClient = await db;
    return dbClient.rawQuery("SELECT * FROM $studentTable");
  }

  initDB() async {
    // get location of the database
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    // db path
    String path = join(documentDirectory.path, 'students.db');
    // storing the database in ourDB variable
    var ourDB = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDB;
  }

  Future<int> saveStudent(Student student) async {
    var dbClient = await db;
    int result = await dbClient.insert("$studentTable", student.toMap());
    return result;
  }

  Future<int> updateRecord(Student student) async {
    var dbClient = await db;
    return await dbClient.update("$studentTable", student.toMap(),
        where: "$columnId = ?", whereArgs: [student.id]);
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $studentTable ($columnId INTEGER PRIMARY KEY, $columnFirstName TEXT, $columnLastName TEXT, $columnContactNumber TEXT)");
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
