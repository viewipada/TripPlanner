import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:trip_planner/src/models/response/travel_nearby_response.dart';

class LocationNearbyService {
  final String baseUrl = 'http://10.0.2.2:8080';

  Future<List<LocationNearbyResponse>> getLocationNearby(
      String category, LocationData userLocation) async {
    http.Response response;
    if (category == 'ทุกแบบ')
      response = await http.get(Uri.parse('${baseUrl}/api/locations/nearby/0'),
          headers: {"Accept": "application/json"});
    else if (category == 'ที่เที่ยว')
      response = await http.get(Uri.parse('${baseUrl}/api/locations/nearby/1'),
          headers: {"Accept": "application/json"});
    else if (category == 'ที่กิน')
      response = await http.get(Uri.parse('${baseUrl}/api/locations/nearby/2'),
          headers: {"Accept": "application/json"});
    else
      response = await http.get(Uri.parse('${baseUrl}/api/locations/nearby/3'),
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
