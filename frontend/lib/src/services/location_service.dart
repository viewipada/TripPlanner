import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trip_planner/src/models/response/location_detail_response.dart';

class LocationService {
  Future<LocationDetailResponse> getLocationDetailById(int locationId) async {
    final response = await http.get(Uri.parse(
        // "https://run.mocky.io/v3/c83fb4de-baa2-44d3-abbe-452f791838e2"
        'http://10.0.2.2:8080/api/locations/${locationId}'));
    // print(response.body);
    if (response.statusCode == 200) {
      var data = LocationDetailResponse.fromJson(json.decode(response.body));
      // print(data);
      return data;
    } else {
      throw Exception("can not fetch data hot location");
    }
  }
}
