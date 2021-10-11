import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trip_planner/src/models/response/baggage_response.dart';

class BaggageService {
  Future<List<BaggageResponse>> getBaggageList() async {
    List<BaggageResponse> baggageList = [];
    final response = await http.get(Uri.parse(
        "https://run.mocky.io/v3/336bc4a1-87ed-4a72-9ecb-728d3a67449a"));

    if (response.statusCode == 200) {
      var data = json.decode(response.body) as List<dynamic>;
      data.map((item) => baggageList.add(BaggageResponse.fromJson(item))).toList();
      return baggageList;
    } else {
      throw Exception("can not fetch data");
    }
  }

  bool toggleValue(bool value) {
    return !value;
  }

  List<BaggageResponse> setAllSelected(
      bool value, List<BaggageResponse> baggageList) {
    List<BaggageResponse> all = [];
    if (value) {
      baggageList.map((e) => all.add(e)).toList();
    }
    return all;
  }

  List<BaggageResponse> setSelectedList(
      bool isSelected,
      List<BaggageResponse> selectedList,
      BaggageResponse item,
      List<BaggageResponse> baggageList) {
    if (isSelected) {
      selectedList.add(item);
    } else {
      selectedList.remove(item);
    }
    return selectedList;
  }

  bool setCheckboxValue(
      List<BaggageResponse> selectedList, List<BaggageResponse> baggageList) {
    return selectedList.length == baggageList.length;
  }
}
