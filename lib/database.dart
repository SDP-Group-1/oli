import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

// database table and column names
final String dbName = 'sensors';
final String columnId = '_id';
final String columnWord = 'word';
final String columnFrequency = 'frequency';

// data model class
class Reading {
  int id;
  double accelerometer_x; //id
  double accelerometer_y; //word
  double accelerometer_z; //freq
  double gyro_x;
  double gyro_y;
  double gyro_z;

  Reading();

  // convenience constructor to create a Word object
  Reading.fromMap(Map<String, dynamic> map) {
    id = map['_id'];
    double accelerometer_x = map['a_x']; //id
    double accelerometer_y = map['a_y']; //word
    double accelerometer_z = map['a_z']; //freq
    double gyro_x = map['g_x'];
    double gyro_y = map['g_y'];
    double gyro_z = map['g_z'];
  }

  // convenience method to create a Map from this Word object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'a_x': accelerometer_x,
      'a_y': accelerometer_y,
      'a_z': accelerometer_z,
      'g_x': gyro_x,
      'g_y': gyro_y,
      'g_z': gyro_z
    };
    if (id != null) {
      map['_id'] = id;
    }
    return map;
  }
}

// singleton class to manage the database
class DatabaseHelper {
  // This is the actual database filename that is saved in the docs directory.
  static final _databaseName = "sensorReadings.db";
  // Increment this version when you need to change the schema.
  static final _databaseVersion = 1;

  // Make this a singleton class.
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database.
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // open the database
  _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL string to create the database
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $dbName (
            _id INTEGER PRIMARY KEY,
            a_x REAL NOT NULL,
            a_y REAL NOT NULL,
            a_z REAL NOT NULL,
            g_x REAL NOT NULL,
            g_y REAL NOT NULL,
            g_z REAL NOT NULL
          )
          ''');
  }

  // Database helper methods:

  Future<int> insert(Reading reading) async {
    Database db = await database;
    int id = await db.insert(dbName, reading.toMap());
    return id;
  }

  Future<Reading> queryReading(int id) async {
    Database db = await database;
    List<Map> maps = await db.query(dbName,
        columns: [columnId, 'a_x', 'a_y', 'a_z', 'g_x', 'g_y', 'g_z'],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Reading.fromMap(maps.first);
    }
    return null;
  }
}
