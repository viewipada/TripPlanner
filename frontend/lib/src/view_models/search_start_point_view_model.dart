import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:trip_planner/src/models/response/baggage_response.dart';
import 'package:trip_planner/src/view/screens/trip_form_page.dart';

class SearchStartPointViewModel with ChangeNotifier {
  void selectedStartPoint(BuildContext context,
      List<BaggageResponse> startPointList, BaggageResponse startPoint) {
    startPointList.remove(startPoint);
    startPointList.insert(0, startPoint);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TripFormPage(startPointList: startPointList),
      ),
    );
  }
}
