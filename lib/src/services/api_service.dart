import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trip_planner/src/models/place.dart';
import 'package:trip_planner/src/notifiers/baggage_notifier.dart';

class ApiService {
  static const String API_ENDPOINT =
      "https://run.mocky.io/v3/24c98bfb-d4e0-4eb9-9a3a-81931d94f824";

  static getBaggageList(BaggageNotifire baggageNotifire) async {
    List<Place> baggageList = [];

    http.get(Uri.parse(API_ENDPOINT)).then((response) {
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        data.map((place) => baggageList.add(Place.fromJson(place))).toList();
        baggageNotifire.setBaggageList(baggageList);
      } else {
        baggageNotifire.setBaggageList(List<Place>.empty());
      }
    });
  }
}
