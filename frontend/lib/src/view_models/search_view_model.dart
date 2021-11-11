import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:trip_planner/src/models/response/travel_nearby_response.dart';
import 'package:trip_planner/src/services/location_nearby_service.dart';
import 'package:trip_planner/src/view/screens/my_location_page.dart';
import 'package:flutter/services.dart' show rootBundle;

class SearchViewModel with ChangeNotifier {
  List _radius = [
    {'r': 1, 'isSelected': false},
    {'r': 3, 'isSelected': true},
    {'r': 5, 'isSelected': false}
  ];
  List _locationCategories = [
    {'category': 'ทุกแบบ', 'isSelected': false},
    {'category': 'ที่เที่ยว', 'isSelected': false},
    {'category': 'ที่กิน', 'isSelected': false},
    {'category': 'ที่พัก', 'isSelected': false},
  ];
  double _circleRadius = 3000;
  bool _serviceEnabled = false;
  PermissionStatus _permissionGranted = PermissionStatus.denied;
  LocationData? _userLocation;
  String _mapStyle = '';
  List<LocationNearbyResponse> _locationNearbyList = [];
  List<LocationNearbyResponse> _locationPinCard = [];
  Set<Marker> _markers = Set();

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

  void getMapStyle() {
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
      notifyListeners();
    });
  }

  void goToMyLocationPage(
      BuildContext context, String category, LocationData userLocation) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyLocationPage(
          category: category,
          userLocation: userLocation,
        ),
      ),
    );
  }

  void updateCategorySelection(dynamic category) {
    _locationCategories.forEach((element) => element['isSelected'] = false);
    category['isSelected'] = true;
    notifyListeners();
  }

  void updateRadius(dynamic radius) {
    _radius.forEach((element) => element['isSelected'] = false);
    radius['isSelected'] = true;
    _circleRadius = radius['r'] * 1000.0;
    notifyListeners();
  }

  Future<void> updateMapView(
      Completer<GoogleMapController> _controller, int radius) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target:
          LatLng(_userLocation!.latitude ?? 0, _userLocation!.longitude ?? 0),
      zoom: getZoomLevel(radius),
    )));
  }

  double getZoomLevel(int radius) {
    double zoomLevel = 11;
    if (radius > 0) {
      double radiusElevated = radius + radius / 2;
      double scale = radiusElevated / 500;
      zoomLevel = 16 - log(scale) / log(2);
    }
    return zoomLevel;
  }

  Future<void> getLocationNearby(
      String category, LocationData userLocation) async {
    _locationNearbyList =
        await LocationNearbyService().getLocationNearby(category, userLocation);
    notifyListeners();
  }

  Future<Set<Marker>> getMarkersWithRadius(double radius) async {
    Set<Marker> markers = Set();
    List<LocationNearbyResponse> locationPinCard = [];
    await Future.forEach(_locationNearbyList, (item) async {
      final location = item as LocationNearbyResponse;
      if (location.ditanceFromeUser <= radius / 1000) {
        await markers.add(Marker(
          markerId: MarkerId(location.locationName),
          position: LatLng(location.latitude, location.longitude),
          infoWindow: InfoWindow(
            title: location.locationName,
          ),
          icon: BitmapDescriptor.defaultMarker,
        ));
        locationPinCard.add(location);
      }
    });
    _markers = markers;
    _locationPinCard = locationPinCard;
    notifyListeners();
    return _markers;
  }

  LocationData? get userLocation => _userLocation;
  String get mapStyle => _mapStyle;
  List get radius => _radius;
  double get circleRadius => _circleRadius;
  List get locationCategories => _locationCategories;
  List<LocationNearbyResponse> get locationNearbyList => _locationNearbyList;
  List<LocationNearbyResponse> get locationPinCard => _locationPinCard;
  Set<Marker> get markers => _markers;
}
