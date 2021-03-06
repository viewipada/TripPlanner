import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:trip_planner/src/models/response/location_created_response.dart';
import 'package:trip_planner/src/models/response/profile_details_response.dart';
import 'package:trip_planner/src/models/response/profile_response.dart';
import 'package:trip_planner/src/models/response/user_interested_response.dart';
import 'package:trip_planner/src/repository/shared_pref.dart';
import 'package:trip_planner/src/services/baggage_service.dart';

class ProfileService {
  final String baseUrl = 'https://eztrip-backend.herokuapp.com';

  Future<int?> tryToRegister(String username, String password) async {
    final response = await http.post(
        Uri.parse("${baseUrl}/api/authen/register"),
        body: {"username": username, "password": password, "role": "user"});

    if (response.statusCode == 201) {
      List<String> _baggage = [];
      await SharedPref().initialBaggageItem(_baggage);
      var jwt = json.decode(ascii.decode(
          base64.decode(base64.normalize(response.body.split(".")[1]))));
      await SharedPref().saveUserId(jwt['user_id']);
      return response.statusCode;
    } else if (response.statusCode == 409) {
      return response.statusCode;
    } else {
      return null;
    }
  }

  Future<int?> tryToLogin(String username, String password) async {
    final response = await http.post(Uri.parse("${baseUrl}/api/authen/login"),
        body: {"username": username, "password": password});

    if (response.statusCode == 200) {
      var jwt = json.decode(ascii.decode(
          base64.decode(base64.normalize(response.body.split(".")[1]))));
      await SharedPref().saveUserId(jwt['user_id']);
      List<String> _baggage = [];
      await BaggageService()
          .getBaggageList()
          .then((list) => list.forEach((element) {
                _baggage.add(element.locationId.toString());
              }));
      await SharedPref().initialBaggageItem(_baggage);
      return response.statusCode;
    } else if (response.statusCode == 400) {
      //wrong password
      return response.statusCode;
    } else if (response.statusCode == 401) {
      //user not found
      return response.statusCode;
    } else {
      return null;
    }
  }

  Future<ProfileResponse> getMyProfile() async {
    final userId = await SharedPref().getUserId();
    if (userId != null) {
      final response =
          await http.get(Uri.parse("${baseUrl}/api/user/${userId}"));

      if (response.statusCode == 200) {
        var data = ProfileResponse.fromJson(json.decode(response.body));
        return data;
      } else {
        throw Exception("can not fetch data my profile");
      }
    } else
      throw Exception("can not getMyProfile");
  }

  Future<ProfileDetailsResponse> getProfileDetails() async {
    final userId = await SharedPref().getUserId();
    if (userId != null) {
      final response = await http
          .get(Uri.parse("${baseUrl}/api/user/settingProfile/${userId}"));
      if (response.statusCode == 200) {
        var data = ProfileDetailsResponse.fromJson(json.decode(response.body));
        return data;
      } else {
        throw Exception("can not fetch data trips and reviews");
      }
    } else
      throw Exception("can not getProfileDetails");
  }

  Future<List<LocationCreatedResponse>> getLocationRequest() async {
    List<LocationCreatedResponse> locationReq = [];
    final userId = await SharedPref().getUserId();
    if (userId != null) {
      final response = await http
          .get(Uri.parse("${baseUrl}/api/locations/byUser/${userId}"));

      if (response.statusCode == 200) {
        var data = json.decode(response.body) as List<dynamic>;
        data
            .map((item) =>
                locationReq.add(LocationCreatedResponse.fromJson(item)))
            .toList();
        return locationReq;
      } else {
        throw Exception("can not fetch data");
      }
    } else
      return [];
  }

  Future<int?> deleteReview(int locationId) async {
    final userId = await SharedPref().getUserId();
    if (userId != null) {
      final response = await http.delete(
        Uri.parse('${baseUrl}/api/reviews/${userId}/${locationId}'),
      );
      // if (response.statusCode == 200) {
      //   print(response.body);
      // } else {
      //   throw Exception("can not remove review");
      // }
      return response.statusCode;
    }
    return null;
  }

  Future<void> deleteLocation(int locationId) async {
    final userId = await SharedPref().getUserId();
    if (userId != null) {
      final response = await http.delete(
        Uri.parse('${baseUrl}/api/locations/${locationId}'),
      );

      if (response.statusCode == 200) {
        print(response.body);
      } else {
        throw Exception("can not remove location by user");
      }
    }
  }

  Future<UserInterestedResponse?> getUserInterested() async {
    final userId = await SharedPref().getUserId();

    if (userId != null) {
      final response =
          await http.get(Uri.parse("${baseUrl}/api/user/interested/${userId}"));

      if (response.statusCode == 200) {
        var data = response.body == 'null'
            ? null
            : UserInterestedResponse.fromJson(json.decode(response.body));
        return data;
      } else if (response.statusCode == 400) {
        return null;
      } else {
        throw Exception("can not fetch data review by user & locationId");
      }
    } else
      return null;
  }

  Future<int?> createUserInterested(
      List<String> seletedActivities,
      List<String> selectedRestaurant,
      List<String> selectedHotel,
      int? minPrice,
      int? maxPrice) async {
    final userId = await SharedPref().getUserId();
    if (userId != null) {
      final response = await http.post(
          Uri.parse("${baseUrl}/api/user/interested/"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(
            <String, dynamic>{
              "userId": userId,
              "first_activity":
                  seletedActivities.length > 0 ? seletedActivities[0] : null,
              "second_activity":
                  seletedActivities.length > 1 ? seletedActivities[1] : null,
              "third_activity":
                  seletedActivities.length > 2 ? seletedActivities[2] : null,
              "first_food":
                  selectedRestaurant.length > 0 ? selectedRestaurant[0] : null,
              "second_food":
                  selectedRestaurant.length > 1 ? selectedRestaurant[1] : null,
              "third_food":
                  selectedRestaurant.length > 2 ? selectedRestaurant[2] : null,
              "first_hotel": selectedHotel.length > 0 ? selectedHotel[0] : null,
              "second_hotel":
                  selectedHotel.length > 1 ? selectedHotel[1] : null,
              "third_hotel": selectedHotel.length > 2 ? selectedHotel[2] : null,
              "min_price": minPrice,
              "max_price": maxPrice
            },
          ));

      if (response.statusCode == 201) {
        return response.statusCode;
      } else {
        throw Exception("can not create userInterest");
      }
    } else
      print('null userId');
    return null;
  }

  Future<int?> updateUserInterested(
      List<String> seletedActivities,
      List<String> selectedRestaurant,
      List<String> selectedHotel,
      int? minPrice,
      int? maxPrice) async {
    final userId = await SharedPref().getUserId();
    if (userId != null) {
      final response = await http.put(
          Uri.parse("${baseUrl}/api/user/interested/${userId}"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(
            <String, dynamic>{
              "userId": userId,
              "first_activity":
                  seletedActivities.length > 0 ? seletedActivities[0] : null,
              "second_activity":
                  seletedActivities.length > 1 ? seletedActivities[1] : null,
              "third_activity":
                  seletedActivities.length > 2 ? seletedActivities[2] : null,
              "first_food":
                  selectedRestaurant.length > 0 ? selectedRestaurant[0] : null,
              "second_food":
                  selectedRestaurant.length > 1 ? selectedRestaurant[1] : null,
              "third_food":
                  selectedRestaurant.length > 2 ? selectedRestaurant[2] : null,
              "first_hotel": selectedHotel.length > 0 ? selectedHotel[0] : null,
              "second_hotel":
                  selectedHotel.length > 1 ? selectedHotel[1] : null,
              "third_hotel": selectedHotel.length > 2 ? selectedHotel[2] : null,
              "min_price": minPrice,
              "max_price": maxPrice
            },
          ));

      if (response.statusCode == 200) {
        return response.statusCode;
      } else {
        throw Exception("can not create userInterest");
      }
    } else
      print('null userId');
    return null;
  }

  Future<int?> updateUserProfile(String gender, String birthDate) async {
    final userId = await SharedPref().getUserId();
    if (userId != null) {
      final response =
          await http.put(Uri.parse("${baseUrl}/api/user/${userId}"),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(
                <String, dynamic>{"gender": gender, "birthDate": birthDate},
              ));

      if (response.statusCode == 200) {
        return response.statusCode;
      } else {
        throw Exception("can not create userInterest");
      }
    } else
      print('null userId');
    return null;
  }

  Future<int?> updateUserProfileDetail(String gender, String birthDate,
      File? userImage, String? imageUrl) async {
    final userId = await SharedPref().getUserId();
    if (userId != null) {
      String? imgUrl;

      if (userImage != null) {
        var formData = FormData();
        formData.files.add(MapEntry(
          "file",
          await MultipartFile.fromFile(userImage.path),
        ));
        var res =
            await Dio().post("${baseUrl}/api/file/upload", data: formData);
        imgUrl = '${baseUrl}/' + res.data['name'].toString();
      } else {
        imgUrl = imageUrl;
      }

      final response =
          await http.put(Uri.parse("${baseUrl}/api/user/${userId}"),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(
                <String, dynamic>{
                  "gender": gender,
                  "birthDate": birthDate,
                  "imgUrl": imgUrl
                },
              ));

      if (response.statusCode == 200) {
        return response.statusCode;
      } else {
        throw Exception("can not create userInterest");
      }
    } else
      print('null userId');
    return null;
  }
}
