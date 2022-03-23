import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:math' show cos, sqrt, asin;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:trip_planner/assets.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/src/models/response/baggage_response.dart';
import 'package:trip_planner/src/models/response/location_recommend_response.dart';
import 'package:trip_planner/src/models/response/shop_response.dart';
import 'package:trip_planner/src/models/trip.dart';
import 'package:trip_planner/src/models/trip_item.dart';
import 'package:trip_planner/src/repository/trip_item_operations.dart';
import 'package:trip_planner/src/repository/trips_operations.dart';
import 'package:trip_planner/src/services/baggage_service.dart';
import 'package:trip_planner/src/services/location_service.dart';
import 'package:trip_planner/src/view/screens/add_from_baggage_page.dart';
import 'package:trip_planner/src/view/screens/baggage_location_on_route_page.dart';
import 'package:trip_planner/src/view/screens/confirm_trip_page.dart';
import 'package:trip_planner/src/view/screens/location_detail_page.dart';
import 'package:trip_planner/src/view/screens/location_recommend_page.dart';
import 'package:trip_planner/src/view/screens/recommend_on_route_page.dart';
import 'package:trip_planner/src/view/screens/route_on_map_page.dart';
import 'package:trip_planner/src/view/screens/shop_location_on_route_page.dart';
import 'package:trip_planner/src/view/screens/trip_stepper_page.dart';

class TripStepperViewModel with ChangeNotifier {
  int _index = 0;
  List _steps = [
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

  IconData _vehiclesSelected = Icons.directions_car_outlined;
  TripsOperations _tripsOperations = TripsOperations();
  TripItemOperations _tripItemOperations = TripItemOperations();
  List<int> _mealsIndex = [];
  bool _startTimeIsValid = true;
  bool _startPointIsValid = true;
  List<LocationRecommendResponse> _locationRecommend = [];
  int _day = 1;
  ShopResponse? _shop;
  int? _shopId;
  int _daySelected = 0;

  Map<PolylineId, Polyline> _polylines = {};
  List<LatLng> _polylineCoordinates = [];
  PolylinePoints _polylinePoints = PolylinePoints();
  String googleAPiKey = GoogleAssets.googleAPI;
  String _mapStyle = '';

  ItemScrollController _itemScrollController = ItemScrollController();

  void go(int index, BuildContext context, Trip trip) async {
    if (index == -1 && _index <= 0) {
      print("it's first Step!");
      return;
    }

    if (index == 1 && _index >= _steps.length - 1) {
      print("it's last Step!");

      if (_shop != null) {
        await _tripItemOperations
            .getAllTripItemsByTripIdAndDay(trip.tripId!, _daySelected)
            .then((value) async {
          TripItem item = TripItem(
              day: _daySelected,
              no: value.length,
              locationId: _shop!.locationId,
              locationCategory: 'ของฝาก',
              locationName: _shop!.locationName,
              imageUrl: _shop!.imageUrl,
              latitude: _shop!.latitude,
              longitude: _shop!.longitude,
              startTime: DateTime.parse(value.last.startTime!)
                  .add(Duration(minutes: value.last.duration))
                  .toIso8601String(),
              duration: _shop!.duration,
              tripId: trip.tripId!);
          await getPolylineBetweenTwoPoint(value.last, item)
              .then((polyLines) async {
            item.distance = await calculateDistance(polyLines);
            item.drivingDuration = await ((item.distance! / 80) * 60).toInt();
            _tripItemOperations
                .createTripItem(item)
                .then((value) => _shopId = value);
          });
        });

        trip.lastLocation = await getAllTripItemsByTripId(trip.tripId!)
            .then((locations) => locations[locations.length - 1].locationName);
        trip.totalTripItem += 1;
        await _tripsOperations.updateTrip(trip);
      }

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ConfirmTripPage(trip: trip)),
      );

      return;
    }

    if (_startTimeIsValid) _index += index;

    notifyListeners();
  }

  void setStepOnTapped(int index) {
    if (_startTimeIsValid && index <= _index || index == 0) _index = index;
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

    trip.firstLocation = await getAllTripItemsByTripId(trip.tripId!)
        .then((locations) => locations[0].locationName);
    trip.lastLocation = await getAllTripItemsByTripId(trip.tripId!)
        .then((locations) => locations[locations.length - 1].locationName);
    await _tripsOperations.updateTrip(trip);

    // if (newIndex == 0) {
    //   item.distance = null;
    //   // item['drivingDuration'] = 0;
    //   await _tripItemOperations.updateTripItem(item);
    // }
    if (item.startTime != null) {
      await calculateStartTimeForTripItem(tripItems);
    }
    notifyListeners();

    if (_index == 1) {
      List<int> realIndex = [];
      int minIndex = newIndex < oldIndex ? newIndex : oldIndex;
      var indexWithoutMeals = await tripItems
          .where((element) => element.no >= 0 && element.day == _day);
      Future.forEach(indexWithoutMeals, (TripItem element) {
        realIndex.add(tripItems.indexOf(element));
      }).then((value) async {
        for (int i = 0; i < realIndex.length; i++) {
          if (realIndex[i] > 0 && realIndex[i] > minIndex)
            await getPolylineBetweenTwoPoint(
                    tripItems[realIndex[i - 1]], tripItems[realIndex[i]])
                .then((polyLines) async {
              tripItems[realIndex[i]].distance =
                  await calculateDistance(polyLines);
              tripItems[realIndex[i]].drivingDuration =
                  await ((tripItems[realIndex[i]].distance! / 80) * 60).toInt();
              await _tripItemOperations.updateTripItem(tripItems[realIndex[i]]);
            });
          notifyListeners();
        }
      });
    } else {
      for (int i = newIndex < oldIndex ? newIndex : oldIndex;
          i < tripItems.length;
          i++) {
        if (i > 0)
          await getPolylineBetweenTwoPoint(tripItems[i - 1], tripItems[i])
              .then((polyLines) async {
            tripItems[i].distance = await calculateDistance(polyLines);
            tripItems[i].drivingDuration =
                await ((tripItems[i].distance! / 80) * 60).toInt();
            await _tripItemOperations.updateTripItem(tripItems[i]);
          });
        notifyListeners();
      }
    }
  }

  Future<void> reOrderColumnNo(List<TripItem> tripItems) async {
    int index = 0, loop = 0;
    while (loop < tripItems.length) {
      if (tripItems[loop].no >= 0 && tripItems[loop].day == _day) {
        tripItems[loop].no = index;
        if (index == 0) {
          tripItems[loop].distance = null;
          tripItems[loop].drivingDuration = null;
        }
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
    if ((tripItems.isNotEmpty &&
            tripItems[0].startTime != null &&
            tripItems[0].no >= 0) ||
        (tripItems.isNotEmpty &&
            tripItems[0].no < 0 &&
            tripItems[1].startTime != null)) {
      List<int> realIndex = [];
      var indexWithoutMeals = await tripItems
          .where((element) => element.no >= 0 && element.day == _day);
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

  Future<void> deleteTripItem(
      Trip trip, List<TripItem> tripItems, TripItem item) async {
    int indexRemoved = tripItems.indexOf(item);
    List<int> realIndex = [];
    var indexWithoutMeals = await tripItems
        .where((element) => element.no >= 0 && element.day == _day);
    indexWithoutMeals.forEach((element) {
      realIndex.add(tripItems.indexOf(element));
    });

    int boforeRemovedItem =
        realIndex.lastIndexWhere((element) => element < indexRemoved);
    int afterRemovedItem = realIndex
        .firstWhere((element) => element > indexRemoved, orElse: () => -1);

    if (afterRemovedItem != -1 && boforeRemovedItem != -1)
      await getPolylineBetweenTwoPoint(
              tripItems[boforeRemovedItem], tripItems[afterRemovedItem])
          .then((polyLines) async {
        tripItems[afterRemovedItem].distance =
            await calculateDistance(polyLines).toDouble();
        tripItems[afterRemovedItem].drivingDuration =
            await ((tripItems[afterRemovedItem].distance! / 80) * 60).toInt();
        await _tripItemOperations.updateTripItem(tripItems[afterRemovedItem]);
      });

    await tripItems.remove(item);
    await _tripItemOperations.deleteTripItem(item);
    await reOrderColumnNo(tripItems);

    trip.firstLocation = await getAllTripItemsByTripId(trip.tripId!)
        .then((locations) => locations[0].locationName);
    trip.lastLocation = await getAllTripItemsByTripId(trip.tripId!)
        .then((locations) => locations[locations.length - 1].locationName);
    trip.totalTripItem = await getAllTripItemsByTripId(trip.tripId!)
        .then((locations) => locations.length);

    await _tripsOperations.updateTrip(trip);

    if (item.startTime != null) {
      await calculateStartTimeForTripItem(tripItems);
    }
    notifyListeners();
  }

  List<int> recommendMeal(List<TripItem> tripItems) {
    _mealsIndex = [];
    if (tripItems[0].startTime != null && tripItems.isNotEmpty) {
      _mealsIndex = [0, 0, 0];
      _mealsIndex[0] = tripItems.indexWhere(
        (element) => DateTime.parse(element.startTime!).hour >= 8,
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

  int recommendToStop(List<TripItem> tripItems) {
    int index = -1;
    var _tripItemsAtDay;
    if (_index == 1)
      _tripItemsAtDay = tripItems
          .where((element) => element.day == _day && element.no >= 0)
          .toList();
    else
      _tripItemsAtDay = tripItems;

    if (_tripItemsAtDay.first.startTime != null && _tripItemsAtDay.isNotEmpty) {
      index = tripItems.indexWhere(
        (element) =>
            element.no >= 0 &&
            element.day == _day &&
            DateTime.parse(element.startTime!)
                    .add(Duration(minutes: element.duration))
                    .hour >=
                19,
      );
    }
    return index;
  }

  Future<List<TripItem>> getMeals(
      List<TripItem> tripItems, int tripId, int totalDay) async {
    List<int> _mealsItemIndex = [];
    List<TripItem> _mealsItem = [];

    for (int i = 1; i <= totalDay; i++) {
      var _tripItems = tripItems.where((element) => element.day == i).toList();
      if (_tripItems.isNotEmpty && _tripItems[0].startTime != null) {
        final mealItem = TripItem(
            day: i,
            no: -1,
            locationId: -1,
            locationCategory: '',
            locationName: "",
            imageUrl: '',
            latitude: 0,
            longitude: 0,
            duration: 0,
            tripId: tripId);

        _mealsIndex = [];

        _mealsIndex.add(await tripItems.indexWhere(
          (element) =>
              DateTime.parse(element.startTime!).hour >= 8 && element.day == i,
        ));
        _mealsIndex.add(await tripItems.indexWhere(
          (element) =>
              DateTime.parse(element.startTime!).hour >= 12 && element.day == i,
        ));
        _mealsIndex.add(await tripItems.indexWhere(
          (element) =>
              DateTime.parse(element.startTime!).hour >= 18 && element.day == i,
        ));

        final _mealsUniqueIndex = _mealsIndex.toSet().toList();
        for (int i = 0; i < _mealsUniqueIndex.length; i++) {
          _mealsItemIndex.add(_mealsUniqueIndex[i]);
          _mealsItem.add(mealItem);
        }
      }
    }

    for (int i = _mealsItemIndex.length - 1; i >= 0; i--) {
      if (_mealsItemIndex[i] != -1) {
        tripItems.insert(_mealsItemIndex[i], _mealsItem[i]);
      }
    }

    return tripItems;
    // notifyListeners();
  }

  void deleteAddMealButton(int index, List<TripItem> tripItems) async {
    await tripItems.removeAt(index);
    notifyListeners();
  }

  void isStartTimeValid(List<TripItem> tripItems, List<int> days) {
    var firstLocationOfADay = [];
    var checkLocationForEachDay = [];

    if (tripItems.isNotEmpty)
      days.forEach((day) {
        firstLocationOfADay.add(tripItems.indexWhere(
            (element) => element.day == day && element.startTime != null));
        checkLocationForEachDay
            .add(tripItems.indexWhere((element) => element.day == day));
      });

    if (firstLocationOfADay.contains(-1) && (_index == 0 || _index == 1))
      _startTimeIsValid = false;
    else
      _startTimeIsValid = true;

    if (checkLocationForEachDay.contains(-1) && (_index == 0 || _index == 1))
      _startPointIsValid = false;
    else
      _startPointIsValid = true;
  }

  void goToLocationRecommendPage(BuildContext context, List<TripItem> tripItems,
      int index, Trip trip, String locationCategory) async {
    final LocationRecommendResponse? result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => LocationRecommendPage(
              locationCategory: locationCategory, tripItems: tripItems)),
    );

    if (result != null && trip.tripId != null) {
      var item = TripItem(
          day: _day,
          no: index,
          locationId: result.locationId,
          locationCategory: result.category,
          locationName: result.locationName,
          imageUrl: result.imageUrl,
          latitude: result.latitude,
          longitude: result.longitude,
          duration: result.duration * 60,
          tripId: trip.tripId!);

      if (index == tripItems.length && index > 0) {
        await getPolylineBetweenTwoPoint(tripItems[index - 1], item)
            .then((polyLines) async {
          item.distance = await calculateDistance(polyLines).toDouble();
          item.drivingDuration = await ((item.distance! / 80) * 60).toInt();
          int tripItemId = await _tripItemOperations.createTripItem(item);
          item.itemId = tripItemId;
        });
        tripItems.add(item);
      } else {
        int tripItemId = await _tripItemOperations.createTripItem(item);
        item.itemId = tripItemId;
        tripItems.isNotEmpty
            ? tripItems.replaceRange(index, index + 1, [item])
            : tripItems.add(item);

        List<int> _realIndex = [];
        var _indexWithoutMeals = await tripItems
            .where((element) => element.no >= 0 && element.day == _day);
        _indexWithoutMeals.forEach((element) {
          _realIndex.add(tripItems.indexOf(element));
        });
        tripItems[_realIndex[0]].distance = null;
        tripItems[_realIndex[0]].drivingDuration = null;
        await _tripItemOperations.updateTripItem(tripItems[_realIndex[0]]);

        for (int i = 1; i < _realIndex.length; i++) {
          if (_realIndex[i] >= index) {
            await getPolylineBetweenTwoPoint(
                    tripItems[_realIndex[i - 1]], tripItems[_realIndex[i]])
                .then((polyLines) async {
              tripItems[_realIndex[i]].distance =
                  await calculateDistance(polyLines).toDouble();
              tripItems[_realIndex[i]].drivingDuration =
                  await ((tripItems[_realIndex[i]].distance! / 80) * 60)
                      .toInt();
              await _tripItemOperations
                  .updateTripItem(tripItems[_realIndex[i]]);
            });
          }
        }
      }

      trip.firstLocation = await getAllTripItemsByTripId(trip.tripId!)
          .then((locations) => locations[0].locationName);
      trip.lastLocation = await getAllTripItemsByTripId(trip.tripId!)
          .then((locations) => locations[locations.length - 1].locationName);
      trip.totalTripItem = await getAllTripItemsByTripId(trip.tripId!)
          .then((locations) => locations.length);
      _tripsOperations.updateTrip(trip);

      List<int> realIndex = [];
      var indexWithoutMeals = await tripItems
          .where((element) => element.no >= 0 && element.day == _day);
      indexWithoutMeals.forEach((element) {
        realIndex.add(tripItems.indexOf(element));
      });

      await reOrderColumnNo(tripItems);
      if (tripItems[realIndex[0]].startTime != null)
        await calculateStartTimeForTripItem(tripItems);
      else
        realIndex.forEach((element) {
          tripItems[element].startTime = null;
          _tripItemOperations.updateTripItem(tripItems[element]);
        });
    }
    notifyListeners();
  }

  void goToAddFromBaggagePage(BuildContext context, List<TripItem> tripItems,
      int index, Trip trip) async {
    final BaggageResponse? result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddFromBaggagePage(tripItems: tripItems)),
    );

    if (result != null && trip.tripId != null) {
      var item = TripItem(
          day: _day,
          no: index,
          locationId: result.locationId,
          locationCategory: result.category,
          locationName: result.locationName,
          imageUrl: result.imageUrl,
          latitude: result.latitude,
          longitude: result.longitude,
          duration: result.duration * 60,
          tripId: trip.tripId!);

      if (index > 0) {
        await getPolylineBetweenTwoPoint(tripItems.last, item)
            .then((polyLines) async {
          item.distance = await calculateDistance(polyLines);
          item.drivingDuration = await ((item.distance! / 80) * 60).toInt();
          int tripItemId = await _tripItemOperations.createTripItem(item);
          item.itemId = tripItemId;
        });
      } else {
        int tripItemId = await _tripItemOperations.createTripItem(item);
        item.itemId = tripItemId;
      }

      tripItems.add(item);

      List<int> realIndex = [];
      var indexWithoutMeals = await tripItems
          .where((element) => element.no >= 0 && element.day == _day);
      indexWithoutMeals.forEach((element) {
        realIndex.add(tripItems.indexOf(element));
      });
      trip.firstLocation = await getAllTripItemsByTripId(trip.tripId!)
          .then((locations) => locations[0].locationName);
      trip.lastLocation = await getAllTripItemsByTripId(trip.tripId!)
          .then((locations) => locations[locations.length - 1].locationName);
      trip.totalTripItem = await getAllTripItemsByTripId(trip.tripId!)
          .then((locations) => locations.length);
      _tripsOperations.updateTrip(trip);

      await reOrderColumnNo(tripItems);
      if (tripItems[realIndex[0]].startTime != null)
        await calculateStartTimeForTripItem(tripItems);
    }
    notifyListeners();
  }

  Future<void> goToRecommendOnRoutePage(
      BuildContext context,
      List<TripItem> tripItems,
      List<LocationRecommendResponse> locationList) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => RecommendOnRoutePage(
                tripItems: tripItems,
                locationList: locationList,
              )),
    );
  }

  Future<void> goToBaggageLocationOnRoutePage(BuildContext context,
      List<TripItem> tripItems, List<BaggageResponse> locationList) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => BaggageLocationOnRoutePage(
              tripItems: tripItems, locationList: locationList)),
    );
  }

  Future<void> goToShopLocationOnRoutePage(
      BuildContext context,
      List<TripItem> tripItems,
      List<ShopResponse> locationList,
      List<int> days) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ShopLocationOnRoutePage(
              days: days, tripItems: tripItems, locationList: locationList)),
    );
  }

  Future pickDate(BuildContext context, Trip trip) async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: trip.startDate == null
          ? DateTime.now()
          : DateTime.parse(DateFormat('yyyy-MM-dd')
              .format(DateFormat('dd/MM/yyyy').parse(trip.startDate!))),
      firstDate: trip.startDate != null &&
              DateTime.parse(DateFormat('yyyy-MM-dd')
                      .format(DateFormat('dd/MM/yyyy').parse(trip.startDate!)))
                  .isBefore(DateTime.now())
          ? DateTime.parse(DateFormat('yyyy-MM-dd')
              .format(DateFormat('dd/MM/yyyy').parse(trip.startDate!)))
          : DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 10),
    );

    if (newDate == null) {
      notifyListeners();
      return;
    }
    trip.startDate = '${newDate.day}/${newDate.month}/${newDate.year}';
    notifyListeners();
  }

  Future<List<BaggageResponse>> getBaggageList() async {
    return await BaggageService().getBaggageList();
  }

  Future<List<LocationRecommendResponse>> getLocationRecommend() async {
    _locationRecommend = await LocationService().getLocationRecommend();
    return _locationRecommend;
  }

  Future<List<ShopResponse>> getAllShop() async {
    return await LocationService().getAllShop();
  }

  void goToTripStepperPage(BuildContext context, int tripId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TripStepperPage(tripId: tripId)),
    );
  }

  void goToLocationDetail(BuildContext context, int locationId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LocationDetailPage(locationId: locationId),
      ),
    );
  }

  void goToRouteOnMapPage(BuildContext context, int tripId, List<int> days) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RouteOnMapPage(days: days, tripId: tripId),
      ),
    );
  }

  void selectedLocation(
      BuildContext context, LocationRecommendResponse location) {
    Navigator.pop(context, location);
  }

  void selectedLocationFromBaggage(
      BuildContext context, BaggageResponse location) {
    Navigator.pop(context, location);
  }

  void selectShop(ShopResponse shop) {
    if (_shop == null)
      _shop = shop;
    else {
      if (_shop!.locationId != shop.locationId)
        _shop = shop;
      else
        _shop = null;
    }

    notifyListeners();
  }

  void changeDay(int day) {
    _daySelected = day;
    notifyListeners();
  }

  void getDaySelected(int day) {
    _daySelected = day;
  }

  void selectTrumbnail(Trip trip, String imageUrl) {
    trip.trumbnail = imageUrl;
    notifyListeners();
  }

  void updateTripNameValue(Trip trip, String tripName) {
    trip.tripName = tripName;
    notifyListeners();
  }

  void updateNumberOfPeopleValue(Trip trip, int people) {
    trip.totalPeople = people;
    notifyListeners();
  }

  void onDayTapped(int day) {
    _day = day;
    notifyListeners();
  }

  void addDay(List<int> days, Trip trip) {
    days.add(days.length + 1);
    trip.totalDay++;
    _tripsOperations.updateTrip(trip);
    _day = days.length;
    notifyListeners();
  }

  Future<void> deleteDay(List<int> days, Trip trip) async {
    await getAllTripItemsByTripId(trip.tripId!)
        .then((_locations) => _locations.forEach((element) {
              if (element.day == _day) {
                _tripItemOperations.deleteTripItem(element);
              }
              if (element.day > _day) {
                element.day--;
                _tripItemOperations.updateTripItem(element);
              }
            }));

    trip.firstLocation = await getAllTripItemsByTripId(trip.tripId!)
        .then((locations) => locations[0].locationName);
    trip.lastLocation = await getAllTripItemsByTripId(trip.tripId!)
        .then((locations) => locations[locations.length - 1].locationName);
    trip.totalTripItem = await getAllTripItemsByTripId(trip.tripId!)
        .then((locations) => locations.length);

    trip.totalDay--;
    _tripsOperations.updateTrip(trip);

    await days.remove(_day);
    for (int i = 1; i <= trip.totalDay; i++) {
      days[i - 1] = i;
    }

    if (_day > trip.totalDay) _day--;

    notifyListeners();
  }

  Future<void> moveTripItemTo(
      int day, Trip trip, TripItem item, List<TripItem> tripItems) async {
    final oldNo = item.no;
    tripItems.remove(item);
    List<TripItem> _desTripItems = [];
    _desTripItems = await _tripItemOperations.getAllTripItemsByTripIdAndDay(
        trip.tripId!, day);

    if (_desTripItems.isNotEmpty) {
      if (_desTripItems.first.startTime != null)
        item.startTime = await DateTime.parse(_desTripItems.last.startTime!)
            .add(Duration(
                minutes: _desTripItems.last.duration +
                    (item.drivingDuration == null ? 0 : item.drivingDuration!)))
            .toIso8601String();
      else
        item.startTime = null;
    }

    item.no = _desTripItems.length;
    if (_desTripItems.length == 0) {
      item.distance = null;
      item.drivingDuration = null;
    } else
      await getPolylineBetweenTwoPoint(_desTripItems.last, item)
          .then((polyLines) async {
        item.distance = await calculateDistance(polyLines);
        item.drivingDuration = await ((item.distance! / 80) * 60).toInt();
        _tripItemOperations.updateTripItem(item);
      });
    item.day = day;

    int no = 0;
    tripItems.forEach((element) async {
      if (element.no >= 0 && element.day == _day) {
        //update no. oldTripItems
        element.no = no;
        if (no == 0) {
          element.distance = null;
          element.drivingDuration = null;
        }
        no++;
        await _tripItemOperations.updateTripItem(element);
      }
    });

    await calculateStartTimeForTripItem(tripItems);

    await _tripItemOperations.updateTripItem(item);

    trip.firstLocation = await getAllTripItemsByTripId(trip.tripId!)
        .then((locations) => locations[0].locationName);
    trip.lastLocation = await getAllTripItemsByTripId(trip.tripId!)
        .then((locations) => locations[locations.length - 1].locationName);
    _tripsOperations.updateTrip(trip);

    for (int i = oldNo; i < tripItems.length; i++) {
      //calulateDistance Old TripItems
      if (tripItems[i].no > 0 && tripItems[i].day == _day) {
        await getPolylineBetweenTwoPoint(tripItems[i - 1], tripItems[i])
            .then((polyLines) async {
          tripItems[i].distance = await calculateDistance(polyLines);
          tripItems[i].drivingDuration =
              await ((tripItems[i].distance! / 80) * 60).toInt();
          _tripItemOperations.updateTripItem(tripItems[i]);
        });
      }
    }

    _day = day;
    if (_index == 1)
      tripItems.insert(
          tripItems.lastIndexWhere((element) => element.day == day) + 1, item);

    notifyListeners();
  }

  void goBack(BuildContext context) {
    _index = 0;
    _day = 1;
    _shop = null;
    Navigator.pop(context);
  }

  Future<void> backToShoppingStep(BuildContext context, Trip trip) async {
    if (_shopId != null) {
      _tripItemOperations.deleteTripItemById(_shopId!);
      trip.lastLocation = await getAllTripItemsByTripId(trip.tripId!)
          .then((locations) => locations[locations.length - 1].locationName);
      trip.totalTripItem -= 1;
      await _tripsOperations.updateTrip(trip);
    }
    Navigator.pop(context);
  }

  void confirmTrip(Trip trip, BuildContext context) {
    _tripsOperations.updateTrip(trip);

    Navigator.pop(context);
    Navigator.pop(context);
    _index = 0;
    _day = 1;
    _shop = null;
  }

  Future<List<TripItem>> getAllTripItemsByTripIdAndDay(int tripId) async {
    return await _tripItemOperations.getAllTripItemsByTripIdAndDay(
        tripId, _day);
  }

  Future<List<TripItem>> getAllTripItemsByTripId(int tripId) async {
    return await _tripItemOperations.getAllTripItemsByTripId(tripId);
  }

  Future<Trip> getTripById(int tripId) async {
    return await _tripsOperations.getTripById(tripId);
  }

  Future<Set<Marker>> getMarkers(List<TripItem> _tripItems) async {
    Set<Marker> _markers = Set();
    await Future.forEach(_tripItems, (item) async {
      final location = item as TripItem;
      if (item.day == _day) {
        final _markerId = MarkerId('${item.locationId}');
        await _markers.add(
          Marker(
              markerId: _markerId,
              position: LatLng(location.latitude, location.longitude),
              infoWindow: InfoWindow(
                title: location.locationName,
              ),
              icon: await BitmapDescriptor.fromBytes(
                await getBytesFromCanvas(
                  item.no + 1,
                  80,
                  80,
                  location.locationCategory == 'ที่เที่ยว'
                      ? Palette.LightGreenColor
                      : location.locationCategory == 'ที่กิน'
                          ? Palette.PeachColor
                          : Palette.LightOrangeColor,
                ),
              ),
              onTap: () {
                scrollToPinCard(item.no);
              }),
        );
      }
    });
    return _markers;
  }

  Future<Set<Marker>> getMarkersRecommend(List<TripItem> _tripItems,
      List<LocationRecommendResponse> locationList) async {
    List<TripItem> tripItems = _tripItems
        .where((element) => element.day == _day && element.no >= 0)
        .toList();
    Set<Marker> _markers = Set();
    await Future.forEach(tripItems, (item) async {
      final location = item as TripItem;
      if (item.day == _day) {
        final _markerId = MarkerId('${item.locationId}');
        await _markers.add(
          Marker(
              markerId: _markerId,
              position: LatLng(location.latitude, location.longitude),
              infoWindow: InfoWindow(
                title: location.locationName,
              ),
              icon: await BitmapDescriptor.fromBytes(
                await getBytesFromCanvas(
                  item.no + 1,
                  80,
                  80,
                  location.locationCategory == 'ที่เที่ยว'
                      ? Palette.LightGreenColor
                      : location.locationCategory == 'ที่กิน'
                          ? Palette.PeachColor
                          : Palette.LightOrangeColor,
                ),
              ),
              onTap: () {
                // scrollToPinCard(item.no);
              }),
        );
      }
    });
    await Future.forEach(locationList, (item) async {
      final location = item as LocationRecommendResponse;

      final _markerId = MarkerId('${item.locationName}');
      await _markers.add(
        Marker(
            markerId: _markerId,
            position: LatLng(location.latitude, location.longitude),
            infoWindow: InfoWindow(
              title: location.locationName,
            ),
            icon: await BitmapDescriptor.fromBytes(
              await getBytesFromAsset(
                location.category == 'ที่เที่ยว'
                    ? IconAssets.travelMarker
                    : location.category == 'ที่กิน'
                        ? IconAssets.foodMarker
                        : IconAssets.hotelMarker,
                100,
              ),
            ),
            onTap: () {
              scrollToPinCard(locationList.indexOf(item));
            }),
      );
    });
    return _markers;
  }

  Future<Set<Marker>> getBaggageMarkers(
      List<TripItem> _tripItems, List<BaggageResponse> locationList) async {
    List<TripItem> tripItems = _tripItems
        .where((element) => element.day == _day && element.no >= 0)
        .toList();
    Set<Marker> _markers = Set();
    await Future.forEach(tripItems, (item) async {
      final location = item as TripItem;
      if (item.day == _day) {
        final _markerId = MarkerId('${item.locationId}');
        await _markers.add(
          Marker(
              markerId: _markerId,
              position: LatLng(location.latitude, location.longitude),
              infoWindow: InfoWindow(
                title: location.locationName,
              ),
              icon: await BitmapDescriptor.fromBytes(
                await getBytesFromCanvas(
                  item.no + 1,
                  80,
                  80,
                  location.locationCategory == 'ที่เที่ยว'
                      ? Palette.LightGreenColor
                      : location.locationCategory == 'ที่กิน'
                          ? Palette.PeachColor
                          : Palette.LightOrangeColor,
                ),
              ),
              onTap: () {
                // scrollToPinCard(item.no);
              }),
        );
      }
    }).then((value) => Future.forEach(locationList, (item) async {
          final location = item as BaggageResponse;

          final _markerId = MarkerId('${item.locationName}');
          await _markers.add(
            Marker(
                markerId: _markerId,
                position: LatLng(location.latitude, location.longitude),
                infoWindow: InfoWindow(
                  title: location.locationName,
                ),
                icon: await BitmapDescriptor.fromBytes(
                  await getBytesFromAsset(
                    location.category == 'ที่เที่ยว'
                        ? IconAssets.travelMarker
                        : location.category == 'ที่กิน'
                            ? IconAssets.foodMarker
                            : IconAssets.hotelMarker,
                    100,
                  ),
                ),
                onTap: () {
                  scrollToPinCard(locationList.indexOf(item));
                }),
          );
        }));

    return _markers;
  }

  Future<Set<Marker>> getShopMarkers(
      List<TripItem> _tripItems, List<ShopResponse> locationList) async {
    List<TripItem> tripItems = _tripItems
        .where((element) => element.day == _day && element.no >= 0)
        .toList();
    Set<Marker> _markers = Set();
    await Future.forEach(tripItems, (item) async {
      final location = item as TripItem;
      if (item.day == _day) {
        final _markerId = MarkerId('${item.locationId}');
        await _markers.add(
          Marker(
              markerId: _markerId,
              position: LatLng(location.latitude, location.longitude),
              infoWindow: InfoWindow(
                title: location.locationName,
              ),
              icon: await BitmapDescriptor.fromBytes(
                await getBytesFromCanvas(
                  item.no + 1,
                  80,
                  80,
                  location.locationCategory == 'ที่เที่ยว'
                      ? Palette.LightGreenColor
                      : location.locationCategory == 'ที่กิน'
                          ? Palette.PeachColor
                          : Palette.LightOrangeColor,
                ),
              ),
              onTap: () {
                // scrollToPinCard(item.no);
              }),
        );
      }
    }).then((value) => Future.forEach(locationList, (item) async {
          final location = item as ShopResponse;

          final _markerId = MarkerId('${item.locationName}');
          await _markers.add(
            Marker(
                markerId: _markerId,
                position: LatLng(location.latitude, location.longitude),
                infoWindow: InfoWindow(
                  title: location.locationName,
                ),
                icon: await BitmapDescriptor.fromBytes(
                  await getBytesFromAsset(
                    IconAssets.foodMarker,
                    100,
                  ),
                ),
                onTap: () {
                  scrollToPinCard(locationList.indexOf(item));
                }),
          );
        }));

    return _markers;
  }

  Future<List<TripItem>> getPinCard(List<TripItem> tripItems) async {
    return await tripItems.where((element) => element.day == _day).toList();
  }

  void addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Palette.SecondaryColor,
      points: _polylineCoordinates,
      width: 4,
    );
    _polylines[id] = polyline;
    notifyListeners();
    // setState(() {});
  }

  Future<void> getPolyline(List<TripItem> tripItems) async {
    List<TripItem> route = await tripItems
        .where((element) => element.day == _day && element.no >= 0)
        .toList();
    List<PolylineWayPoint> wayPoints = [];
    _polylineCoordinates = [];

    for (int i = 1; i < route.length - 1; i++) {
      wayPoints.add(PolylineWayPoint(
          location: "${route[i].latitude},${route[i].longitude}"));
    }

    PolylineResult result = await _polylinePoints.getRouteBetweenCoordinates(
      googleAPiKey,
      PointLatLng(route.first.latitude, route.first.longitude),
      PointLatLng(route.last.latitude, route.last.longitude),
      travelMode: TravelMode.driving,
      wayPoints: wayPoints,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        _polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    addPolyLine();
  }

  Future<List<LatLng>> getPolylineBetweenTwoPoint(
      TripItem originPoint, TripItem destPoint) async {
    _polylineCoordinates = [];

    PolylineResult result = await _polylinePoints.getRouteBetweenCoordinates(
      googleAPiKey,
      PointLatLng(originPoint.latitude, originPoint.longitude),
      PointLatLng(destPoint.latitude, destPoint.longitude),
      travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        _polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    return _polylineCoordinates;
  }

  double calculateDistance(List<LatLng> polyLines) {
    double totalDistance = 0;
    for (int i = 0; i < polyLines.length - 1; i++) {
      totalDistance += coordinateDistance(
        polyLines[i].latitude,
        polyLines[i].longitude,
        polyLines[i + 1].latitude,
        polyLines[i + 1].longitude,
      );
    }
    return double.parse(totalDistance.toStringAsFixed(2));
  }

  double coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<Uint8List> getBytesFromCanvas(
      int customNum, int width, int height, color) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = color;
    final Radius radius = Radius.circular(width / 2);
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(0.0, 0.0, width.toDouble(), height.toDouble()),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        paint);

    TextPainter painter = TextPainter(textDirection: ui.TextDirection.ltr);
    painter.text = TextSpan(
      text: customNum.toString(), // your custom number here
      style: TextStyle(
          fontSize: 36, color: Colors.white, fontWeight: FontWeight.bold),
    );

    painter.layout();
    painter.paint(
        canvas,
        Offset((width * 0.5) - painter.width * 0.5,
            (height * .5) - painter.height * 0.5));
    final img = await pictureRecorder.endRecording().toImage(width, height);
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return data!.buffer.asUint8List();
  }

  Future<void> updateMapView(Completer<GoogleMapController> _controller,
      List<TripItem> tripItems) async {
    var initItem = tripItems.firstWhere((element) => element.day == _day);
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(initItem.latitude, initItem.longitude),
      zoom: 11,
    )));
  }

  void getMapStyle() {
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
      notifyListeners();
    });
  }

  Future scrollToPinCard(int index) async {
    if (_itemScrollController.isAttached) {
      await _itemScrollController.scrollTo(
        index: index,
        duration: Duration(seconds: 1),
      );
    }
  }

  List get steps => _steps;
  int get index => _index;
  IconData get vehiclesSelected => _vehiclesSelected;
  List<int> get mealsIndex => _mealsIndex;
  bool get startTimeIsValid => _startTimeIsValid;
  bool get startPointIsValid => _startPointIsValid;
  List<LocationRecommendResponse> get locationRecommend => _locationRecommend;
  int get day => _day;
  ShopResponse? get shop => _shop;
  int? get shopId => _shopId;
  int get daySelected => _daySelected;

  Map<PolylineId, Polyline> get polylines => _polylines;
  List<LatLng> get polylineCoordinates => _polylineCoordinates;
  PolylinePoints get polylinePoints => _polylinePoints;
  String get mapStyle => _mapStyle;

  ItemScrollController get itemScrollController => _itemScrollController;
}
