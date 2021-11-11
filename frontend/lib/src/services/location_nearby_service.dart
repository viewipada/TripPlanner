import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trip_planner/src/models/response/location_detail_response.dart';
import 'package:trip_planner/src/models/response/travel_nearby_response.dart';

class LocationNearbyService {
  static Future<void> getTravelNearby(String locationType) async {
    http.Response response;
    if (locationType == 'ทุกแบบ')
      response = await http.get(
          Uri.parse(
              'https://run.mocky.io/v3/6ff0efaf-838b-4d4e-83b0-6f5937dac04c'),
          headers: {"Accept": "application/json"});
    else if (locationType == 'ที่เที่ยว')
      response = await http.get(
          Uri.parse(
              'https://run.mocky.io/v3/3acb6742-cee8-447a-ac31-762eda300265'),
          headers: {"Accept": "application/json"});
    else if (locationType == 'ที่กิน')
      response = await http.get(
          Uri.parse(
              'https://run.mocky.io/v3/6b0d1f9d-cda4-4366-88e4-1cdbebf445d0'),
          headers: {"Accept": "application/json"});
    else
      response = await http.get(
          Uri.parse(
              'https://run.mocky.io/v3/75b0ec18-df52-4d52-a580-1acf26c9c087'),
          headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      List<LocationNearbyResponse> travelNearbyList;
      travelNearbyList = (json.decode(response.body) as List)
          .map((i) => LocationNearbyResponse.fromJson(i))
          .toList();
      print('${travelNearbyList[0].locationId}' +
          '\t' +
          '${travelNearbyList[0].locationName}');
    } else {
      throw Exception('Failed to load campaigns');
    }
  }
}
