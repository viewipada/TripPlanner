import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/size_config.dart';
import 'package:trip_planner/src/view/widgets/baggage_cart.dart';
import 'package:trip_planner/src/view_models/review_view_model.dart';
import 'package:flutter/services.dart' show rootBundle;

class MyLocationPage extends StatefulWidget {
  @override
  _MyLocationPageState createState() => _MyLocationPageState();
}

class _MyLocationPageState extends State<MyLocationPage> {
  Completer<GoogleMapController> _controller = Completer();

  bool _serviceEnabled = false;
  PermissionStatus _permissionGranted = PermissionStatus.denied;
  LocationData? _userLocation;

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

    // Check if permission is granted
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    final _locationData = await location.getLocation();
    setState(() {
      _userLocation = _locationData;
    });
    print(
        'lat => ${_userLocation!.latitude} , long => ${_userLocation!.longitude}');
  }

  String _mapStyle = '';
  @override
  void initState() {
    super.initState();

    rootBundle.loadString('assets/map_style.txt').then((string) {
      setState(() {
        _mapStyle = string;
      });
    });

    getUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    // print('${currentLocation.latitude} , ${currentLocation.longitude}');
    // final reviewViewModel = Provider.of<ReviewViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ตำแหน่งของฉัน",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [
          BaggageCart(),
        ],
      ),
      body: SafeArea(
        child: Container(
          child: GoogleMap(
            circles: Set.from([
              Circle(
                  circleId: CircleId("myCircle"),
                  radius: 5000,
                  center: LatLng(_userLocation!.latitude ?? 0,
                      _userLocation!.longitude ?? 0),
                  fillColor: Color.fromRGBO(171, 39, 133, 0.1),
                  strokeColor: Color.fromRGBO(171, 39, 133, 0.5),
                  onTap: () {
                    print('circle pressed');
                  })
            ]),
            mapToolbarEnabled: false,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: LatLng(
                  _userLocation!.latitude ?? 0, _userLocation!.longitude ?? 0),
              zoom: 16,
            ),
            zoomControlsEnabled: false,
            markers: {
              Marker(
                markerId: MarkerId('1'),
                position: LatLng(_userLocation!.latitude ?? 0,
                    _userLocation!.longitude ?? 0),
                infoWindow: InfoWindow(
                  title:
                      '${_userLocation!.latitude} , ${_userLocation!.longitude}',
                ),
              ),
            },
            onMapCreated: (GoogleMapController controller) {
              controller.setMapStyle(_mapStyle);
              _controller.complete(controller);
            },
          ),
        ),
      ),
    );
  }
}
