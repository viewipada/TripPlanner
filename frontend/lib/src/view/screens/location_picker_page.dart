import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:map_picker/map_picker.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/assets.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/size_config.dart';
import 'package:trip_planner/src/models/response/baggage_response.dart';
import 'package:trip_planner/src/view/widgets/start_point_card.dart';
import 'package:trip_planner/src/view_models/location_picker_view_model.dart';
import 'package:trip_planner/src/view_models/search_start_point_view_model.dart';
import 'package:trip_planner/src/view_models/search_view_model.dart';

class LocationPickerPage extends StatefulWidget {
  LocationPickerPage({
    required this.initialLatLng,
  });

  final LatLng initialLatLng;
  @override
  _LocationPickerPageState createState() =>
      _LocationPickerPageState(this.initialLatLng);
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  final LatLng initialLatLng;
  _LocationPickerPageState(this.initialLatLng);

  final _controller = Completer<GoogleMapController>();
  MapPickerController mapPickerController = MapPickerController();

  @override
  void initState() {
    textController.clear();
    cameraPosition = CameraPosition(
      target: initialLatLng,
      zoom: 15,
    );
    super.initState();
  }

  late CameraPosition cameraPosition;
  var textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    // final locationPickerViewModel =
    //     Provider.of<LocationPickerViewModel>(context);
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          MapPicker(
            // pass icon widget
            iconWidget: Icon(
              Icons.location_on_rounded,
              size: 40,
              color: Palette.NotificationColor,
            ),
            //add map picker controller
            mapPickerController: mapPickerController,
            child: GoogleMap(
              myLocationEnabled: true,
              zoomControlsEnabled: false,
              // hide location button
              myLocationButtonEnabled: false,
              mapType: MapType.normal,
              //  camera position
              initialCameraPosition: cameraPosition,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              onCameraMoveStarted: () {
                // notify map is moving
                mapPickerController.mapMoving!();
              },
              onCameraMove: (cameraPosition) {
                this.cameraPosition = cameraPosition;
              },
              onCameraIdle: () async {
                // notify map stopped moving
                mapPickerController.mapFinishedMoving!();
                //get address name from camera position
                // List<Placemark> placemarks = await placemarkFromCoordinates(
                //   cameraPosition.target.latitude,
                //   cameraPosition.target.longitude,
                // );

                // update the ui with the address
                // textController.text =
                //     '${placemarks.first.name}, ${placemarks.first.administrativeArea}, ${placemarks.first.country}';
              },
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).viewPadding.top + 20,
            width: MediaQuery.of(context).size.width - 50,
            height: 50,
            child: TextFormField(
              maxLines: 3,
              textAlign: TextAlign.center,
              readOnly: true,
              decoration: const InputDecoration(
                  contentPadding: EdgeInsets.zero, border: InputBorder.none),
              controller: textController,
            ),
          ),
          Positioned(
            height: getProportionateScreenHeight(48),
            bottom: getProportionateScreenHeight(15),
            left: getProportionateScreenWidth(15),
            right: getProportionateScreenWidth(15),
            child: ElevatedButton(
              onPressed: () {
                print(
                    "Location ${cameraPosition.target.latitude} ${cameraPosition.target.longitude}");
                print("Address: ${textController.text}");
              },
              child: Text(
                'ยืนยันตำแหน่ง',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Palette.SecondaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
