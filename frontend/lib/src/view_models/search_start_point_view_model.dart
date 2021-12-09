import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';
import 'package:trip_planner/src/models/response/baggage_response.dart';
import 'package:trip_planner/src/view/screens/trip_form_page.dart';
import 'package:uuid/uuid.dart';

class SearchStartPointViewModel with ChangeNotifier {
  var uuid = new Uuid();
  String? _sessionToken;
  List<AutocompletePrediction> _predictions = [];
  DetailsResult? _detailsResult;

  void selectedStartPoint(BuildContext context,
      List<BaggageResponse> startPointList, BaggageResponse startPoint) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TripFormPage(
          startPointList: startPointList,
          pointIndex: startPointList.indexOf(startPoint),
        ),
      ),
    );
  }

  void autoCompleteSearch(GooglePlace googlePlace, String value) async {
    var result = await googlePlace.autocomplete
        .get(value, language: 'th', region: 'th', sessionToken: _sessionToken);
    if (result != null && result.predictions != null) {
      _predictions = result.predictions!;
      notifyListeners();
    }
  }

  void getDetils(GooglePlace googlePlace, String placeId) async {
    var result = await googlePlace.details.get(
      placeId,
      region: 'th',
      language: 'th',
      fields: 'name,geometry',
    );
    if (result != null && result.result != null) {
      _detailsResult = result.result!;
      print(_detailsResult!.name);
      String latLng = _detailsResult != null &&
              _detailsResult!.geometry != null &&
              _detailsResult!.geometry!.location != null
          ? 'Geometry: ${_detailsResult!.geometry!.location!.lat.toString()},${_detailsResult!.geometry!.location!.lng.toString()}'
          : "Geometry: null";
    }
  }

  void createSessionToken() {
    _sessionToken = uuid.v4();
    notifyListeners();
  }

  void clearPredictions() {
    _predictions = [];
    notifyListeners();
  }

  void closeSessionToken() {
    _sessionToken = null;
    notifyListeners();
  }

  String? get sessionToken => _sessionToken;
  List<AutocompletePrediction> get predictions => _predictions;
  DetailsResult? get detailsResult => _detailsResult;
}
