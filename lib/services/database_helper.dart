import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'parking_registry.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE parking_registrations(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        firstName TEXT,
        lastName TEXT,
        email TEXT,
        telephone TEXT,
        licensePlate TEXT,
        startDate TEXT,
        numberOfNights INTEGER,
        nightsRemaining INTEGER,
        registrationDate TEXT
      )
    ''');
  }

  Future<int> insertRegistration(User user) async {
    final db = await database;
    return await db.insert(
      'parking_registrations',
      {
        'firstName': user.firstName,
        'lastName': user.lastName,
        'email': user.email,
        'telephone': user.telephone,
        'licensePlate': user.licencePlate,
        'startDate': user.startDate?.toIso8601String(),
        'numberOfNights': user.numberOfNights,
        'nightsRemaining': user.nightsRemaining,
        'registrationDate': DateTime.now().toIso8601String(),
      },
    );
  }

  Future<List<Map<String, dynamic>>> getRegistrations(String email) async {
    final db = await database;
    return await db.query(
      'parking_registrations',
      where: 'email = ?',
      whereArgs: [email],
      orderBy: 'registrationDate DESC',
    );
  }

  Future<int> getRemainingNights(String email) async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT SUM(numberOfNights) as usedNights 
      FROM parking_registrations 
      WHERE email = ?
    ''', [email]);

    int usedNights = result.first['usedNights'] as int? ?? 0;
    return 15 - usedNights; // 15 is the total allowed nights
  }
}
