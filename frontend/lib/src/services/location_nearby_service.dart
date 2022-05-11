import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:trip_planner/src/models/response/travel_nearby_response.dart';

class LocationNearbyService {
  final String baseUrl = 'http://10.0.2.2:8080';

  Future<List<LocationNearbyResponse>> getLocationNearby(
      String category, LocationData userLocation) async {
    var catNum;
    if (category == 'ทุกแบบ')
      catNum = 0;
    else if (category == 'ที่เที่ยว')
      catNum = 1;
    else if (category == 'ที่กิน')
      catNum = 2;
    else
      catNum = 3;

    http.Response response = await http.get(
        Uri.parse(
            '${baseUrl}/api/locations/nearby/${catNum}/${userLocation.latitude}/${userLocation.longitude}'),
        headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      List<LocationNearbyResponse> travelNearbyList;
      travelNearbyList = (json.decode(response.body) as List)
          .map((i) => LocationNearbyResponse.fromJson(i))
          .toList();
      return travelNearbyList;
    } else {
      throw Exception('Failed to load campaigns');
    }
  }
}
