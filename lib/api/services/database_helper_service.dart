import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:tasks_manager_forcen/api/models/task_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'tasks.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        content TEXT,
        priority TEXT,
        color TEXT,
        dueDate TEXT,
        createdAt TEXT,
        userId INTEGER
      )
    ''');
  }

  // Insérer une tâche dans la base locale
  Future<void> insertTask(TaskModel task) async {
    final db = await database;
    await db.insert(
      'tasks',
      task.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Insérer plusieurs tâches dans la base locale
  Future<void> insertTasks(List<TaskModel> tasks) async {
    final db = await database;
    for (var task in tasks) {
      await insertTask(task);
    }
  }

  // Récupérer toutes les tâches de la base locale
  Future<List<TaskModel>> getTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('tasks');

    return List.generate(maps.length, (i) {
      return TaskModel.fromJson(maps[i]);
    });
  }

  // Récupérer toutes les tâches d'un utilisateur spécifique
  Future<List<TaskModel>> getTasksByUser(int? userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tasks',
      where: 'userId = ?',
      whereArgs: [userId],
    );

    return List.generate(maps.length, (i) {
      return TaskModel.fromJson(maps[i]);
    });
  }
}
