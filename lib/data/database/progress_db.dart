import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ProgressDatabase {
  static final ProgressDatabase instance = ProgressDatabase._init();
  static Database? _database;

  ProgressDatabase._init();

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

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE progress (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        realm TEXT NOT NULL,
        score INTEGER NOT NULL,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');
  }

  Future<void> insertProgress(String realm, int score) async {
    final db = await instance.database;
    await db.insert('progress', {'realm': realm, 'score': score});
  }

  Future<List<Map<String, dynamic>>> getProgress() async {
    final db = await instance.database;
    return db.query('progress', orderBy: 'id DESC');
  }
}
