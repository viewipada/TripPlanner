import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trip_planner/src/models/response/location_detail_response.dart';
import 'package:trip_planner/src/models/response/location_recommend_response.dart';
import 'package:trip_planner/src/models/response/shop_response.dart';

class LocationService {
  final String baseUrl = 'http://10.0.2.2:8080';

  Future<LocationDetailResponse> getLocationDetailById(int locationId) async {
    final response = await http.get(Uri.parse(
        // "https://run.mocky.io/v3/c83fb4de-baa2-44d3-abbe-452f791838e2"
        '${baseUrl}/api/locations/${locationId}'));
    // print(response.body);
    if (response.statusCode == 200) {
      var data = LocationDetailResponse.fromJson(json.decode(response.body));
      // print(data);
      return data;
    } else {
      throw Exception("can not fetch data hot location");
    }
  }

  Future<List<LocationRecommendResponse>> getLocationRecommend() async {
    final response = await http.get(Uri.parse(
        'https://run.mocky.io/v3/5fe195d1-63a4-4a09-ba61-7a7efa1771b1'));

    if (response.statusCode == 200) {
      List<LocationRecommendResponse> locationRecommendList;
      locationRecommendList = (json.decode(response.body) as List)
          .map((i) => LocationRecommendResponse.fromJson(i))
          .toList();
      return locationRecommendList;
    } else {
      throw Exception('Failed to load campaigns');
    }
  }

  Future<List<ShopResponse>> getAllShop() async {
    final response = await http.get(Uri.parse(
        'https://run.mocky.io/v3/772fe852-5955-4cf4-9dd3-3901a3675adb'));

    if (response.statusCode == 200) {
      List<ShopResponse> shopList;
      shopList = (json.decode(response.body) as List)
          .map((i) => ShopResponse.fromJson(i))
          .toList();
      return shopList;
    } else {
      throw Exception('Failed to load campaigns');
    }
  }
}
