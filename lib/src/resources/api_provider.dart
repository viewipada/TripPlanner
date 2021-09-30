import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:trip_planner/src/models/place.dart';

class ApiProvider extends ChangeNotifier {
  ApiProvider() {
    getBaggageList().then((places) {
      _places = places;
      notifyListeners();
    });
  }
  
  List<Place> get places => _places;
  List<Place> _places = [];

  Future<List<Place>> getBaggageList() async {
    var response = await http.get(Uri.parse(
        'https://run.mocky.io/v3/24c98bfb-d4e0-4eb9-9a3a-81931d94f824'));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      data.map((place) => places.add(Place.fromJson(place))).toList();
      return places;
    } else
      return List<Place>.empty();
  }
}
