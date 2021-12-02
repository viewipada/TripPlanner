import 'dart:convert';
import 'package:http/http.dart' as http;
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
}
