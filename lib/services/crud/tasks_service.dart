import 'dart:async';
import 'package:flutter/material.dart';
import 'package:todolist/extensions/list/filter.dart';
import 'package:todolist/services/crud/crud_exceptions.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;

class TasksService {
  Database? _db;

  List<DataBaseTask> _tasks = [];

  DataBaseUser? _user;

  static final TasksService _shared = TasksService._sharedInstance();
  // upon adding a listener to the stream the stream will take the information from the listeners and adds it the stream
  TasksService._sharedInstance() {
    _tasksStreamController =
        StreamController<List<DataBaseTask>>.broadcast(onListen: () {
      _tasksStreamController.sink.add(_tasks);
    });
  }
  factory TasksService() => _shared;

  // creates a pipe of information that other people can recieve from not add, information retrieved will be of the type <List<DataBaseTask>>
  late final StreamController<List<DataBaseTask>> _tasksStreamController;

  Stream<List<DataBaseTask>> get allTasks =>
      _tasksStreamController.stream.filter((task) {
        final currentUser = _user;
        if (currentUser != null) {
          return task.userId == currentUser.id;
        } else {
          throw UserShouldBeSetBeforeReadingAllTasks();
        }
      });

  Future<DataBaseUser> getOrCreateUser({
    required String email,
    bool setAsCurrentUser = true,
  }) async {
    try {
      final user = await getUser(email: email);
      if (setAsCurrentUser) {
        _user = user;
      }
      return user;
    } on CouldNotFindUser {
      final createdUser = await createUser(email: email);
      if (setAsCurrentUser) {
        _user = createdUser;
      }
      return createdUser;
    } catch (e) {
      rethrow;
    }
  }

  // adds all tasks to the "_tasksStreamController" Stream
  Future<void> _cacheTasks() async {
    final allTasks = await getAllTasks();
    _tasks = allTasks.toList();
    _tasksStreamController.add(_tasks);
  }

  Future<DataBaseTask> updateTask({
    required DataBaseTask task,
    required String text,
  }) async {
    await _ensureDbIsOpern();
    final db = _getDatabaseOrThrow();

    // checks if the task does exist
    await getTask(id: task.id);

    final updatesCount = await db.update(
      taskTable,
      {textColumn: text, deadlineColumn: task.deadline},
      where: 'id = ?',
      whereArgs: [task.id],
    );

    if (updatesCount == 0) {
      throw CouldNotUpdateTask();
    } else {
      final updatedTask = await getTask(id: task.id);
      _tasks.removeWhere((task) => task.id == updatedTask.id);
      _tasks.add(updatedTask);
      _tasksStreamController.add(_tasks);
      return updatedTask;
    }
  }

  Future<Iterable<DataBaseTask>> getAllTasks() async {
    await _ensureDbIsOpern();
    final db = _getDatabaseOrThrow();
    final tasks = await db.query(taskTable);

    return tasks.map((taskRow) => DataBaseTask.fromRow(taskRow));
  }

  Future<DataBaseTask> getTask({required int id}) async {
    await _ensureDbIsOpern();
    final db = _getDatabaseOrThrow();
    final tasks = await db.query(
      taskTable,
      limit: 1,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (tasks.isEmpty) {
      throw CouldNotFindTask();
    } else {
      // returns an instance of DataBaseTask with the first info returned from 'db.query'
      final task = DataBaseTask.fromRow(tasks.first);
      // delete the previously recorded task incase it was out dated
      _tasks.removeWhere((task) => task.id == id);
      // adds it back uptodate to the list
      _tasks.add(task);
      _tasksStreamController.add(_tasks);
      return task;
    }
  }

  Future<int> deleteAllTasks() async {
    await _ensureDbIsOpern();
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(taskTable);
    _tasks = [];
    _tasksStreamController.add(_tasks);
    return deletedCount;
  }

  Future<void> deleteTask({required int id}) async {
    await _ensureDbIsOpern();
    final db = _getDatabaseOrThrow();

    final deletedCount = await db.delete(
      taskTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (deletedCount == 0) {
      throw CouldNotDeleteTask();
    } else {
      _tasks.removeWhere((task) => task.id == id);
      _tasksStreamController.add(_tasks);
    }
  }

  Future<DataBaseTask> createTask({required DataBaseUser owner}) async {
    await _ensureDbIsOpern();
    final db = _getDatabaseOrThrow();

    // makes sure that the user exists in the database
    final dbUser = await getUser(email: owner.email);
    if (dbUser != owner) {
      throw CouldNotFindUser();
    }

    const text = '';
    // create a task
    final taskId = await db.insert(taskTable, {
      userIdColumn: owner.id,
      textColumn: text,
    });

    final task = DataBaseTask(
      id: taskId,
      userId: owner.id,
      text: text,
      deadline: DateTime.now().add(const Duration(days: 1)).toIso8601String(),
    );

    _tasks.add(task);
    _tasksStreamController.add(_tasks);

    return task;
  }

  Future<DataBaseUser> getUser({required String email}) async {
    await _ensureDbIsOpern();
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (results.isEmpty) {
      throw CouldNotFindUser();
    } else {
      // assigns the first row from the search to the class DataBaseUser
      return DataBaseUser.fromRow(results.first);
    }
  }

  Future<DataBaseUser> createUser({required String email}) async {
    await _ensureDbIsOpern();
    final db = _getDatabaseOrThrow();
    // serach to check if email already exists
    final results = await db.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (results.isNotEmpty) {
      throw UserAlreadyExists();
    }
    // insert the user's email into the db and returning the user's id
    final userId = await db.insert(
      userTable,
      {emailColumn: email.toLowerCase()},
    );

    return DataBaseUser(
      id: userId,
      email: email,
    );
  }

  Future<void> deleteUser({required String email}) async {
    await _ensureDbIsOpern();
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      userTable,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (deletedCount != 1) {
      throw CouldNotDeleteUser();
    }
  }

  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      return db;
    }
  }

  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      await db.close();
      _db = null;
    }
  }

  Future<void> _ensureDbIsOpern() async {
    try {
      await open();
    } on DatabaseAlreadyOpenException {
      // empty
    }
  }

  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    }
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;
      // create User table
      await db.execute(createUserTable);
      // create tasks table
      await db.execute(createTaskTable);
      await _cacheTasks();
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDirectory();
    }
  }
}

@immutable
class DataBaseUser {
  final int id;
  final String email;
  const DataBaseUser({
    required this.id,
    required this.email,
  });

  // create a new DataBaseUser from the information from our db
  DataBaseUser.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        email = map[emailColumn] as String;

  @override
  String toString() => 'Person, ID = $id, email = $email';

  @override
  bool operator ==(covariant DataBaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class DataBaseTask {
  final int id;
  final int userId;
  final String text;
  final String? deadline;
  DataBaseTask({
    required this.id,
    required this.userId,
    required this.text,
    required this.deadline,
  });

  DataBaseTask.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        userId = map[userIdColumn] as int,
        text = map[textColumn] as String,
        deadline = map[deadlineColumn] as String?;

  @override
  String toString() {
    return "Task, ID = $id, UserId = $userId, text = $text, deadline = $deadline";
  }

  @override
  bool operator ==(covariant DataBaseTask other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

const dbName = 'tasks.db';
const taskTable = 'task';
const userTable = 'user';
const idColumn = "id";
const emailColumn = "email";
const userIdColumn = "user_id";
const textColumn = "text";
const deadlineColumn = "deadline";
const createUserTable = '''CREATE TABLE IF NOT EXISTS "user" (
  "id"	INTEGER NOT NULL,
  "email"	TEXT NOT NULL UNIQUE,
  PRIMARY KEY("id" AUTOINCREMENT)
);''';
const createTaskTable = '''CREATE TABLE IF NOT EXISTS "task" (
  "id"	INTEGER NOT NULL,
  "user_id"	INTEGER NOT NULL,
  "text"	TEXT,
  "deadline"	TEXT,
  FOREIGN KEY("user_id") REFERENCES "user"("id"),
  PRIMARY KEY("id" AUTOINCREMENT)
);''';
