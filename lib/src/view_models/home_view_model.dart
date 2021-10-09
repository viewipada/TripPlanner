import 'package:flutter/foundation.dart';
import 'package:trip_planner/src/models/response/location_card_response.dart';
import 'package:trip_planner/src/services/home_service.dart';

class HomeViewModel with ChangeNotifier {
  List<LocationCardResponse> _hotLocationList = [];
  List<LocationCardResponse> _locationRecommendedList = [];

  Future<void> getHotLocationList() async {
    _hotLocationList = await HomeService().getHotLocationList();
    notifyListeners();
  }

  Future<void> getLocationRecommendedList() async {
    _locationRecommendedList = await HomeService().getLocationRecommendedList();
    notifyListeners();
  }

  List<LocationCardResponse> get hotLocationList => _hotLocationList;
  List<LocationCardResponse> get locationRecommendedList =>
      _locationRecommendedList;
}
