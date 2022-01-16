import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:trip_planner/src/models/response/baggage_response.dart';
import 'package:trip_planner/src/view/screens/search_start_point_page.dart';

class TripFormViewModel with ChangeNotifier {
  DateTime? _date;
  String _startDate = 'วันเริ่มต้นทริป';
  String _tripName = '';
  int _totalPeople = 1;
  int _totalTravelingDay = 1;
  Map<String, String>? _startPointFromGoogle;
  BaggageResponse? _startPointFromBaggage;

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

  void goToCreateTrip(
      BuildContext context,
      List<BaggageResponse> startPointList,
      BaggageResponse? startPointFromBaggage,
      Map<String, String>? startPointFromGoogle) {
    if (startPointFromBaggage != null &&
        startPointList.contains(startPointFromBaggage)) {
      startPointList.remove(startPointFromBaggage);
      startPointList.insert(0, startPointFromBaggage);
      // startPointList
      //     .forEach((startPointList) => print(startPointList.locationName));
    } else if (startPointFromGoogle != null) {
      startPointList.insert(
        0,
        BaggageResponse(
            locationId: 0,
            locationName: startPointFromGoogle['locationName']!,
            imageUrl: '',
            category: '',
            description: startPointFromGoogle['description']!),
      );
    }
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
}
