import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:trip_planner/src/models/response/baggage_response.dart';
import 'package:trip_planner/src/view/screens/search_start_point_page.dart';

class TripFormViewModel with ChangeNotifier {
  DateTime? _date;
  String _startDate = 'วันเริ่มต้นทริป';

  Future pickDate(BuildContext context) async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: _date == null ? DateTime.now() : _date!,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
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
      BuildContext context, List<BaggageResponse> startPointList) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            SearchStartPointPage(startPointList: startPointList),
      ),
    );
  }

  void goToCreateTrip(BuildContext context,
      List<BaggageResponse> startPointList, BaggageResponse startPoint) {
    startPointList.remove(startPoint);
    startPointList.insert(0, startPoint);
    startPointList
        .forEach((startPointList) => print(startPointList.locationName));
  }

  DateTime get date => _date!;
  String get startDate => _startDate;
}
