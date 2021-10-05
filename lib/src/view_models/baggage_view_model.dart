import 'package:flutter/foundation.dart';
import 'package:trip_planner/src/models/place.dart';
import 'package:trip_planner/src/services/baggage_service.dart';

class BaggageViewModel with ChangeNotifier {
  List<Place> _baggageList = [];
  List<Place> _selectedList = [];
  bool _checkboxValue = false;
  bool _isSelected = false;

  Future<void> getBaggageList() async {
    _baggageList = await BaggageService().getBaggageList();
    notifyListeners();
  }

  Future<void> setCheckboxValue(bool value) async {
    _checkboxValue = await BaggageService().toggleValue(value);
    _selectedList =
        await BaggageService().setAllSelected(_checkboxValue, _baggageList);
    notifyListeners();
  }

  Future<void> toggleSelection(bool isSelected, Place item) async {
    _isSelected = await BaggageService().toggleValue(isSelected);
    _selectedList = await BaggageService()
        .setSelectedList(_isSelected, _selectedList, item, _baggageList);

   
    _checkboxValue =
        await BaggageService().setCheckboxValue(_selectedList, _baggageList);
    notifyListeners();
  }

  List<Place> get baggageList => _baggageList;
  List<Place> get selectedList => _selectedList;
  bool get checkboxValue => _checkboxValue;
  bool get isSelected => _isSelected;
}
