import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:trip_planner/src/models/response/baggage_response.dart';
import 'package:trip_planner/src/services/baggage_service.dart';
import 'package:trip_planner/src/view/screens/location_detail_page.dart';

class BaggageViewModel with ChangeNotifier {
  late List<BaggageResponse> _baggageList;
  List<BaggageResponse> _selectedList = [];
  bool _checkboxValue = false;
  bool _isSelected = false;
  bool _selectMode = false;

  Future<List<BaggageResponse>> getBaggageList() async {
    _baggageList = await BaggageService().getBaggageList();
    return _baggageList;
  }

  Future<void> deleteItem(BaggageResponse item) async {
    baggageList.remove(item);
    // await BaggageService().deleteItem()
    notifyListeners();
  }

  void setCheckboxValue(bool value) {
    _checkboxValue = BaggageService().toggleValue(value);
    _selectedList =
        BaggageService().setAllSelected(_checkboxValue, _baggageList);
    notifyListeners();
  }

  void toggleSelection(bool isSelected, BaggageResponse item) {
    _isSelected = BaggageService().toggleValue(isSelected);
    _selectedList = BaggageService()
        .setSelectedList(_isSelected, _selectedList, item, _baggageList);
    _checkboxValue =
        BaggageService().setCheckboxValue(_selectedList, _baggageList);
    notifyListeners();
  }

  void changeMode(bool selectMode) {
    _selectMode = !selectMode;
    notifyListeners();
  }

  void clearWidget(BuildContext context) {
    Navigator.pop(context);
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

  List<BaggageResponse> get baggageList => _baggageList;
  List<BaggageResponse> get selectedList => _selectedList;
  bool get checkboxValue => _checkboxValue;
  bool get isSelected => _isSelected;
  bool get selectMode => _selectMode;
}
