import 'dart:convert';
import 'package:admin/src/models/location_card_response.dart';
import 'package:admin/src/models/location_detail_response.dart';
import 'package:admin/src/shared_pref.dart';
import 'package:http/http.dart' as http;

class DashboardService {
  final String baseUrl = 'https://eztrip-backend.herokuapp.com';

  Future<List<LocationCardResponse>> getLocationBy(int category) async {
    List<LocationCardResponse> baggageList = [];
    final userId = await SharedPref().getUserId();
    if (userId != null) {
      final response = await http.get(Uri.parse(
          '$baseUrl/api/locations/admin/search/updatedAt?category=$category'));

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
      final response = await http
          .get(Uri.parse('$baseUrl/api/locations/admin/requested/admin'));

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
      return data;
    } else {
      throw Exception("can not fetch data hot location");
    }
  }

  Future<int?> updateLocationStatus(
      int locationId, String status, String remark) async {
    final userId = await SharedPref().getUserId();
    if (userId != null) {
      final response =
          await http.put(Uri.parse("$baseUrl/api/locations/$locationId"),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: status == "Deny"
                  ? jsonEncode(
                      <String, dynamic>{
                        "locationStatus": status,
                        "remark": remark
                      },
                    )
                  : jsonEncode(
                      <String, dynamic>{"locationStatus": status},
                    ));

      if (response.statusCode == 200) {
        return response.statusCode;
      } else {
        throw Exception("can not update locationStatus");
      }
    } else {
      return null;
    }
  }

  Future<int?> deleteLocation(int locationId) async {
    final userId = await SharedPref().getUserId();
    if (userId != null) {
      final response = await http.delete(
        Uri.parse('$baseUrl/api/locations/$locationId'),
      );

      if (response.statusCode == 200) {
        return response.statusCode;
      } else {
        return null;
      }
    }
    return null;
  }
}
