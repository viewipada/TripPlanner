import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trip_planner/src/models/response/baggage_response.dart';
import 'package:trip_planner/src/repository/shared_pref.dart';

class BaggageService {
  final String baseUrl = 'http://10.0.2.2:8080';

  Future<List<BaggageResponse>> getBaggageList() async {
    List<BaggageResponse> baggageList = [];
    final userId = await SharedPref().getUserId();
    if (userId != null) {
      final response =
          await http.get(Uri.parse('${baseUrl}/api/baggage/${userId}'));

      if (response.statusCode == 200) {
        var data = json.decode(response.body) as List<dynamic>;
        data
            .map((item) => baggageList.add(BaggageResponse.fromJson(item)))
            .toList();
        return baggageList;
      } else {
        throw Exception("can not fetch data");
      }
    } else
      return [];
  }

  Future<void> addBaggageItem(int locationId) async {
    final userId = await SharedPref().getUserId();
    if (userId != null) {
      final response = await http.post(Uri.parse("${baseUrl}/api/baggage/"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(
            <String, int>{"locationId": locationId, "userId": userId},
          ));

      if (response.statusCode == 201) {
        await SharedPref().addBaggageItem(locationId);
      } else {
        throw Exception("can not add baggageItem");
      }
    } else
      print('null userId');
  }

  Future<void> removeBaggageItem(int locationId) async {
    final userId = await SharedPref().getUserId();
    if (userId != null) {
      final response = await http.delete(
        Uri.parse('${baseUrl}/api/baggage/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
            <String, int>{"locationId": locationId, "userId": userId}),
      );

      if (response.statusCode == 200) {
        await SharedPref().removeBaggageItem(locationId);
        print(response.body);
      } else {
        throw Exception("can not remove baggageItem");
      }
    }
  }

  List<BaggageResponse> setAllSelected(
      bool checkboxValue, List<BaggageResponse> baggageList) {
    return checkboxValue ? baggageList.toList() : [];
  }

  bool setCheckboxValue(
      List<BaggageResponse> selectedList, List<BaggageResponse> baggageList) {
    return selectedList.length == baggageList.length;
  }
}
