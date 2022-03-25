import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trip_planner/src/models/response/location_created_response.dart';
import 'package:trip_planner/src/models/response/profile_details_response.dart';
import 'package:trip_planner/src/models/response/profile_response.dart';

class ProfileService {
  final String baseUrl = 'http://10.0.2.2:8080';

  Future<void> tryToRegister(String username, String password) async {
    final response = await http.post(
        Uri.parse("${baseUrl}/api/authen/register"),
        body: {"username": username, "password": password, "role": "user"});

    print(response.statusCode);
    if (response.statusCode == 201) {
      // var data = ProfileResponse.fromJson(json.decode(response.body));
      // return data;
      print('pass');
      print(response.body);
    } else if (response.statusCode == 409) {
      print(response.body);
    } else {
      throw Exception("can not fetch data trips and reviews");
    }
  }

  Future<void> tryToLogin(String username, String password) async {
    final response =
        await http.post(Uri.parse("${baseUrl}/api/authen/login"), headers: {
      "Accept": "application/json",
      // "Content-Type": "application/json"
    }, body: {
      "username": username,
      "password": password
    });

    print(response.statusCode);
    if (response.statusCode == 200) {
      // var data = ProfileResponse.fromJson(json.decode(response.body));
      // return data;
      print('pass');
      print(response.body);
    } else if (response.statusCode == 400) {
      //wrong password
      print(response.body);
    } else if (response.statusCode == 401) { //user not found 
      print(response.body);
    } else {
      throw Exception("can not fetch data trips and reviews");
    }
  }

  Future<ProfileResponse> getMyProfile() async {
    final response = await http.get(Uri.parse(
        "https://run.mocky.io/v3/783724fb-230b-4ab2-b873-4cd49ed7f0af"));

    if (response.statusCode == 200) {
      var data = ProfileResponse.fromJson(json.decode(response.body));
      return data;
    } else {
      throw Exception("can not fetch data trips and reviews");
    }
  }

  Future<ProfileDetailsResponse> getProfileDetails() async {
    final response = await http.get(Uri.parse(
        "https://run.mocky.io/v3/9e629bae-263f-440e-a5f6-b9419428b4d8"));

    if (response.statusCode == 200) {
      var data = ProfileDetailsResponse.fromJson(json.decode(response.body));
      print(data);
      return data;
    } else {
      throw Exception("can not fetch data trips and reviews");
    }
  }

  Future<List<LocationCreatedResponse>> getLocationRequest() async {
    List<LocationCreatedResponse> locationReq = [];
    final response = await http.get(Uri.parse(
        "https://run.mocky.io/v3/650b5c21-c293-4919-956f-f0c2bb05b99a"));

    if (response.statusCode == 200) {
      var data = json.decode(response.body) as List<dynamic>;
      data
          .map(
              (item) => locationReq.add(LocationCreatedResponse.fromJson(item)))
          .toList();
      return locationReq;
    } else {
      throw Exception("can not fetch data");
    }
  }
}
