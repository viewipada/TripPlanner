import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:trip_planner/src/models/response/location_detail_response.dart';
import 'package:trip_planner/src/services/location_service.dart';

class LocationDetailViewModel with ChangeNotifier {
  bool _readMore = false;
  late LocationDetailResponse _locationDetail;

  void toggleReadmoreButton() {
    _readMore = !_readMore;
    notifyListeners();
  }

  void goBack(BuildContext context) {
    Navigator.pop(context);
  }

  Future<void> getLocationDetailById(int locationId) async {
    _locationDetail = await LocationService().getLocationDetailById(locationId);
    notifyListeners();
  }

  bool get readMore => _readMore;
  LocationDetailResponse get locationDetail => _locationDetail;
}
