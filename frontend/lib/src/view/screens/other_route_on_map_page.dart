import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:trip_planner/assets.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/size_config.dart';
import 'package:trip_planner/src/models/response/other_trip_response.dart';
import 'package:trip_planner/src/view/widgets/loading.dart';
import 'package:trip_planner/src/view/widgets/tag_category.dart';
import 'package:trip_planner/src/view_models/trip_stepper_view_model.dart';

class OtherRouteOnMapPage extends StatefulWidget {
  final List<int> days;
  final int tripId;

  OtherRouteOnMapPage({required this.days, required this.tripId});

  @override
  _OtherRouteOnMapPageState createState() =>
      _OtherRouteOnMapPageState(this.days, this.tripId);
}

class _OtherRouteOnMapPageState extends State<OtherRouteOnMapPage> {
  final List<int> days;
  final int tripId;
  List<OtherTripItemResponse> tripItems = [];

  _OtherRouteOnMapPageState(this.days, this.tripId);

  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();
    Provider.of<TripStepperViewModel>(context, listen: false).getMapStyle();
    Provider.of<TripStepperViewModel>(context, listen: false)
        .getOtherTripDetail(tripId)
        .then((value) {
      setState(() {
        tripItems = value.tripItems;
      });
    }).then((value) {
      Provider.of<TripStepperViewModel>(context, listen: false)
          .getPolyline(tripItems);
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final tripStepperViewModel = Provider.of<TripStepperViewModel>(context);

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
        child: tripItems.isEmpty
            ? Loading()
            : Stack(
                children: [
                  FutureBuilder(
                    future: tripStepperViewModel.getMarkersOtherTrip(tripItems),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
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
                                  .map((day) => buildDayButton(
                                      day,
                                      tripStepperViewModel,
                                      _controller,
                                      tripItems))
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
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      margin: EdgeInsets.only(
                        bottom: getProportionateScreenHeight(15),
                      ),
                      height: getProportionateScreenHeight(110),
                      child: FutureBuilder(
                        future: tripStepperViewModel.getPinCard(tripItems),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            return ScrollablePositionedList.builder(
                              padding: EdgeInsets.only(
                                  left: getProportionateScreenWidth(15)),
                              scrollDirection: Axis.horizontal,
                              physics: ClampingScrollPhysics(),
                              initialScrollIndex: 0,
                              itemScrollController:
                                  tripStepperViewModel.itemScrollController,
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) => InkWell(
                                  onTap: () => snapshot.data[index].imageUrl ==
                                          ""
                                      ? null
                                      : tripStepperViewModel.goToLocationDetail(
                                          context,
                                          snapshot.data[index].locationId),
                                  child: pinCard(snapshot.data[index])),
                            );
                          } else {
                            return SizedBox();
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

Widget buildDayButton(
    int day,
    TripStepperViewModel tripStepperViewModel,
    Completer<GoogleMapController> _controller,
    List<OtherTripItemResponse> tripItems) {
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
      markers: markers,
      polylines: Set<Polyline>.of(tripStepperViewModel.polylines.values),
      onMapCreated: (GoogleMapController controller) {
        Future.delayed(Duration(seconds: 1));
        controller.setMapStyle(tripStepperViewModel.mapStyle);
        _controller.complete(controller);
      },
    ),
  );
}

Widget pinCard(OtherTripItemResponse location) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.white,
      border: Border.all(color: Palette.Outline),
    ),
    width: SizeConfig.screenWidth - getProportionateScreenWidth(80),
    height: double.infinity,
    margin: EdgeInsets.only(
      right: getProportionateScreenWidth(15),
    ),
    child: Row(
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(15)),
          child: location.imageUrl == ""
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image(
                    width: getProportionateScreenHeight(80),
                    height: getProportionateScreenHeight(80),
                    fit: BoxFit.cover,
                    image: AssetImage(ImageAssets.noPreview),
                  ),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image(
                    width: getProportionateScreenHeight(80),
                    height: getProportionateScreenHeight(80),
                    fit: BoxFit.cover,
                    image: NetworkImage(location.imageUrl),
                  ),
                ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width:
                      SizeConfig.screenWidth - getProportionateScreenWidth(230),
                  padding:
                      EdgeInsets.only(top: getProportionateScreenHeight(15)),
                  child: Text(
                    '${location.no + 1}. ${location.locationName}',
                    style: FontAssets.subtitleText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  location.no == 0
                      ? 'จุดเริ่มต้น'
                      : '${location.distance} km จากจุดก่อนหน้า',
                  style: TextStyle(
                    color: Palette.SecondaryColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            location.imageUrl == ""
                ? SizedBox()
                : Padding(
                    padding: EdgeInsets.only(
                        bottom: getProportionateScreenHeight(15)),
                    child: TagCategory(
                        category: location.locationCategory == 1
                            ? "ที่เที่ยว"
                            : location.locationCategory == 2
                                ? "ที่กิน"
                                : "ที่พัก"),
                  )
          ],
        ),
      ],
    ),
  );
}
