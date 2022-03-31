import 'package:flutter/material.dart';
import 'package:trip_planner/src/models/response/location_detail_response.dart';
import 'package:trip_planner/src/services/baggage_service.dart';
import 'package:trip_planner/src/services/location_service.dart';
import 'package:trip_planner/src/view/screens/review_page.dart';

class LocationDetailViewModel with ChangeNotifier {
  bool _readMore = false;
  late LocationDetailResponse _locationDetail;

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

  bool get readMore => _readMore;
  LocationDetailResponse get locationDetail => _locationDetail;
}
