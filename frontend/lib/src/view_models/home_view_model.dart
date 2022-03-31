import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:trip_planner/src/models/response/location_card_response.dart';
import 'package:trip_planner/src/models/response/other_trip_response.dart';
import 'package:trip_planner/src/models/response/trip_card_response.dart';
import 'package:trip_planner/src/models/trip.dart';
import 'package:trip_planner/src/models/trip_item.dart';
import 'package:trip_planner/src/repository/shared_pref.dart';
import 'package:trip_planner/src/repository/trip_item_operations.dart';
import 'package:trip_planner/src/repository/trips_operations.dart';
import 'package:trip_planner/src/services/home_service.dart';
import 'package:trip_planner/src/view/screens/location_detail_page.dart';
import 'package:trip_planner/src/view/screens/other_trip_page.dart';
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

  Future<void> goToLocationDetail(BuildContext context, int locationId) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => LocationDetailPage(locationId: locationId)),
    );
    if (result != null) notifyListeners();
  }

  void goToTripFormPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TripFormPage(startPointList: [])),
    );
  }

  void goToOtherTripPage(BuildContext context, int tripId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OtherTripPage(tripId: tripId)),
    );
  }

  Future<void> copyTrip(OtherTripResponse tripDetail) async {
    var userId = await SharedPref().getUserId();

    if (userId != null) {
      final trip = Trip(
        tripName: tripDetail.tripName,
        firstLocation: tripDetail.firstLocation,
        lastLocation: tripDetail.lastLocation,
        totalPeople: tripDetail.totalPeople,
        totalDay: tripDetail.totalDay,
        totalTripItem: tripDetail.tripItems.length,
        status: 'unfinished',
        userId: userId,
      );
      int tripId = await TripsOperations().createTrip(trip);

      List<TripItem> tripItems = [];
      await Future.forEach(tripDetail.tripItems,
          (OtherTripItemResponse item) async {
        final tripItem = TripItem(
          day: item.day,
          no: item.no,
          locationId: item.locationId,
          locationCategory: item.locationCategory == 1
              ? "ที่เที่ยว"
              : item.locationCategory == 2
                  ? "ที่กิน"
                  : "ที่พัก",
          locationName: item.locationName,
          imageUrl: item.imageUrl,
          latitude: item.latitude,
          longitude: item.longitude,
          duration: item.duration,
          tripId: tripId,
          distance: item.distance,
          drivingDuration: item.drivingDuration,
          startTime: item.startTime,
          note: item.note,
        );
        tripItem.itemId = await TripItemOperations().createTripItem(tripItem);
        tripItems.add(tripItem);
      });
    }
  }

  List<LocationCardResponse> get hotLocationList => _hotLocationList;
  List<LocationCardResponse> get locationRecommendedList =>
      _locationRecommendedList;

  List<TripCardResponse> get tripRecommendedList => _tripRecommendedList;
}
