import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // Singleton pattern
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  // Get database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize database
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'user_data.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  // Create table
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE user_data(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        age INTEGER,
        bmi REAL,
        unusualBleeding INTEGER,
        numberOfIntercourse INTEGER,
        breastFeeding INTEGER,
        pregnancyNum INTEGER
        lengthOfCycle INTEGER,
      )
    ''');
  }

  // Insert data
  Future<int> insertUserData(Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert('user_data', data);
  }

  // Get all data
  Future<List<Map<String, dynamic>>> getUserData() async {
    final db = await database;
    return await db.query('user_data');
  }

  // Get last session ID
  Future<int?> getLastSessionId() async {
    final db = await database;
    final result = await db.rawQuery('SELECT MAX(id) as lastId FROM user_data');
    return result.first['lastId'] as int?;
  }

  Future<Map<String, dynamic>?> getLastSessionData() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT * FROM user_data ORDER BY id DESC LIMIT 1',
    );
    return result.isNotEmpty ? result.first : null;
  }
}
