import 'package:trip_planner/src/models/trip.dart';
import 'package:trip_planner/src/repository/database.dart';
import 'package:trip_planner/src/repository/shared_pref.dart';

class TripsOperations {
  late TripsOperations tripsOperations;

  final dbProvider = DatabaseRepository.instance;

  Future<int> createTrip(Trip trip) async {
    final db = await dbProvider.database;
    final tripId = db!.insert('trips', trip.toMap());
    return tripId;
  }

  updateTrip(Trip trip) async {
    final db = await dbProvider.database;
    db!.update('trips', trip.toMap(),
        where: "tripId=?", whereArgs: [trip.tripId]);
  }

  deleteTrip(Trip trip) async {
    final db = await dbProvider.database;
    await db!.delete('trips', where: 'tripId=?', whereArgs: [trip.tripId]);
  }

  // Future<Trip?> getTripById(int tripId) async {
  //   final db = await dbProvider.database;
  //   List<Map<String, dynamic>> row =
  //       await db!.query('trips', where: "tripId=?", whereArgs: [tripId]);
  //   if (row.length > 0) {
  //     Trip trip = row.map((trip) => Trip.fromMap(trip)).first;
  //     return trip;
  //   }
  //   return null;
  // }

  Future<Trip> getTripById(int tripId) async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> row =
        await db!.query('trips', where: "tripId=?", whereArgs: [tripId]);
    Trip trip = row.map((trip) => Trip.fromMap(trip)).first;
    return trip;
  }

  Future<List<Trip>> getAllTrips() async {
    var userId = await SharedPref().getUserId();
    final db = await dbProvider.database;
    if (userId == null)
      return [];
    else {
      List<Map<String, dynamic>> allRows = await db!.query('trips',
          where: "userId=?", whereArgs: [userId], orderBy: "tripId DESC");
      List<Trip> trips = allRows.map((trip) => Trip.fromMap(trip)).toList();

      return trips;
    }
  }
}
