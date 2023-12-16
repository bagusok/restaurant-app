import 'package:path/path.dart';
import 'package:restaurant_app/data/model/list_restaurant.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  static late Database _database;

  DatabaseHelper._internal() {
    _databaseHelper = this;
  }

  factory DatabaseHelper() => _databaseHelper ?? DatabaseHelper._internal();

  Future<Database> get database async {
    _database = await _initializeDb();
    return _database;
  }

  static const String _tableName = 'favorite_restaurant';

  Future<Database> _initializeDb() async {
    var path = await getDatabasesPath();
    var db = openDatabase(
      join(path, 'restaurant.db'),
      onCreate: (db, version) async {
        await db.execute(
          '''CREATE TABLE $_tableName (
             id PRIMARY KEY UNIQUE NOT NULL,
              restaurant_id TEXT, name TEXT, pictureId TEXT, city TEXT, rating DOUBLE
             )''',
        );
      },
      version: 1,
    );

    return db;
  }

  Future<void> insertRestaurant(RestaurantElement restaurant) async {
    final Database db = await database;
    await db.rawQuery('''
      INSERT INTO $_tableName (id, name, pictureId, city, rating)
      VALUES (?, ?, ?, ?, ?)
    ''', [
      restaurant.id,
      restaurant.name,
      restaurant.pictureId,
      restaurant.city,
      restaurant.rating,
    ]);
  }

  Future<List<RestaurantElement>> getRestaurants() async {
    final Database db = await database;
    List<Map<String, dynamic>> results = await db.query(_tableName);
    var a = results
        .map(
          (res) => RestaurantElement(
              id: res['id'] ?? "",
              name: res['name'] ?? "",
              description: res["description"] ?? "",
              pictureId: res["pictureId"] ?? "",
              city: res["city"] ?? "",
              rating: 0.0),
        )
        .toList();
    if (a.isEmpty) {
      return [];
    } else {
      return a;
    }
  }

  Future<Map<String, dynamic>> getRestaurantById(String id) async {
    final Database db = await database;
    List<Map<String, dynamic>> results = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    return results.first;
  }

  Future<void> removeRestaurant(String id) async {
    final db = await database;
    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
