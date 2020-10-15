import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:todo_app/model/todo.dart';

class DbHelper {
  String tblTodo = 'todo';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colPriority = 'priority';
  String colDate = 'date';

  static final DbHelper _dbHelper = new DbHelper.internal();

  DbHelper.internal();

  factory DbHelper() {
    return _dbHelper;
  }

  Database _db;

  Future<Database> get db async {
    if (this._db == null) {
      _db = await initializaDb();
    }

    return this._db;
  }

  Future<Database> initializaDb() async {
    Directory dir = await getApplicationDocumentsDirectory();

    String path = dir.path + "todos.db";

    var dbTodos = await openDatabase(path, version: 1, onCreate: _createDb);

    return dbTodos;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        "CREATE TABLE $tblTodo ($colId INTEGER PRIMARY KEY, $colTitle TEXT, " +
            "$colDescription TEXT, $colPriority INTEGER, $colDate TEXT)");
  }

  Future<int> insertTodo(Todo todo) async {
    Database db = await this.db;
    return await db.insert(tblTodo, todo.toMap());
  }

  Future<List> getTodos() async {
    Database db = await this.db;

    return await db.rawQuery("Select * from $tblTodo");
  }

  Future<int> getCount() async {
    Database db = await this.db;

    return Sqflite.firstIntValue(
        await db.rawQuery("Select count(*) from $tblTodo"));
  }

  Future<int> updateTodo(Todo todo) async {
    var db = await this.db;

    var result = await db.update(this.tblTodo, todo.toMap(),
        where: "$colId = ?", whereArgs: [todo.id]);

    return result;
  }

  Future<int> deleteTodo(int id) async {
    var db = await this.db;
    return await db.rawDelete('DELETE FROM $tblTodo WHERE $colId = $id');
  }
}
