import 'package:flutter/foundation.dart';
import 'package:trip_planner/src/models/place.dart';
import 'package:trip_planner/src/view_models/baggage_item.vm.dart';

class BaggageNotifire with ChangeNotifier {
  List<Place> _baggageList = [];
  List<Place> _itemSelectedList = [];

  setBaggageList(List<Place> baggageList) {
    // _baggageList = [];
    _baggageList = baggageList;
    notifyListeners();
  }

  List<Place> getBaggageList() {
    return _baggageList;
  }

  toggleSelection(BaggageItemVM baggageItemVM) {
    baggageItemVM.setSelected(baggageItemVM.isSelected);
    if (baggageItemVM.isSelected == true) {
      _itemSelectedList.add(baggageItemVM.place);
    } else {
      _itemSelectedList.remove(baggageItemVM.place);
    }
    notifyListeners();
  }

  List<Place> getItemSelectionList() {
    return _itemSelectedList;
  }
}
