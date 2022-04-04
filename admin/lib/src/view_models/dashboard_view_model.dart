import 'package:admin/src/models/location_card_response.dart';
import 'package:admin/src/models/location_detail_response.dart';
import 'package:admin/src/services/dashboard_service.dart';
import 'package:flutter/material.dart';

class DashBoardViewModel with ChangeNotifier {
  final List _dropdownItemList = [
    {'label': 'ทั้งหมด', 'value': 0},
    {'label': 'ที่เที่ยว', 'value': 1},
    {'label': 'ที่กิน', 'value': 2},
    {'label': 'ที่พัก', 'value': 3},
  ];
  bool _isQuery = false;
  List<LocationCardResponse> _locations = [];
  List<LocationCardResponse> _locationsRequest = [];
  List<LocationCardResponse> _queryResult = [];

  Future<void> getLocationBy(int category) async {
    _locations = await DashboardService().getLocationBy(category);
    notifyListeners();
  }

  Future<void> getLocationRequest() async {
    _locationsRequest = await DashboardService().getLocationsRequest();
    notifyListeners();
  }

  void goToCreateLocation(BuildContext context) {
    Navigator.pushNamed(context, '/create');
  }

  void logout(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  void goToLocationDetail(BuildContext context, int locationId) {
    Navigator.of(context)
        .pushNamed('/dashboard/location', arguments: locationId);
  }

  Future<LocationDetailResponse> getLocationDetailById(int locationId) async {
    return await DashboardService().getLocationDetailById(locationId);
  }

  void isSearchMode() {
    _isQuery = false;
    notifyListeners();
  }

  void isQueryMode() {
    _isQuery = true;
    notifyListeners();
  }

  void query(String searchMessage) {
    _queryResult = _locations.where((location) {
      final nameLower = location.locationName.toLowerCase();
      final searchMessageLower = searchMessage.toLowerCase();
      return nameLower.contains(searchMessageLower);
    }).toList();
    notifyListeners();
  }

  Future<int?> updateLocationStatus(
      BuildContext context, int locationId, String status) async {
    final statusCode =
        await DashboardService().updateLocationStatus(locationId, status);
    if (statusCode == 200) {
      Navigator.pop(context);
    }
    return statusCode;
  }

  List get dropdownItemList => _dropdownItemList;
  bool get isQuery => _isQuery;
  List<LocationCardResponse> get locations => _locations;
  List<LocationCardResponse> get locationsRequest => _locationsRequest;
  List<LocationCardResponse> get queryResult => _queryResult;
}
