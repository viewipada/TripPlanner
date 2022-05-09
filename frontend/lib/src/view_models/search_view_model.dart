import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:trip_planner/assets.dart';
import 'package:trip_planner/src/models/response/search_result_response.dart';
import 'package:trip_planner/src/models/response/travel_nearby_response.dart';
import 'package:trip_planner/src/services/baggage_service.dart';
import 'package:trip_planner/src/services/location_nearby_service.dart';
import 'package:trip_planner/src/services/search_result_service.dart';
import 'package:trip_planner/src/view/screens/location_detail_page.dart';
import 'package:trip_planner/src/view/screens/my_location_page.dart';
import 'package:trip_planner/src/view/screens/search_result_page.dart';

class SearchViewModel with ChangeNotifier {
  List _dropdownItemList = [
    {'label': 'เรียงตามคะแนน', 'value': 'rating'},
    {'label': 'เรียงตามยอดเช็คอิน', 'value': 'checkin'},
  ];
  List _tabs = [
    {'label': 'ทั้งหมด', 'value': 0},
    {'label': 'ที่เที่ยว', 'value': 1},
    {'label': 'ที่กิน', 'value': 2},
    {'label': 'ที่พัก', 'value': 3},
  ];
  List _radius = [
    {'r': 1, 'isSelected': false},
    {'r': 3, 'isSelected': true},
    {'r': 5, 'isSelected': false}
  ];
  List _locationCategories = [
    {'category': 'ทุกแบบ', 'isSelected': false},
    {'category': 'ที่เที่ยว', 'isSelected': false},
    {'category': 'ที่กิน', 'isSelected': false},
    {'category': 'ที่พัก', 'isSelected': false},
  ];
  double _circleRadius = 3000;
  bool _serviceEnabled = false;
  PermissionStatus _permissionGranted = PermissionStatus.denied;
  LocationData? _userLocation;
  String _mapStyle = '';
  List<LocationNearbyResponse> _locationNearbyList = [];
  List<LocationNearbyResponse> _locationPinCard = [];
  List<SearchResultResponse> _searchResultCard = [];
  List<SearchResultResponse> _queryResult = [];
  Set<Marker> _markers = Set();
  ItemScrollController _itemScrollController = ItemScrollController();
  bool _isQuery = false;
  String _sortedBy = "rating";

  Future<void> getUserLocation() async {
    Location location = new Location();

    // Check if location service is enable
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    // Ask for permission
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    await location.getLocation().then((value) {
      _userLocation = value;
      notifyListeners();
    });
  }

  void getMapStyle() {
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
      notifyListeners();
    });
  }

  void goToMyLocationPage(
      BuildContext context, String category, LocationData userLocation) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyLocationPage(
          category: category,
          userLocation: userLocation,
        ),
      ),
    );
  }

  void updateCategorySelection(dynamic category) {
    _locationCategories.forEach((element) => element['isSelected'] = false);
    category['isSelected'] = true;
    notifyListeners();
  }

  void updateRadius(dynamic radius) {
    _radius.forEach((element) => element['isSelected'] = false);
    radius['isSelected'] = true;
    _circleRadius = radius['r'] * 1000.0;
    notifyListeners();
  }

  Future<void> updateMapView(
      Completer<GoogleMapController> _controller, int radius) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target:
          LatLng(_userLocation!.latitude ?? 0, _userLocation!.longitude ?? 0),
      zoom: getZoomLevel(radius),
    )));
  }

  double getZoomLevel(int radius) {
    double zoomLevel = 11;
    if (radius > 0) {
      double radiusElevated = radius + radius / 2;
      double scale = radiusElevated / 500;
      zoomLevel = 16 - log(scale) / log(2);
    }
    return zoomLevel;
  }

  Future<void> getLocationNearby(
      String category, LocationData userLocation) async {
    _locationNearbyList =
        await LocationNearbyService().getLocationNearby(category, userLocation);
    notifyListeners();
  }

  Future<Set<Marker>> getMarkersWithRadius(double radius) async {
    Set<Marker> markers = Set();
    List<LocationNearbyResponse> locationPinCard = [];
    await Future.forEach(_locationNearbyList, (item) async {
      final location = item as LocationNearbyResponse;

      if (location.ditanceFromeUser <= radius / 1000) {
        final _markerId = MarkerId('${location.locationId}');
        await markers.add(
          Marker(
              markerId: _markerId,
              position: LatLng(location.latitude, location.longitude),
              infoWindow: InfoWindow(
                title: location.locationName,
              ),
              icon: await BitmapDescriptor.fromBytes(
                await getBytesFromAsset(
                  location.category == 1
                      ? IconAssets.travelMarker
                      : location.category == 2
                          ? IconAssets.foodMarker
                          : location.category == 3
                              ? IconAssets.hotelMarker
                              : IconAssets.shopMarker,
                  100,
                ),
              ),
              onTap: () {
                scrollToPinCard(int.parse(_markerId.value));
              }),
        );
        locationPinCard.add(location);
      }
    });
    _markers = markers;
    _locationPinCard = locationPinCard;
    notifyListeners();
    return _markers;
  }

  Future scrollToPinCard(int index) async {
    if (_itemScrollController.isAttached) {
      await _itemScrollController.scrollTo(
        index: index,
        duration: Duration(seconds: 1),
      );
    }
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

  Future<void> initialCategory(String category) async {
    _locationCategories[await _locationCategories.indexWhere(
        (index) => index['category'] == category)]['isSelected'] = true;
  }

  void goToLocationDetail(BuildContext context, int locationId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LocationDetailPage(locationId: locationId),
      ),
    );
  }

  void goToSearchResultPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultPage(),
      ),
    );
  }

  void goBack(BuildContext context) {
    _isQuery = false;
    _locationCategories.forEach((item) {
      item['isSelected'] = false;
    });
    _circleRadius = 3000;
    _radius.forEach((element) => element['r'] == 3
        ? element['isSelected'] = true
        : element['isSelected'] = false);
    Navigator.pop(context);
  }

  Future<void> getSearchResultBy(int category, String sortedBy) async {
    _searchResultCard = await [];
    _sortedBy = sortedBy;
    notifyListeners();
    _searchResultCard =
        await SearchResultService().getSearchResultBy(category, sortedBy);
    notifyListeners();
  }

  void isQueryMode() {
    _isQuery = true;
    notifyListeners();
  }

  void isSearchMode() {
    _isQuery = false;
    notifyListeners();
  }

  Future<void> query(
      List<SearchResultResponse> allLocationList, String searchMessage) async {
    _queryResult = await allLocationList.where((location) {
      final nameLower = location.locationName.toLowerCase();
      final searchMessageLower = searchMessage.toLowerCase();
      return nameLower.contains(searchMessageLower);
    }).toList();
    notifyListeners();
  }

  Future<void> addBaggageItem(int locationId) async {
    await BaggageService().addBaggageItem(locationId);
    notifyListeners();
  }

  Future<void> removeBaggageItem(int locationId) async {
    await BaggageService().removeBaggageItem(locationId);
    notifyListeners();
  }

  LocationData? get userLocation => _userLocation;
  String get mapStyle => _mapStyle;
  List get radius => _radius;
  double get circleRadius => _circleRadius;
  List get locationCategories => _locationCategories;
  List<LocationNearbyResponse> get locationNearbyList => _locationNearbyList;
  List<LocationNearbyResponse> get locationPinCard => _locationPinCard;
  List<SearchResultResponse> get searchResultCard => _searchResultCard;
  List<SearchResultResponse> get queryResult => _queryResult;
  Set<Marker> get markers => _markers;
  ItemScrollController get itemScrollController => _itemScrollController;
  List get dropdownItemList => _dropdownItemList;
  List get tabs => _tabs;
  bool get isQuery => _isQuery;
  String get sortedBy => _sortedBy;
}
