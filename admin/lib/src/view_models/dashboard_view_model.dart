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
  List<LocationCardResponse>? _locationsRequest;
  List<LocationCardResponse> _queryResult = [];

  Future<void> getLocationBy(int category) async {
    _locations = await DashboardService().getLocationBy(category);
    notifyListeners();
  }

  Future<void> getLocationRequest() async {
    _locationsRequest = await DashboardService().getLocationsRequest();
    notifyListeners();
  }

  void clearLocationList() {
    _locationsRequest = null;
    _locations = [];
    notifyListeners();
  }

  Future<void> goToCreateLocation(BuildContext context) async {
    final res = await Navigator.pushNamed(context, '/create');
    if (res != null) {
      await getLocationBy(0);
    }
  }

  void logout(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  Future<void> goToLocationDetail(BuildContext context, int locationId) async {
    final res = await Navigator.of(context)
        .pushNamed('/dashboard/location', arguments: locationId);
    if (res != null) {
      if (res == 'update') clearLocationList();
      await getLocationRequest();
      await getLocationBy(0);
      isSearchMode();
    }
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
      Navigator.pop(context, 'update');
    }
    return statusCode;
  }

  Future<int?> deleteLocation(BuildContext context, int locationId) async {
    final status = await DashboardService().deleteLocation(locationId);
    if (status == 200) {
      Navigator.pop(context, 'delete');
    }
    return status;
  }

  List get dropdownItemList => _dropdownItemList;
  bool get isQuery => _isQuery;
  List<LocationCardResponse> get locations => _locations;
  List<LocationCardResponse>? get locationsRequest => _locationsRequest;
  List<LocationCardResponse> get queryResult => _queryResult;
}
