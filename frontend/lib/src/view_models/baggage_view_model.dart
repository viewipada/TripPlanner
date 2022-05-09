import 'package:flutter/material.dart';
import 'package:trip_planner/src/models/response/baggage_response.dart';
import 'package:trip_planner/src/services/baggage_service.dart';
import 'package:trip_planner/src/view/screens/location_detail_page.dart';
import 'package:trip_planner/src/view/screens/search_start_point_page.dart';

class BaggageViewModel with ChangeNotifier {
  List<BaggageResponse> _baggageList = [];
  List<BaggageResponse> _selectedList = [];
  bool _checkboxValue = false;
  bool _isSelected = false;
  bool _selectMode = false;

  final _baggageService = BaggageService();

  Future<void> getBaggageList() async {
    _selectedList = [];
    _baggageList = await _baggageService.getBaggageList();
    notifyListeners();
  }

  Future<void> deleteItem(BaggageResponse item) async {
    baggageList.remove(item);
    await BaggageService().removeBaggageItem(item.locationId);
    notifyListeners();
  }

  void setCheckboxValue(bool checkboxValue) {
    _checkboxValue = !checkboxValue;
    _selectedList =
        _baggageService.setAllSelected(_checkboxValue, _baggageList);
    notifyListeners();
  }

  void toggleSelection(bool isSelected, BaggageResponse item) {
    _isSelected = !isSelected;

    if (_isSelected) {
      _selectedList.add(item);
    } else {
      _selectedList.remove(item);
    }

    _checkboxValue =
        _baggageService.setCheckboxValue(_selectedList, _baggageList);
    notifyListeners();
  }

  void changeMode(bool selectMode) {
    _selectMode = !selectMode;
    notifyListeners();
  }

  void clearWidget(BuildContext context) {
    Navigator.pop(context, 'refresh');
    _baggageList = [];
    _selectedList = [];
    _checkboxValue = false;
    _isSelected = false;
    _selectMode = false;
    notifyListeners();
  }

  void goToLocationDetail(BuildContext context, int locationId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LocationDetailPage(locationId: locationId),
      ),
    );
  }

  void goToCreateTripForm(
      BuildContext context, List<BaggageResponse> selectedList) {
    Navigator.of(context).pop();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchStartPointPage(
            startPointList: selectedList, startPointValue: false),
      ),
    );
  }

  List<BaggageResponse> get baggageList => _baggageList;
  List<BaggageResponse> get selectedList => _selectedList;
  bool get checkboxValue => _checkboxValue;
  bool get isSelected => _isSelected;
  bool get selectMode => _selectMode;
}
