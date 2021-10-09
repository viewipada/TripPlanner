import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trip_planner/src/models/response/location_card_response.dart';
import 'package:trip_planner/src/models/response/trip_card_response.dart';

class HomeService {
  Future<List<LocationCardResponse>> getHotLocationList() async {
    List<LocationCardResponse> hotLocationList = [];
    final response = await http.get(Uri.parse(
        "https://run.mocky.io/v3/af05f43f-50e3-4d95-a026-ec5388c5da51"));

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
    final response = await http.get(Uri.parse(
        "https://run.mocky.io/v3/af05f43f-50e3-4d95-a026-ec5388c5da51"));

    if (response.statusCode == 200) {
      var data = json.decode(response.body) as List<dynamic>;
      data
          .map((item) =>
              locationRecommendedList.add(LocationCardResponse.fromJson(item)))
          .toList();
      return locationRecommendedList;
    } else {
      throw Exception("can not fetch data location recommended");
    }
  }

  Future<List<TripCardResponse>> getTripRecommendedList() async {
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
  }
}
