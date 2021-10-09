import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trip_planner/src/models/response/location_card_response.dart';

class HomeService {
  Future<List<LocationCardResponse>> getHotLocationList() async {
    List<LocationCardResponse> hotLocationList = [];
    final response = await http.get(Uri.parse(
        "https://run.mocky.io/v3/a6a6d525-ad60-45dd-b3e6-8415b90515f0"));

    if (response.statusCode == 200) {
      var data = json.decode(response.body) as List<dynamic>;
      data
          .map((item) =>
              hotLocationList.add(LocationCardResponse.fromJson(item)))
          .toList();
      return hotLocationList;
    } else {
      throw Exception("can not fetch data");
    }
  }
}
