import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DatabaseRepository {
  DatabaseRepository.privateConstructor();

  static final DatabaseRepository instance =
      DatabaseRepository.privateConstructor();

  final _databaseName = 'userTripDB';
  final _databaseVersion = 1;

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) {
      return _database!;
    } else {
      return _database = await _initDatabase();
    }
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: await onCreate);
  }

  Future onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE tripitem (
            itemId INTEGER PRIMARY KEY AUTOINCREMENT,
            day INT NOT NULL,
            no INT NOT NULL,
            locationId INT NOT NULL,
            locationCategory STRING NOT NULL,
            locationName STRING NOT NULL,
            imageUrl STRING NOT NULL,
            latitude DOUBLE NOT NULL,
            longitude DOUBLE NOT NULL,
            startTime DATETIME,
            distance DOUBLE,
            duration INT NOT NULL,
            drivingDuration INT,
            note STRING,
            FK_tripItem_trip INT NOT NULL,
            FOREIGN KEY (FK_tripItem_trip) REFERENCES trips (tripId)

          )
          ''');

    await db.execute('''
          CREATE TABLE trips (
            tripId INTEGER PRIMARY KEY AUTOINCREMENT,
            tripName STRING NOT NULL,
            trumbnail STRING,
            vehicle STRING,
            firstLocation STRING NOT NULL,
            lastLocation STRING NOT NULL,
            totalPeople INT NOT NULL,
            totalDay INT NOT NULL,
            totalTripItem INT NOT NULL,
            startDate DATETIME,
            status STRING NOT NULL
          )
          ''');
  }
}
