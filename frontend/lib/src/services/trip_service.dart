import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:trip_planner/src/models/trip.dart';
import 'package:trip_planner/src/models/trip_item.dart';
import 'package:trip_planner/src/repository/shared_pref.dart';

class TripService {
  final String baseUrl = 'https://eztrip-backend.herokuapp.com';

  Future<int?> endTrip(Trip trip, List<TripItem> tripItems) async {
    final userId = await SharedPref().getUserId();
    if (userId != null) {
      final body = jsonEncode(<String, dynamic>{
        "userId": userId,
        "name": trip.tripName,
        "totalPeople": trip.totalPeople,
        "totalDay": trip.totalDay,
        "startDate": DateTime.parse(DateFormat('yyyy-MM-dd')
                .format(DateFormat('dd/MM/yyyy').parse(trip.startDate!)))
            .toString(),
        "firstLocation": trip.firstLocation,
        "lastLocation": trip.lastLocation,
        "thumnail": trip.trumbnail,
        "status": 'finished',
        "tripItem": tripItems
            .map((item) => <String, dynamic>{
                  "tripId": null,
                  "day": item.day,
                  "order": item.no,
                  "locationId": item.locationId,
                  "locationName": item.locationName,
                  "imageUrl": item.imageUrl,
                  "lat": item.latitude,
                  "lng": item.longitude,
                  "locationCategory": item.locationCategory == "ที่เที่ยว"
                      ? 1
                      : item.locationCategory == "ที่กิน"
                          ? 2
                          : 3,
                  "startTime": DateTime.parse(item.startTime!).toString(),
                  "distance": item.distance,
                  "duration": item.duration,
                  "drivingDuration": item.drivingDuration,
                  "note": item.note ?? ""
                })
            .toList()
      });

      final response = await http.post(
        Uri.parse("${baseUrl}/api/trips/"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body,
      );

      if (response.statusCode == 201) {
        return response.statusCode;
      } else {
        return response.statusCode;
      }
    } else
      print('can not create trip');
    return null;
  }
}
