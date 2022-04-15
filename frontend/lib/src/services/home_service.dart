import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trip_planner/src/models/response/location_card_response.dart';
import 'package:trip_planner/src/models/response/other_trip_response.dart';
import 'package:trip_planner/src/models/response/trip_card_response.dart';
import 'package:trip_planner/src/repository/shared_pref.dart';

class HomeService {
  final String baseUrl = 'http://10.0.2.2:8080';
  final String recommendUrl = 'https://travel-planning-ceproject.herokuapp.com';

  Future<List<LocationCardResponse>> getHotLocationList() async {
    List<LocationCardResponse> hotLocationList = [];
    final response =
        await http.get(Uri.parse('${baseUrl}/api/locations/top/popular'));

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
      final response = await http.get(
        Uri.parse("${recommendUrl}/recomendation_home/${userId}"),
      );

      if (response.statusCode == 200) {
        var data =
            json.decode(utf8.decode(response.body.codeUnits)) as List<dynamic>;
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

  Future<OtherTripResponse> getTripDetail(int tripId) async {
    final userId = await SharedPref().getUserId();
    if (userId != null) {
      final response =
          await http.get(Uri.parse("${baseUrl}/api/trips/${tripId}"));
      if (response.statusCode == 200) {
        var data = OtherTripResponse.fromMap(json.decode(response.body));
        return data;
      } else {
        throw Exception("can not fetch data trip details");
      }
    } else
      return throw Exception("null userId");
  }
}
