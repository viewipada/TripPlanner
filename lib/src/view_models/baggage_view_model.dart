import 'package:flutter/foundation.dart';
import 'package:trip_planner/src/models/response/baggage_response.dart';
import 'package:trip_planner/src/services/baggage_service.dart';

class BaggageViewModel with ChangeNotifier {
  List<BaggageResponse> _baggageList = [];
  List<BaggageResponse> _selectedList = [];
  bool _checkboxValue = false;
  bool _isSelected = false;

  Future<void> getBaggageList() async {
    _baggageList = await BaggageService().getBaggageList();
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

  List<BaggageResponse> get baggageList => _baggageList;
  List<BaggageResponse> get selectedList => _selectedList;
  bool get checkboxValue => _checkboxValue;
  bool get isSelected => _isSelected;
}
