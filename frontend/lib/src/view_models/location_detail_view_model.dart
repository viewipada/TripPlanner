import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:trip_planner/src/models/response/location_detail_response.dart';
import 'package:trip_planner/src/services/baggage_service.dart';
import 'package:trip_planner/src/services/location_service.dart';
import 'package:trip_planner/src/view/screens/review_page.dart';
import 'dart:math' show cos, sqrt, asin;

class LocationDetailViewModel with ChangeNotifier {
  bool _readMore = false;
  late LocationDetailResponse _locationDetail;
  bool _serviceEnabled = false;
  PermissionStatus _permissionGranted = PermissionStatus.denied;
  LocationData? _userLocation;

  void toggleReadmoreButton() {
    _readMore = !_readMore;
    notifyListeners();
  }

  void goBack(BuildContext context) {
    Navigator.pop(context, 'refresh');
  }

  Future<LocationDetailResponse> getLocationDetailById(int locationId) async {
    _locationDetail = await LocationService().getLocationDetailById(locationId);
    // notifyListeners();
    return _locationDetail;
  }

  void goToReviewPage(
      BuildContext context, String locationName, int locationId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReviewPage(
          locationName: locationName,
          locationId: locationId,
        ),
      ),
    );
  }

  Future<int?> addBaggageItem(int locationId) async {
    return await BaggageService().addBaggageItem(locationId);
  }

  Future<int?> removeBaggageItem(int locationId) async {
    return await BaggageService().removeBaggageItem(locationId);
  }

  Future<int?> tryToCheckin(int locationId) async {
    await getUserLocation();
    if (_userLocation != null) {
      final distance = await coordinateDistance(
          _locationDetail.latitude,
          _locationDetail.longitude,
          _userLocation!.latitude,
          _userLocation!.longitude);

      if (distance > 0.5) {
        return null;
      } else {
        notifyListeners();
        return await LocationService().tryToCheckin(locationId);
      }
    }
    return null;
  }

  Future<void> getUserLocation() async {
    Location location = new Location();

    // Check if location service is enable
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    // Ask for permission
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    await location.getLocation().then((value) {
      _userLocation = value;
      notifyListeners();
    });
  }

  double coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  bool get readMore => _readMore;
  LocationDetailResponse get locationDetail => _locationDetail;
  LocationData? get userLocation => _userLocation;
}
