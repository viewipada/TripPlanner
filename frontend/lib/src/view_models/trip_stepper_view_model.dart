import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:trip_planner/src/models/response/location_recommend_response.dart';
import 'package:trip_planner/src/models/trip.dart';
import 'package:trip_planner/src/models/trip_item.dart';
import 'package:trip_planner/src/repository/trip_item_operations.dart';
import 'package:trip_planner/src/repository/trips_operations.dart';
import 'package:trip_planner/src/services/location_service.dart';
import 'package:trip_planner/src/view/screens/location_detail_page.dart';
import 'package:trip_planner/src/view/screens/location_recommend_page.dart';

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
  List<int> _mealsIndex = [];
  bool _startTimeIsValid = true;
  List<LocationRecommendResponse> _locationRecommend = [];

  void go(int index) {
    if (index == -1 && _index <= 0) {
      print("it's first Step!");
      return;
    }

    if (index == 1 && _index >= _steps.length - 1) {
      print("it's last Step!");
      return;
    }

    if (_startTimeIsValid) _index += index;

    notifyListeners();
  }

  void setStepOnTapped(int index) {
    if (_startTimeIsValid && index <= _index || index == 0) _index = index;
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
    List<int> realIndex = [];
    var indexWithoutMeals = await tripItems.where((element) => element.no >= 0);
    indexWithoutMeals.forEach((element) {
      realIndex.add(tripItems.indexOf(element));
    });

    trip.firstLocation = await tripItems[realIndex[0]].locationName;
    trip.lastLocation =
        await tripItems[realIndex[realIndex.length - 1]].locationName;
    // trip.totalTripItem = await realIndex.length;
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
    int index = 0, loop = 0;
    while (loop < tripItems.length) {
      if (tripItems[loop].no >= 0) {
        tripItems[loop].no = index;
        await _tripItemOperations.updateTripItem(tripItems[loop]);
        index++;
      }
      loop++;
    }
  }

  void setUpStartTime(
      DateTime time, List<TripItem> tripItems, int index) async {
    tripItems[index].startTime = await time.toIso8601String();
    await calculateStartTimeForTripItem(tripItems);
    notifyListeners();
  }

  Future<void> updateDurationOfTripItem(
      List<TripItem> tripItems, int index, value) async {
    tripItems[index].duration = await value;
    await _tripItemOperations.updateTripItem(tripItems[index]);
    if (tripItems[index].startTime != null) {
      await calculateStartTimeForTripItem(tripItems);
    }
    notifyListeners();
  }

  Future<void> calculateStartTimeForTripItem(List<TripItem> tripItems) async {
    if (tripItems[0].startTime != null && tripItems[0].no >= 0 ||
        tripItems[0].no < 0 && tripItems[1].startTime != null) {
      List<int> realIndex = [];
      var indexWithoutMeals =
          await tripItems.where((element) => element.no >= 0);
      indexWithoutMeals.forEach((element) {
        realIndex.add(tripItems.indexOf(element));
      });
      for (int i = 1; i < realIndex.length; i++) {
        tripItems[realIndex[i]].startTime =
            await DateTime.parse(tripItems[realIndex[i - 1]].startTime!)
                .add(Duration(
                    minutes: tripItems[realIndex[i - 1]].duration +
                        (tripItems[realIndex[i]].drivingDuration == null
                            ? 0
                            : tripItems[realIndex[i]].drivingDuration!)))
                .toIso8601String();
      }
      tripItems.forEach((item) async {
        if (item.no >= 0) await _tripItemOperations.updateTripItem(item);
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

    List<int> realIndex = [];
    var indexWithoutMeals = await tripItems.where((element) => element.no >= 0);
    indexWithoutMeals.forEach((element) {
      realIndex.add(tripItems.indexOf(element));
    });

    trip.firstLocation = await tripItems[realIndex[0]].locationName;
    trip.lastLocation =
        await tripItems[realIndex[realIndex.length - 1]].locationName;
    trip.totalTripItem = await realIndex.length;

    await _tripsOperations.updateTrip(trip);
    await _tripItemOperations.deleteTripItem(item);
    if (item.startTime != null) {
      await calculateStartTimeForTripItem(tripItems);
    }
    notifyListeners();
  }

  List<int> recommendMeal(List<TripItem> tripItems) {
    _mealsIndex = [];
    if (tripItems[0].startTime != null) {
      _mealsIndex = [0, 0, 0];
      _mealsIndex[0] = tripItems.indexWhere(
        (element) => DateTime.parse(element.startTime!).hour >= 9,
      );
      _mealsIndex[1] = tripItems.indexWhere(
        (element) => DateTime.parse(element.startTime!).hour >= 12,
      );
      _mealsIndex[2] = tripItems.indexWhere(
        (element) => DateTime.parse(element.startTime!).hour >= 18,
      );
    }
    return _mealsIndex;
  }

  Future<List<TripItem>> getMeals(List<TripItem> tripItems, int tripId) async {
    final mealItem = TripItem(
        day: 1,
        no: -1,
        locationId: -1,
        locationCategory: '',
        locationName: "",
        imageUrl: '',
        latitude: 0,
        longitude: 0,
        duration: 0,
        tripId: tripId);
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
      final _mealsUniqueIndex = _mealsIndex.toSet().toList();

      for (int i = _mealsUniqueIndex.length - 1; i >= 0; i--) {
        if (_mealsUniqueIndex[i] != -1) {
          tripItems.insert(_mealsUniqueIndex[i], mealItem);
        }
      }
      // tripItems.forEach((e) => print(e.locationName));
    }
    return tripItems;
    // notifyListeners();
  }

  void deleteAddMealButton(int index, List<TripItem> tripItems) async {
    await tripItems.removeAt(index);
    notifyListeners();
  }

  void isStartTimeValid(startTime) {
    if (startTime == null && _index == 1)
      _startTimeIsValid = false;
    else
      _startTimeIsValid = true;
  }

  void goToLocationRecommendPage(BuildContext context, List<TripItem> tripItems,
      int index, Trip trip) async {
    final LocationRecommendResponse? result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              LocationRecommendPage(locationCategory: 'ที่กิน')),
    );

    if (result != null && trip.tripId != null) {
      var item = TripItem(
          day: 1,
          no: index,
          locationId: result.locationId,
          locationCategory: result.category,
          locationName: result.locationName,
          imageUrl: result.imageUrl,
          latitude: result.latitude,
          longitude: result.longitude,
          duration: result.duration,
          tripId: trip.tripId!);

      item.distance = result.distance;

      tripItems.replaceRange(index, index + 1, [item]);

      int tripItemId = await _tripItemOperations.createTripItem(item);
      item.itemId = tripItemId;
      await reOrderColumnNo(tripItems);
      await calculateStartTimeForTripItem(tripItems);

      List<int> realIndex = [];
      var indexWithoutMeals =
          await tripItems.where((element) => element.no >= 0);
      indexWithoutMeals.forEach((element) {
        realIndex.add(tripItems.indexOf(element));
      });
      trip.firstLocation = await tripItems[realIndex[0]].locationName;
      trip.lastLocation =
          await tripItems[realIndex[realIndex.length - 1]].locationName;
      trip.totalTripItem = await realIndex.length;
    }
    notifyListeners();
  }

  Future<List<LocationRecommendResponse>> getLocationRecommend() async {
    _locationRecommend = await LocationService().getLocationRecommend();
    // print(_locationRecommend);
    return _locationRecommend;
    // notifyListeners();
  }

  void goToLocationDetail(BuildContext context, int locationId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LocationDetailPage(locationId: locationId),
      ),
    );
  }

  void selectedLocation(
      BuildContext context, LocationRecommendResponse location) {
    Navigator.pop(context, location);
  }

  List get steps => _steps;
  int get index => _index;
  List get vehicles => _vehicles;
  IconData get vehiclesSelected => _vehiclesSelected;
  List<int> get mealsIndex => _mealsIndex;
  bool get startTimeIsValid => _startTimeIsValid;
  List<LocationRecommendResponse> get locationRecommend => _locationRecommend;
}
