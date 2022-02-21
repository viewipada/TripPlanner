import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:trip_planner/src/models/trip.dart';
import 'package:trip_planner/src/models/trip_item.dart';
import 'package:trip_planner/src/repository/trip_item_operations.dart';
import 'package:trip_planner/src/repository/trips_operations.dart';

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
      'icon': Icons.directions_car_outlined,
      'isSelected': true,
      'title': 'รถยนต์ส่วนตัว'
    },
    {
      'icon': Icons.directions_bike_outlined,
      'isSelected': false,
      'title': 'จักรยาน'
    },
    {
      'icon': Icons.directions_bus_filled_outlined,
      'isSelected': false,
      'title': 'ขนส่งสาธารณะ'
    },
    {
      'icon': Icons.directions_walk_outlined,
      'isSelected': false,
      'title': 'เดินเท้า'
    },
  ];
  IconData _vehiclesSelected = Icons.directions_car_outlined;
  TripsOperations _tripsOperations = TripsOperations();
  TripItemOperations _tripItemOperations = TripItemOperations();

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

  void selectedVehicle(vehicle, Trip trip) {
    vehicles.forEach((element) {
      element['isSelected'] = false;
    });
    vehicle['isSelected'] = true;
    _vehiclesSelected = vehicle['icon'];

    trip.vehicle = vehicle['title'];
    _tripsOperations.updateTrip(trip);

    notifyListeners();
  }

  Future<void> onReorder(
      int oldIndex, int newIndex, List<TripItem> tripItems, Trip trip) async {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    final item = tripItems.removeAt(oldIndex);
    tripItems.insert(newIndex, item);

    await reOrderColumnNo(tripItems);
    trip.firstLocation = tripItems[0].locationName;
    trip.lastLocation = tripItems[tripItems.length - 1].locationName;
    _tripsOperations.updateTrip(trip);
    if (item.startTime != null) {
      calculateStartTimeForTripItem(tripItems);
    }
    // if (newIndex == 0) {
    //   item['distance'] = 'จุดเริ่มต้น';
    //   item['drivingDuration'] = 0;
    // }
    notifyListeners();
  }

  Future<void> reOrderColumnNo(List<TripItem> tripItems) async {
    for (int i = 0; i < tripItems.length; i++) {
      tripItems[i].no = i;
      await _tripItemOperations.updateTripItem(tripItems[i]);
    }
  }

  void setUpStartTime(DateTime time, List<TripItem> tripItems) async {
    tripItems[0].startTime = await time.toIso8601String();
    await calculateStartTimeForTripItem(tripItems);
    notifyListeners();
  }

  Future<void> updateDurationOfTripItem(
      List<TripItem> tripItems, int index, value) async {
    tripItems[index].duration = await value;
    await _tripItemOperations.updateTripItem(tripItems[index]);
    if (tripItems[index].startTime != null) {
      for (int i = index + 1; i < tripItems.length; i++) {
        tripItems[i].startTime =
            await DateTime.parse(tripItems[i - 1].startTime!)
                .add(Duration(
                    minutes: tripItems[i - 1].duration +
                        (tripItems[i].drivingDuration == null
                            ? 0
                            : tripItems[i].drivingDuration!)))
                .toIso8601String();
        await _tripItemOperations.updateTripItem(tripItems[i]);
      }
    }
    notifyListeners();
  }

  Future<void> calculateStartTimeForTripItem(List<TripItem> tripItems) async {
    if (tripItems[0].startTime != null) {
      for (int i = 1; i < tripItems.length; i++) {
        tripItems[i].startTime =
            await DateTime.parse(tripItems[i - 1].startTime!)
                .add(Duration(
                    minutes: tripItems[i - 1].duration +
                        (tripItems[i].drivingDuration == null
                            ? 0
                            : tripItems[i].drivingDuration!)))
                .toIso8601String();
        print(tripItems[i].startTime);
      }

      tripItems.forEach((item) async {
        await _tripItemOperations.updateTripItem(item);
      });
    }
  }

  Future<List> getVehicleSelection(Trip trip) async {
    if (trip.vehicle == null) {
      _vehicles.forEach((element) async {
        element['isSelected'] = await false;
      });
      _vehicles[0]['isSelected'] = await true;
      _vehiclesSelected = await _vehicles[0]['icon'];
      trip.vehicle = await _vehicles[0]['title'];
      await _tripsOperations.updateTrip(trip);
    } else {
      _vehicles.forEach((element) async {
        element['isSelected'] = await false;
        if (element['title'] == trip.vehicle) {
          element['isSelected'] = await true;
          _vehiclesSelected = await element['icon'];
        }
      });
    }
    return _vehicles;
  }

  Future<void> deleteTripItem(
      Trip trip, List<TripItem> tripItems, TripItem item) async {
    await tripItems.remove(item);
    await reOrderColumnNo(tripItems);
    trip.firstLocation = await tripItems[0].locationName;
    trip.lastLocation = await tripItems[tripItems.length - 1].locationName;
    trip.totalTripItem = await tripItems.length;
    await _tripsOperations.updateTrip(trip);
    await _tripItemOperations.deleteTripItem(item);
    if (item.startTime != null) {
      await calculateStartTimeForTripItem(tripItems);
    }
    notifyListeners();
  }

  Future<List<int>> recommendMeal(List<TripItem> tripItems) async {
    List<int> _mealsIndex = [];
    if (tripItems[0].startTime != null) {
      _mealsIndex = [0, 0, 0];
      _mealsIndex[0] = await tripItems.indexWhere(
        (element) => DateTime.parse(element.startTime!).hour >= 9,
      );
      _mealsIndex[1] = await tripItems.indexWhere(
        (element) => DateTime.parse(element.startTime!).hour >= 12,
      );
      _mealsIndex[2] = await tripItems.indexWhere(
        (element) => DateTime.parse(element.startTime!).hour >= 18,
      );
    }
    return _mealsIndex;
  }

  List get steps => _steps;
  int get index => _index;
  List get vehicles => _vehicles;
  IconData get vehiclesSelected => _vehiclesSelected;
}
