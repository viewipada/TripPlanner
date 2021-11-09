import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:trip_planner/src/view/screens/my_location_page.dart';
import 'package:flutter/services.dart' show rootBundle;

class SearchViewModel with ChangeNotifier {
  bool _serviceEnabled = false;
  PermissionStatus _permissionGranted = PermissionStatus.denied;
  LocationData? _userLocation;
  String _mapStyle = '';

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

  void goToMyLocationPage(BuildContext context, String catagory) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyLocationPage(),
      ),
    );
  }

  LocationData? get userLocation => _userLocation;
  String get mapStyle => _mapStyle;
}
