import 'package:trip_planner/src/models/place.dart';

class BaggageItemVM {
  late Place _place;
  late bool _isSelected;

  setItem(Place place, bool isSelected) {
    _place = place;
    _isSelected = isSelected;
  }

  setSelected(bool isSelected) {
    _isSelected = !isSelected;
    // print(_isSelected);
  }

  Place get place => _place;
  bool get isSelected => _isSelected;
}
