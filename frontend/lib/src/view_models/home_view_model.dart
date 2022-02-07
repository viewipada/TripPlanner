import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:trip_planner/src/models/response/location_card_response.dart';
import 'package:trip_planner/src/models/response/trip_card_response.dart';
import 'package:trip_planner/src/services/home_service.dart';
import 'package:trip_planner/src/view/screens/location_detail_page.dart';
import 'package:trip_planner/src/view/screens/trip_form_page.dart';

class HomeViewModel with ChangeNotifier {
  List<LocationCardResponse> _hotLocationList = [];
  List<LocationCardResponse> _locationRecommendedList = [];
  List<TripCardResponse> _tripRecommendedList = [];

  Future<List<LocationCardResponse>> getHotLocationList() async {
    _hotLocationList = await HomeService().getHotLocationList();
    return _hotLocationList;
  }

  Future<List<LocationCardResponse>> getLocationRecommendedList() async {
    _locationRecommendedList = await HomeService().getLocationRecommendedList();
    return _locationRecommendedList;
  }

  Future<List<TripCardResponse>> getTripRecommendedList() async {
    _tripRecommendedList = await HomeService().getTripRecommendedList();
    return _tripRecommendedList;
  }

  String showTravelingDay(int travelingDay) {
    if (travelingDay == 1) {
      return '$travelingDay วัน';
    }
    return '$travelingDay วัน ${travelingDay - 1} คืน';
  }

  void goToLocationDetail(BuildContext context, int locationId) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => LocationDetailPage(locationId: locationId)),
    );
  }

  void goToTripFormPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TripFormPage(startPointList: [])),
    );
  }

  List<LocationCardResponse> get hotLocationList => _hotLocationList;
  List<LocationCardResponse> get locationRecommendedList =>
      _locationRecommendedList;

  List<TripCardResponse> get tripRecommendedList => _tripRecommendedList;
}
