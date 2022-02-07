import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trip_planner/src/models/response/profile_details_response.dart';
import 'package:trip_planner/src/models/response/profile_response.dart';

class ProfileService {
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
}
