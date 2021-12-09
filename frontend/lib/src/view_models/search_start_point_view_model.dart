import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';
import 'package:location/location.dart';
import 'package:trip_planner/src/models/response/baggage_response.dart';
import 'package:trip_planner/src/view/screens/trip_form_page.dart';
import 'package:uuid/uuid.dart';

class SearchStartPointViewModel with ChangeNotifier {
  var uuid = new Uuid();
  String? _sessionToken;
  List<AutocompletePrediction> _predictions = [];
  DetailsResult? _detailsResult;
  Map<String, String>? _startPointFormGoogleMap;

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

  void getDetails(BuildContext context, List<BaggageResponse> startPointList,
      GooglePlace googlePlace, String placeId, String description) async {
    var result = await googlePlace.details.get(
      placeId,
      region: 'th',
      language: 'th',
      fields: 'name,geometry',
    );
    if (result != null && result.result != null) {
      _detailsResult = result.result!;

      if (_detailsResult != null &&
          _detailsResult!.geometry != null &&
          _detailsResult!.geometry!.location != null) {
        _startPointFormGoogleMap = {
          'locationName': _detailsResult!.name!,
          'description': description,
          'lat': _detailsResult!.geometry!.location!.lat.toString(),
          'lng': _detailsResult!.geometry!.location!.lng.toString(),
        };
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TripFormPage(
              startPointList: startPointList,
              pointIndex: 0,
              startPointFormGoogleMap: _startPointFormGoogleMap,
            ),
          ),
        );
      }
    }
  }

  void selectedUserLocation(BuildContext context,
      List<BaggageResponse> startPointList, LocationData userLocation) async {
    _startPointFormGoogleMap = {
      'locationName': 'ตำแหน่งของฉัน',
      'description':
          'พิกัดปัจจุบันอยู่ที่ (${userLocation.latitude}, ${userLocation.longitude})',
      'lat': userLocation.latitude.toString(),
      'lng': userLocation.longitude.toString(),
    };
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TripFormPage(
          startPointList: startPointList,
          pointIndex: 0,
          startPointFormGoogleMap: _startPointFormGoogleMap,
        ),
      ),
    );
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
  // Map<String, String>? get startPointFormGoogleMap => _startPointFormGoogleMap ?? null;
}
