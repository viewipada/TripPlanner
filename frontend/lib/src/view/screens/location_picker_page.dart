import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:map_picker/map_picker.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/assets.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/size_config.dart';
import 'package:trip_planner/src/view_models/create_location_view_model.dart';
import 'package:trip_planner/src/view_models/search_start_point_view_model.dart';

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
    googlePlace = GooglePlace(GoogleAssets.googleAPI);
    cameraPosition = CameraPosition(
      target: initialLatLng,
      zoom: 15,
    );
    super.initState();
  }

  late CameraPosition cameraPosition;
  var textController = TextEditingController();
  late GooglePlace googlePlace;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final searchStartPointViewModel =
        Provider.of<SearchStartPointViewModel>(context);
    final createLocationViewModel =
        Provider.of<CreateLocationViewModel>(context);

    return WillPopScope(
      onWillPop: () async {
        searchStartPointViewModel.clearPredictions();
        return true;
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back_rounded),
              color: Palette.BackIconColor,
              onPressed: () {
                searchStartPointViewModel.goBack(context);
                searchStartPointViewModel.clearPredictions();
              },
            ),
            title: Text(
              "กำหนดตำแหน่ง",
              style: FontAssets.headingText,
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
          ),
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
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(15),
                      vertical: getProportionateScreenHeight(10),
                    ),
                    child: TextField(
                      controller: textController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: Palette.AdditionText,
                          size: 30,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.cancel_rounded,
                              color: Palette.Outline),
                          onPressed: () {
                            textController.clear();
                            searchStartPointViewModel.clearPredictions();
                          },
                        ),
                        hintText: 'ค้นหาตำแหน่ง',
                      ),
                      onChanged: (value) {
                        if (searchStartPointViewModel.sessionToken == null) {
                          searchStartPointViewModel.createSessionToken();
                        }
                        if (value.isNotEmpty) {
                          searchStartPointViewModel.autoCompleteSearch(
                              googlePlace, value);
                        } else {
                          searchStartPointViewModel.clearPredictions();
                        }
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(15)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: searchStartPointViewModel.predictions.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: CircleAvatar(
                            child: Icon(
                              Icons.pin_drop,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            searchStartPointViewModel
                                .predictions[index].description!,
                            style: FontAssets.bodyText,
                          ),
                          onTap: () {
                            searchStartPointViewModel.closeSessionToken();
                            // searchStartPointViewModel.getDetails(
                            //   context,
                            //   startPointList,
                            //   googlePlace,
                            //   searchStartPointViewModel
                            //       .predictions[index].placeId!,
                            //   searchStartPointViewModel
                            //       .predictions[index].description!,
                            // );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
              Positioned(
                height: getProportionateScreenHeight(48),
                bottom: getProportionateScreenHeight(15),
                left: getProportionateScreenWidth(15),
                right: getProportionateScreenWidth(15),
                child: ElevatedButton(
                  onPressed: () {
                    createLocationViewModel.selectedLocationPin(context,LatLng(cameraPosition.target.latitude,cameraPosition.target.longitude));
                    // print(
                    //     "Location ${cameraPosition.target.latitude} ${cameraPosition.target.longitude}");
                    // print("Address: ${textController.text}");
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
        ),
      ),
    );
  }
}
