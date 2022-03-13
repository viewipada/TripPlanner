import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trip_planner/src/models/response/baggage_response.dart';

class BaggageService {
  Future<List<BaggageResponse>> getBaggageList() async {
    List<BaggageResponse> baggageList = [];
    final response = await http.get(Uri.parse(
        "https://run.mocky.io/v3/d7a7721f-b839-437f-a1f4-2a3f0f59007e"));

    if (response.statusCode == 200) {
      var data = json.decode(response.body) as List<dynamic>;
      data
          .map((item) => baggageList.add(BaggageResponse.fromJson(item)))
          .toList();
      return baggageList;
    } else {
      throw Exception("can not fetch data");
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
