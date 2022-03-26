import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trip_planner/src/models/response/location_card_response.dart';
import 'package:trip_planner/src/models/response/trip_card_response.dart';
import 'package:trip_planner/src/repository/shared_pref.dart';

class HomeService {
  final String baseUrl = 'http://10.0.2.2:8080';

  Future<List<LocationCardResponse>> getHotLocationList() async {
    List<LocationCardResponse> hotLocationList = [];
    final response = await http.get(
        Uri.parse("https://run.mocky.io/v3/af05f43f-50e3-4d95-a026-ec5388c5da51"
            // 'http://10.0.2.2:8080/api/locations/'
            ));

    if (response.statusCode == 200) {
      var data = json.decode(response.body) as List<dynamic>;
      data
          .map((location) =>
              hotLocationList.add(LocationCardResponse.fromJson(location)))
          .toList();
      return hotLocationList;
    } else {
      throw Exception("can not fetch data hot location");
    }
  }

  Future<List<LocationCardResponse>> getLocationRecommendedList() async {
    List<LocationCardResponse> locationRecommendedList = [];
    final userId = await SharedPref().getUserId();
    if (userId != null) {
      final response = await http.get(Uri.parse(
          // "https://run.mocky.io/v3/af05f43f-50e3-4d95-a026-ec5388c5da51"
          '${baseUrl}/api/locations/'));
      // print(response.statusCode);
      if (response.statusCode == 200) {
        var data = json.decode(response.body) as List<dynamic>;
        data
            .map((item) => locationRecommendedList
                .add(LocationCardResponse.fromJson(item)))
            .toList();
        return locationRecommendedList;
      } else {
        throw Exception("can not fetch data location recommended");
      }
    } else
      return [];
  }

  Future<List<TripCardResponse>> getTripRecommendedList() async {
    final userId = await SharedPref().getUserId();
    if (userId != null) {
      List<TripCardResponse> tripRecommendedList = [];
      final response = await http.get(Uri.parse(
          "https://run.mocky.io/v3/049d150b-e9ca-474d-a94e-a0825ac3d495"));

      if (response.statusCode == 200) {
        var data = json.decode(response.body) as List<dynamic>;
        data
            .map((item) =>
                tripRecommendedList.add(TripCardResponse.fromJson(item)))
            .toList();
        return tripRecommendedList;
      } else {
        throw Exception("can not fetch data trip recommended");
      }
    } else
      return [];
  }
}
