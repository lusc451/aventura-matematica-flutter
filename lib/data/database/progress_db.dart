import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ProgressDB {
  static final ProgressDB instance = ProgressDB._init();
  static Database? _database;

  ProgressDB._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('progress.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE progress (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        realm TEXT NOT NULL,
        difficulty TEXT NOT NULL,
        completed INTEGER NOT NULL
      )
    ''');
  }

  Future<void> insertProgress(
    String realm,
    String difficulty,
    bool completed,
  ) async {
    final db = await instance.database;
    await db.insert('progress', {
      'realm': realm,
      'difficulty': difficulty,
      'completed': completed ? 1 : 0,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<bool> isCompleted(String realm, String difficulty) async {
    final db = await instance.database;
    final result = await db.query(
      'progress',
      where: 'realm = ? AND difficulty = ?',
      whereArgs: [realm, difficulty],
    );
    if (result.isNotEmpty) {
      return result.first['completed'] == 1;
    }
    return false;
  }
}
