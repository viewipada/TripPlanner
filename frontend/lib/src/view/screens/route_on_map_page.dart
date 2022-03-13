import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/assets.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/size_config.dart';
import 'package:trip_planner/src/models/trip_item.dart';
import 'package:trip_planner/src/view/widgets/loading.dart';
import 'package:trip_planner/src/view_models/trip_stepper_view_model.dart';

class RouteOnMapPage extends StatefulWidget {
  final int tripId;
  final List<int> days;
  final List<TripItem> tripItems;

  RouteOnMapPage({
    required this.tripId,
    required this.days,
    required this.tripItems,
  });

  @override
  _RouteOnMapPageState createState() =>
      _RouteOnMapPageState(this.tripId, this.days, this.tripItems);
}

class _RouteOnMapPageState extends State<RouteOnMapPage> {
  final int tripId;
  final List<int> days;
  List<TripItem> tripItems;

  _RouteOnMapPageState(this.tripId, this.days, this.tripItems);

  Completer<GoogleMapController> _controller = Completer();

  // Set<Marker> markers = Set();
  // Map<PolylineId, Polyline> polylines = {};
  // List<LatLng> polylineCoordinates = [];
  // PolylinePoints polylinePoints = PolylinePoints();
  // String googleAPiKey = GoogleAssets.googleAPI;

  @override
  void initState() {
    super.initState();
    // Provider.of<TripStepperViewModel>(context, listen: false)
    //     .getMarkers(tripItems);
    // print(markers);
    // print(tripItems);

    /// origin marker
    // _addMarker(LatLng(_originLatitude, _originLongitude), "origin",
    //     BitmapDescriptor.defaultMarker);

    // /// destination marker
    // _addMarker(LatLng(_destLatitude, _destLongitude), "destination",
    //     BitmapDescriptor.defaultMarkerWithHue(90));
    Provider.of<TripStepperViewModel>(context, listen: false)
        .getPolyline(tripItems);
    // print(polylineCoordinates);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final tripStepperViewModel = Provider.of<TripStepperViewModel>(context);
    print('print');

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          color: Palette.BackIconColor,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "เส้นทางในทริป",
          style: FontAssets.headingText,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            FutureBuilder(
              future: tripStepperViewModel.getMarkers(tripItems),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  // _getPolyline(tripItems, tripStepperViewModel);
                  return buildGoogleMap(_controller, tripStepperViewModel,
                      snapshot.data as Set<Marker>);
                } else {
                  return Loading();
                }
              },
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: double.infinity,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: days
                            .map((day) => buildDayButton(day,
                                tripStepperViewModel, _controller, tripItems))
                            .toList(),
                      ),
                    ),
                    decoration: BoxDecoration(
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Colors.black54,
                            blurRadius: 10,
                            offset: Offset(0.0, 0.75))
                      ],
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      0,
                      getProportionateScreenHeight(15),
                      getProportionateScreenWidth(15),
                      getProportionateScreenHeight(10),
                    ),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 20,
                      child: IconButton(
                          constraints: BoxConstraints(),
                          padding: EdgeInsets.zero,
                          icon: ImageIcon(
                            AssetImage(IconAssets.locationListView),
                          ),
                          color: Palette.SecondaryColor,
                          onPressed: () => {}
                          //  showModalBottomSheet(
                          //   isScrollControlled: true,
                          //   backgroundColor: Colors.transparent,
                          //   context: context,
                          //   builder: (_context) => makeDismissible(
                          //       locationListView(context, searchViewModel),
                          //       _context),
                          // ),
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // void _onMapCreated(GoogleMapController controller) async {
  //   mapController = controller;
  // }

  // _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
  //   MarkerId markerId = MarkerId(id);
  //   Marker marker =
  //       Marker(markerId: markerId, icon: descriptor, position: position);
  //   markers[markerId] = marker;
  // }

}

Widget buildDayButton(int day, TripStepperViewModel tripStepperViewModel,
    Completer<GoogleMapController> _controller, List<TripItem> tripItems) {
  return Column(
    children: [
      SizedBox(
        width: getProportionateScreenWidth(100),
        child: TextButton(
          onPressed: () {
            tripStepperViewModel.onDayTapped(day);
            tripStepperViewModel.updateMapView(_controller, tripItems);
            tripStepperViewModel.getPolyline(tripItems);
          },
          child: Text(
            'วันที่ ${day}',
            style: TextStyle(
              color: Palette.AdditionText,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          style: TextButton.styleFrom(
            primary: Palette.LightOrangeColor,
          ),
        ),
      ),
      Visibility(
        visible: tripStepperViewModel.day == day,
        child: Container(
          height: 3,
          width: getProportionateScreenWidth(100),
          color: Palette.SecondaryColor,
        ),
      ),
    ],
  );
}

Widget buildGoogleMap(Completer<GoogleMapController> _controller,
    TripStepperViewModel tripStepperViewModel, Set<Marker> markers) {
  // print(markers.first.position);
  return Container(
    child: GoogleMap(
      initialCameraPosition:
          CameraPosition(target: markers.first.position, zoom: 11),
      myLocationEnabled: false,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      myLocationButtonEnabled: false,
      mapType: MapType.normal,
      // myLocationEnabled: true,
      // tiltGesturesEnabled: true,
      // compassEnabled: true,
      // scrollGesturesEnabled: true,
      // zoomGesturesEnabled: false,

      markers: markers,
      polylines: Set<Polyline>.of(tripStepperViewModel.polylines.values),
      onMapCreated: (GoogleMapController controller) {
        // Future.delayed(Duration(seconds: 1));

        // controller.setMapStyle(searchViewModel.mapStyle);
        _controller.complete(controller);
      },
    ),
  );
}
