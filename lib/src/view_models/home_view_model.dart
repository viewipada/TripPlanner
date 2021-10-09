import 'package:flutter/foundation.dart';
import 'package:trip_planner/src/models/response/location_card_response.dart';
import 'package:trip_planner/src/models/response/trip_card_response.dart';
import 'package:trip_planner/src/services/home_service.dart';

class HomeViewModel with ChangeNotifier {
  List<LocationCardResponse> _hotLocationList = [];
  List<LocationCardResponse> _locationRecommendedList = [];
  List<TripCardResponse> _tripRecommendedList = [];

  Future<void> getHotLocationList() async {
    _hotLocationList = await HomeService().getHotLocationList();
    notifyListeners();
  }

  Future<void> getLocationRecommendedList() async {
    _locationRecommendedList = await HomeService().getLocationRecommendedList();
    notifyListeners();
  }

  Future<void> getTripRecommendedList() async {
    _tripRecommendedList = await HomeService().getTripRecommendedList();
    notifyListeners();
  }

  String showTravelingDay(int travelingDay) {
    if (travelingDay == 1) {
      return travelingDay.toString() + ' วัน';
    }
    return travelingDay.toString() +
        ' วัน ' +
        (travelingDay - 1).toString() +
        ' คืน';
  }

  List<LocationCardResponse> get hotLocationList => _hotLocationList;
  List<LocationCardResponse> get locationRecommendedList =>
      _locationRecommendedList;

  List<TripCardResponse> get tripRecommendedList => _tripRecommendedList;
}
