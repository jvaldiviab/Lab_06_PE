import 'package:sqflite/sqflite.dart';
import 'package:medical_visitors/models/patient.dart';

import 'package:medical_visitors/models/user.dart';
import 'package:path/path.dart';

class PatientDatabase {
  static final PatientDatabase instance = PatientDatabase._initialize();
  static Database? _database;
  PatientDatabase._initialize();

  Future _createDB(Database db, int version) async {
    final userUsernameType = 'TEXT PRIMARY KEY NOT NULL ';
    final textType = 'TEXT NOT NULL';
    final boolType = 'BOOLEAN NOT NULL';

    await db.execute('''CREATE TABLE $userTable (
        ${UserFields.username} $userUsernameType,
        ${UserFields.name} $textType
      )''');
    await db.execute('''CREATE TABLE $patientTable (
        ${PatientFields.username} $textType,
        ${PatientFields.name} $textType,
        ${PatientFields.surname} $textType,
        ${PatientFields.dateBirth} $textType,
        ${PatientFields.heights} $textType,
        ${PatientFields.title} $textType,
        ${PatientFields.done} $boolType,
        ${PatientFields.created} $textType,
        ${PatientFields.address} $textType,
        ${PatientFields.lat} $textType,
        ${PatientFields.lon} $textType,
        FOREIGN KEY (${PatientFields.username}) REFERENCES $userTable (${UserFields.username})
      )''');
  }

  Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<Database> _initDB(String filename) async {
    final databasepath = await getDatabasesPath();
    final path = join(databasepath, filename);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onConfigure: _onConfigure,
    );
  }

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    } else {
      _database = await _initDB('patient.db');
      return _database;
    }
  }

  Future close() async {
    final db = await instance.database;
    db!.close();
  }

  Future createUSer(User user) async {
    final db = await instance.database;
    db!.insert(userTable, user.toJson());
    return user;
  }

  Future<User> getUser(String username) async {
    final db = await instance.database;
    final maps = await db!.query(
      userTable,
      columns: UserFields.allFields,
      where: '${UserFields.username} =  ?',
      whereArgs: [username],
    );

    if (maps.isNotEmpty) {
      return User.fromJson(maps.first);
    } else {
      throw Exception('$username no existe en la base de datos.');
    }
  }

  Future<List<User>> getAllUsers() async {
    final db = await instance.database;
    final result =
        await db!.query(userTable, orderBy: '${UserFields.username} ASC');

    return result
        .map((e) => User.fromJson(e))
        .toList(); //iterating through every user in the list (e) and converting it into User  objects using fromjson() and to a list :)
  }

  Future<int> updateUser(User user) async {
    final db = await instance.database;
    return db!.update(
      userTable,
      user.toJson(),
      where: '${UserFields.username} = ?',
      whereArgs: [user.username],
    );
  }

  Future<int> deleteUser(String username) async {
    final db = await instance.database;
    return db!.delete(
      userTable,
      where: '${UserFields.username} = ?',
      whereArgs: [username],
    );
  }

  Future createPatient(Patient patient) async {
    final db = await instance.database;
    db!.insert(patientTable, patient.toJson());
    return patient;
  }

  Future<int> togglePatientDone(Patient patient) async {
    final db = await instance.database;
    patient.done = !patient.done;
    return db!.update(
      patientTable,
      patient.toJson(),
      where: '${PatientFields.title} = ? AND ${PatientFields.username} = ?',
      whereArgs: [patient.title, patient.username],
    );
  }

  Future<List<Patient>> getPatient(String username) async {
    final db = await instance.database;
    final result = await db!.query(
      patientTable,
      orderBy: '${PatientFields.created} DESC',
      where: '${PatientFields.username} =  ?',
      whereArgs: [username],
    );

    return result.map((e) => Patient.fromjson(e)).toList();
  }

  Future<int> deletePatient(Patient patient) async {
    final db = await instance.database;
    return db!.delete(
      patientTable,
      where: '${PatientFields.title} = ? AND ${PatientFields.username} = ? ',
      whereArgs: [patient.title, patient.username],
    );
  }
}
