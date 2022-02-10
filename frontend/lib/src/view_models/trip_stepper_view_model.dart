import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TripStepperViewModel with ChangeNotifier {
  int _index = 0;
  List _steps = [
    {
      'icon': Icons.directions_car_outlined,
      'iconActived': Icons.directions_car_rounded,
      'title': 'พาหนะ'
    },
    {
      'icon': Icons.camera_alt_outlined,
      'iconActived': Icons.camera_alt_rounded,
      'title': 'ที่เที่ยว'
    },
    {
      'icon': Icons.fastfood_outlined,
      'iconActived': Icons.fastfood_rounded,
      'title': 'ที่กิน'
    },
    {
      'icon': Icons.hotel_outlined,
      'iconActived': Icons.hotel_rounded,
      'title': 'ที่พัก'
    },
    {
      'icon': Icons.shopping_bag_outlined,
      'iconActived': Icons.shopping_bag_rounded,
      'title': 'ที่ช้อป'
    },
  ];

  List _vehicles = [
    {
      'icon': Icon(
        Icons.directions_car_outlined,
      ),
      'isSelected': true,
      'title': 'รถยนต์ส่วนตัว'
    },
    {
      'icon': Icon(
        Icons.directions_bike_outlined,
        size: 22,
      ),
      'isSelected': false,
      'title': 'จักรยาน'
    },
    {
      'icon': Icon(
        Icons.directions_bus_filled_outlined,
      ),
      'isSelected': false,
      'title': 'ขนส่งสาธารณะ'
    },
    {
      'icon': Icon(
        Icons.directions_walk_outlined,
      ),
      'isSelected': false,
      'title': 'เดินเท้า'
    },
  ];
  List<int> _items = List<int>.generate(50, (int index) => index);

  void go(int index) {
    if (index == -1 && _index <= 0) {
      print("it's first Step!");
      return;
    }

    if (index == 1 && _index >= _steps.length - 1) {
      print("it's last Step!");
      return;
    }

    _index += index;
    notifyListeners();
  }

  void setStepOnTapped(int index) {
    _index = index;
    notifyListeners();
  }

  void selectedVehicle(vehicle) {
    vehicles.forEach((element) {
      element['isSelected'] = false;
    });
    vehicle['isSelected'] = true;
    notifyListeners();
  }

  void onReorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final int item = _items.removeAt(oldIndex);
    _items.insert(newIndex, item);
    notifyListeners();
  }

  List get steps => _steps;
  int get index => _index;
  List get vehicles => _vehicles;
  List<int> get items => _items;
}
