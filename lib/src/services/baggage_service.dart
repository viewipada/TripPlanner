import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trip_planner/src/models/place.dart';

class BaggageService {
  Future<List<Place>> getBaggageList() async {
    List<Place> baggageList = [];
    final response = await http.get(Uri.parse(
        "https://run.mocky.io/v3/b23cee9a-ca9a-4ff2-9e26-83c936e6450e"));

    if (response.statusCode == 200) {
      var data = json.decode(response.body) as List<dynamic>;
      data.map((item) => baggageList.add(Place.fromJson(item))).toList();
      return baggageList;
    } else {
      throw Exception("can not fetch data");
    }
  }

  Future<bool> toggleValue(bool value) async {
    return !value;
  }

  Future<List<Place>> setAllSelected(
      bool value, List<Place> baggageList) async {
    List<Place> all = [];
    if (value) {
      baggageList.map((e) => all.add(e)).toList();
    }
    return all;
  }

  Future<List<Place>> setSelectedList(bool isSelected, List<Place> selectedList,
      Place item, List<Place> baggageList) async {
    if (isSelected) {
      selectedList.add(item);
    } else {
      selectedList.remove(item);
    }
    return selectedList;
  }

  Future<bool> setCheckboxValue(
      List<Place> selectedList, List<Place> baggageList) async {
    if (selectedList.length == baggageList.length) {
      return true;
    }
    return false;
  }
}
