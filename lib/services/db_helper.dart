import 'dart:io';

import 'package:local_storage_example/models/todoModel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String tableName = 'todoExample';

class DBHelper {
  DBHelper._();
  static final DBHelper _db = DBHelper._();
  factory DBHelper() => _db;

  // 해당 변수에 데이터 베이스 정보를 담을 것 이다.
  static Database _database;

  // 생성된 데이터베이스가 있다면 _database 를 리턴하고
  // 없다면 데이터베이스를 생성하여 리턴한다.
  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  // 데이터 베이스 초기화 함수
  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'superAwesomeDb.db');

    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute('''
        CREATE TABLE $tableName (
          id INTEGER PRIMARY KEY,
          todo TEXT,
          type TEXT,
          complete BIT )
       ''');
      },
    );
  }

  // CREATE
  createData(Todo todo) async {
    final db = await database;
    var res = await db.insert(tableName, todo.toJson());
    return res;
  }

  // READ
  getTodo(int id) async {
    final db = await database;
    var res = await db.query(tableName, where: 'id = ?', whereArgs: [id]);
    return res.isNotEmpty ? Todo.fromJson(res.first) : Null;
  }

  // READ ALL DATA
  Future<List<Todo>> getAllTodos() async {
    final db = await database;
    var res = await db.query(tableName);
    List<Todo> list =
        res.isNotEmpty ? res.map((c) => Todo.fromJson(c)).toList() : [];
    return list;
  }

  // Update Todo
  updateTodo(Todo todo) async {
    final db = await database;
    var res = await db.update(tableName, todo.toJson(),
        where: 'id = ?', whereArgs: [todo.id]);
    return res;
  }

  // Delete Todo
  deleteTodo(int id) async {
    final db = await database;
    db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  // Delete All Todos
  deleteAllTodos() async {
    final db = await database;
    db.rawDelete('DELETE FROM $tableName');
  }
}
