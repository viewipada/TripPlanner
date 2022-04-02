import 'dart:convert';
import 'package:admin/src/models/location_card_response.dart';
import 'package:admin/src/models/location_detail_response.dart';
import 'package:admin/src/shared_pref.dart';
import 'package:http/http.dart' as http;

class DashboardService {
  final String baseUrl = 'http://localhost:8080';

  Future<List<LocationCardResponse>> getLocationBy(int category) async {
    List<LocationCardResponse> baggageList = [];
    final userId = await SharedPref().getUserId();
    if (userId != null) {
      final response = await http.get(Uri.parse(
          '$baseUrl/api/locations/search/rating?category=3')); // mock api

      if (response.statusCode == 200) {
        var data = json.decode(response.body) as List<dynamic>;
        data
            .map((item) => baggageList.add(LocationCardResponse.fromJson(item)))
            .toList();
        return baggageList;
      } else {
        throw Exception("can not fetch data");
      }
    } else {
      return [];
    }
  }

  Future<List<LocationCardResponse>> getLocationsRequest() async {
    List<LocationCardResponse> baggageList = [];
    final userId = await SharedPref().getUserId();
    if (userId != null) {
      final response = await http.get(Uri.parse(
          '$baseUrl/api/locations/search/rating?category=3')); // mock api

      if (response.statusCode == 200) {
        var data = json.decode(response.body) as List<dynamic>;
        data
            .map((item) => baggageList.add(LocationCardResponse.fromJson(item)))
            .toList();
        return baggageList;
      } else {
        throw Exception("can not fetch data");
      }
    } else {
      return [];
    }
  }

  Future<LocationDetailResponse> getLocationDetailById(int locationId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/api/locations/$locationId'));
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
