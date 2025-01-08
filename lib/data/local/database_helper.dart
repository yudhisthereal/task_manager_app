import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:task_manager_app/data/models/task.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;



  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'task_manager.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Users Table
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT UNIQUE,
        password TEXT
      )
    ''');

    // Tasks Table
    await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER NOT NULL,
        title TEXT NOT NULL,
        description TEXT,
        isCompleted INTEGER NOT NULL,
        dueDate TEXT
      )
    ''');
  }

  // CRUD methods
  Future<int> insertTask(Task task) async {
    final db = await database;
    final  Map<String, dynamic> taskMap = task.toMap();
    debugPrint('[DBHELPER INSERT] TASK ID: ${taskMap['id']}');
    return await db.insert('tasks', taskMap);
  }

  Future<List<Task>> getTasksByUser(int userId) async {
    final db = await database;
    final maps = await db.query(
      'tasks',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'isCompleted ASC'
    );

    return maps.map((map) => Task.fromMap(map)).toList();
  }

  Future<int> updateTask(Task task) async {
    debugPrint('[UPDATE TASK] TASK ID: ${task.id}');
    final db = await database;
    return await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ? and userId = ?',
      whereArgs: [task.id, task.userId]
    );
  }

  Future<int> deleteTask(int id, int userId) async {
    final db = await database;
    return await db.delete(
      'tasks',
      where: 'id = ? and userId = ?',
      whereArgs: [id, userId]
    );
  }

}
