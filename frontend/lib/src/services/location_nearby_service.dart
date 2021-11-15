import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:trip_planner/src/models/response/travel_nearby_response.dart';

class LocationNearbyService {
  Future<List<LocationNearbyResponse>> getLocationNearby(
      String category, LocationData userLocation) async {
    http.Response response;
    if (category == 'ทุกแบบ')
      response = await http.get(
          Uri.parse(
              'https://run.mocky.io/v3/30dc4a2f-72d3-4ed4-aa8d-af38dcdc7825'),
          headers: {"Accept": "application/json"});
    else if (category == 'ที่เที่ยว')
      response = await http.get(
          Uri.parse(
              'https://run.mocky.io/v3/0445b3a8-8fe2-4add-9b10-24a33b70ab54'),
          headers: {"Accept": "application/json"});
    else if (category == 'ที่กิน')
      response = await http.get(
          Uri.parse(
              'https://run.mocky.io/v3/21a496a2-b45d-4e96-9cb3-7e131d787ac2'),
          headers: {"Accept": "application/json"});
    else
      response = await http.get(
          Uri.parse(
              'https://run.mocky.io/v3/bc9363fa-6155-4bc9-a482-46ddcc4b98d3'),
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
