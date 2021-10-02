import 'package:flutter/foundation.dart';
import 'package:trip_planner/src/models/place.dart';
import 'package:trip_planner/src/view_models/baggage_item.vm.dart';

class BaggageNotifire with ChangeNotifier {
  List<Place> _baggageList = [];
  // bool isSelected = false;

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
    notifyListeners();
  }
}
