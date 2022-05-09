import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trip_planner/src/models/response/location_detail_response.dart';
import 'package:trip_planner/src/models/response/location_recommend_response.dart';
import 'package:trip_planner/src/models/response/review_response.dart';
import 'package:trip_planner/src/models/response/shop_response.dart';
import 'package:trip_planner/src/repository/shared_pref.dart';

class LocationService {
  final String baseUrl = 'https://eztrip-backend.herokuapp.com';
  final String recommendUrl = 'https://travel-planning-ceproject.herokuapp.com';

  Future<LocationDetailResponse> getLocationDetailById(int locationId) async {
    final response =
        await http.get(Uri.parse('${baseUrl}/api/locations/${locationId}'));
    // print(response.body);
    if (response.statusCode == 200) {
      var data = LocationDetailResponse.fromJson(json.decode(response.body));
      // print(data);
      return data;
    } else {
      throw Exception("can not fetch data hot location");
    }
  }

  Future<List<LocationRecommendResponse>> getLocationRecommend(
      int category, double lat1, double lng1, double lat2, double lng2) async {
    final userId = await SharedPref().getUserId();
    if (userId != null) {
      final response = await http.get(Uri.parse(
          '${recommendUrl}/recommendation_nearly_user/${userId},${category},${lat1},${lng1},${lat2},${lng2}'));

      if (response.statusCode == 200) {
        List<LocationRecommendResponse> locationRecommendList;
        locationRecommendList =
            (json.decode(utf8.decode(response.body.codeUnits)) as List)
                .map((i) => LocationRecommendResponse.fromJson(i))
                .toList();
        return locationRecommendList;
      } else {
        throw Exception('Failed to load campaigns');
      }
    } else
      return [];
  }

  Future<List<ShopResponse>> getAllShop() async {
    final response = await http
        .get(Uri.parse('${baseUrl}/api/locations/search/rating?category=4'));

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

  Future<List<ReviewResponse>> getReviewsByLocationId(int locationId) async {
    final response = await http.get(Uri.parse(
        '${baseUrl}/api/reviews/reviewLocation?locationId=${locationId}'));
    if (response.statusCode == 200) {
      List<ReviewResponse> reviewList;
      reviewList = (json.decode(response.body) as List)
          .map((i) => ReviewResponse.fromJson(i))
          .toList();
      return reviewList;
    } else {
      throw Exception('Failed to load reviews');
    }
  }

  Future<int?> tryToCheckin(int locationId) async {
    final userId = await SharedPref().getUserId();
    if (userId != null) {
      final response = await http.put(
        Uri.parse("${baseUrl}/api/locations/checkIn/${locationId}"),
      );

      if (response.statusCode == 200) {
        return response.statusCode;
      } else {
        throw Exception("can not checkin locationId");
      }
    } else
      return null;
  }
}
