import 'dart:math' show cos, sqrt, asin;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trip_planner/assets.dart';
import 'package:trip_planner/src/models/response/baggage_response.dart';
import 'package:trip_planner/src/models/trip.dart';
import 'package:trip_planner/src/models/trip_item.dart';
import 'package:trip_planner/src/repository/trip_item_operations.dart';
import 'package:trip_planner/src/repository/trips_operations.dart';
import 'package:trip_planner/src/view/screens/search_start_point_page.dart';
import 'package:trip_planner/src/view/screens/trip_stepper_page.dart';

class TripFormViewModel with ChangeNotifier {
  DateTime? _date;
  String _startDate = 'วันเริ่มต้นทริป';
  String _tripName = '';
  int _totalPeople = 1;
  int _totalTravelingDay = 1;
  Map<String, String>? _startPointFromGoogle;
  BaggageResponse? _startPointFromBaggage;
  List<LatLng> _polylineCoordinates = [];
  PolylinePoints _polylinePoints = PolylinePoints();
  String googleAPiKey = GoogleAssets.googleAPI;

  TripsOperations _tripsOperations = TripsOperations();
  TripItemOperations _tripItemOperations = TripItemOperations();

  Future pickDate(BuildContext context) async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: _date == null ? DateTime.now() : _date!,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 10),
    );

    if (newDate == null) {
      notifyListeners();
      return;
    }
    _date = newDate;
    _startDate = '${_date!.day}/${_date!.month}/${_date!.year}';
    notifyListeners();
  }

  void goToSearchStartPoint(
      BuildContext context, List<BaggageResponse> startPointList) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SearchStartPointPage(
              startPointList: startPointList, startPointValue: true)),
    );
    if (result is Map<String, String>) {
      _startPointFromGoogle = result;
      _startPointFromBaggage = null;
    } else {
      _startPointFromGoogle = null;
      _startPointFromBaggage = result as BaggageResponse;
    }
    notifyListeners();
  }

  Future<void> goToCreateTrip(
      BuildContext context,
      List<BaggageResponse> startPointList,
      BaggageResponse? startPointFromBaggage,
      Map<String, String>? startPointFromGoogle) async {
    if (startPointFromBaggage != null &&
        startPointList.contains(startPointFromBaggage)) {
      startPointList.remove(startPointFromBaggage);
      startPointList.insert(0, startPointFromBaggage);
    } else if (startPointFromGoogle != null) {
      startPointList.insert(
        0,
        BaggageResponse(
          locationId: 0,
          locationName: startPointFromGoogle['locationName']!,
          latitude: double.parse(startPointFromGoogle['lat']!),
          longitude: double.parse(startPointFromGoogle['lng']!),
          imageUrl: '',
          category: '',
          description: startPointFromGoogle['description']!,
          duration: 1,
        ),
      );
    }

    final trip = Trip(
      tripName: _tripName,
      firstLocation: startPointList[0].locationName,
      lastLocation: startPointList[startPointList.length - 1].locationName,
      totalPeople: _totalPeople,
      totalDay: _totalTravelingDay,
      totalTripItem: startPointList.length,
      status: 'unfinished',
    );
    int tripId = await _tripsOperations.createTrip(trip);

    List<TripItem> tripItems = [];
    Future.forEach(startPointList, (BaggageResponse item) async {
      final tripItem = TripItem(
        day: 1,
        no: startPointList.indexOf(item),
        locationId: item.locationId,
        locationCategory: item.category,
        locationName: item.locationName,
        imageUrl: item.imageUrl,
        latitude: item.latitude,
        longitude: item.longitude,
        duration: item.imageUrl == "" ? 0 : item.duration * 60,
        tripId: tripId,
      );
      tripItem.itemId = await _tripItemOperations.createTripItem(tripItem);
      tripItems.add(tripItem);
    }).then((value) async {
      for (int i = 1; i < tripItems.length; i++) {
        await getPolylineBetweenTwoPoint(tripItems[i - 1], tripItems[i])
            .then((polyLines) async {
          tripItems[i].distance = await calculateDistance(polyLines);
          tripItems[i].drivingDuration =
              await ((tripItems[i].distance! / 80) * 60).toInt();
          await _tripItemOperations.updateTripItem(tripItems[i]);
        });
      }
    }).then((value) {
      Navigator.of(context).pop();
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TripStepperPage(tripId: tripId)),
      );
    });

    _date = null;
    _startDate = 'วันเริ่มต้นทริป';
    _tripName = '';
    _totalPeople = 1;
    _totalTravelingDay = 1;
    _startPointFromGoogle = null;
    _startPointFromBaggage = null;
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

  void updateTripNameValue(String tripName) {
    _tripName = tripName;
    notifyListeners();
  }

  void updateNumberOfTravelingDayValue(int travelingDay) {
    _totalTravelingDay = travelingDay;
    notifyListeners();
  }

  void updateNumberOfPeopleValue(int people) {
    _totalPeople = people;
    notifyListeners();
  }

  void getStartPoint(startPoint) async {
    if (startPoint != null) {
      if (startPoint is Map<String, String>) {
        _startPointFromGoogle = await startPoint;
        _startPointFromBaggage = null;
      } else {
        _startPointFromGoogle = null;
        _startPointFromBaggage = await startPoint as BaggageResponse;
      }
      notifyListeners();
    }
  }

  void cancelTrip(BuildContext context) {
    _date = null;
    _startDate = 'วันเริ่มต้นทริป';
    _tripName = '';
    _totalPeople = 1;
    _totalTravelingDay = 1;
    _startPointFromGoogle = null;
    _startPointFromBaggage = null;
    Navigator.of(context).pop();
  }

  DateTime? get date => _date;
  String get startDate => _startDate;
  String get tripName => _tripName;
  int get totalPeople => _totalPeople;
  int get totalTravelingDay => _totalTravelingDay;
  Map<String, String>? get startPointFromGoogle => _startPointFromGoogle;
  BaggageResponse? get startPointFromBaggage => _startPointFromBaggage;
  // List<LatLng> get polylineCoordinates => _polylineCoordinates;
  // PolylinePoints get polylinePoints => _polylinePoints;
}
