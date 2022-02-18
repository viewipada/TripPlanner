import 'package:trip_planner/src/models/trip.dart';
import 'package:trip_planner/src/repository/database.dart';

class TripsOperations {
  late TripsOperations tripsOperations;

  final dbProvider = DatabaseRepository.instance;

  Future<int> createTrip(Trip trip) async {
    final db = await dbProvider.database;
    final tripId = db!.insert('trips', trip.toMap()).then((value) => value);
    return Future.value(tripId);
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

  Future<List<Trip>> getAllTrips() async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> allRows = await db!.query('trips');
    List<Trip> trips = allRows.map((trip) => Trip.fromMap(trip)).toList();
    print(trips);
    return trips;
  }
}
