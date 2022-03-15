import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:trip_planner/assets.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/size_config.dart';
import 'package:trip_planner/src/models/response/baggage_response.dart';
import 'package:trip_planner/src/models/trip_item.dart';
import 'package:trip_planner/src/view/widgets/loading.dart';
import 'package:trip_planner/src/view/widgets/tag_category.dart';
import 'package:trip_planner/src/view_models/trip_stepper_view_model.dart';

class BaggageLocationOnRoutePage extends StatefulWidget {
  final List<TripItem> tripItems;
  final List<BaggageResponse> locationList;

  BaggageLocationOnRoutePage({
    required this.tripItems,
    required this.locationList,
  });

  @override
  _BaggageLocationOnRoutePageState createState() =>
      _BaggageLocationOnRoutePageState(this.tripItems, this.locationList);
}

class _BaggageLocationOnRoutePageState
    extends State<BaggageLocationOnRoutePage> {
  List<TripItem> tripItems;
  final List<BaggageResponse> locationList;

  _BaggageLocationOnRoutePageState(this.tripItems, this.locationList);

  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();
    Provider.of<TripStepperViewModel>(context, listen: false).getMapStyle();
    // Provider.of<TripStepperViewModel>(context, listen: false)
    //     .getPolyline(tripItems);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final tripStepperViewModel = Provider.of<TripStepperViewModel>(context);

    return Scaffold(
      appBar: AppBar(
       
        title: Text(
          "ตำแหน่งในเส้นทาง",
          style: FontAssets.headingText,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        // elevation: 0,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            FutureBuilder(
              future: tripStepperViewModel.getBaggageMarkers(
                  tripItems, locationList),
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
              child: Container(
                margin: EdgeInsets.only(
                  top: getProportionateScreenHeight(20),
                ),
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: getProportionateScreenHeight(10)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ImageIcon(
                          AssetImage(IconAssets.locationListView),
                        ),
                        Text(
                          ' ดูรายการสถานที่',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    primary: Palette.SecondaryColor,
                    alignment: Alignment.center,
                    side: BorderSide(color: Palette.SecondaryColor),
                  ),
                ),
              ),
            
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(15),
                      vertical: getProportionateScreenHeight(5),
                    ),
                    child: instruction(
                        ' แสดงตำแหน่งบนเส้นทาง วันที่ ${tripStepperViewModel.day} ของทริป'),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      bottom: getProportionateScreenHeight(15),
                    ),
                    height: getProportionateScreenHeight(110),
                    child: ScrollablePositionedList.builder(
                      padding: EdgeInsets.only(
                          left: getProportionateScreenWidth(15)),
                      scrollDirection: Axis.horizontal,
                      physics: ClampingScrollPhysics(),
                      initialScrollIndex: 0,
                      itemScrollController:
                          tripStepperViewModel.itemScrollController,
                      itemCount: locationList.length,
                      itemBuilder: (context, index) => InkWell(
                          onTap: () => tripStepperViewModel.goToLocationDetail(
                              context, locationList[index].locationId),
                          child: pinCard(locationList[index])),
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
            // tripStepperViewModel.getPolyline(tripItems);
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
        // Future.delayed(Duration(seconds: 1));
        controller.setMapStyle(tripStepperViewModel.mapStyle);
        _controller.complete(controller);
      },
    ),
  );
}

Widget pinCard(BaggageResponse location) {
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
          child: ClipRRect(
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
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Container(
                  width:
                      SizeConfig.screenWidth - getProportionateScreenWidth(230),
                  padding:
                      EdgeInsets.only(top: getProportionateScreenHeight(15)),
                  child: Text(
                    '${location.locationName}',
                    style: FontAssets.subtitleText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  width:
                      SizeConfig.screenWidth - getProportionateScreenWidth(230),
                  child: Text(
                    '${location.description}',
                    style: FontAssets.hintText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Padding(
              padding:
                  EdgeInsets.only(bottom: getProportionateScreenHeight(15)),
              child: TagCategory(category: location.category),
            ),
          ],
        ),
        // Expanded(
        //   child: Align(
        //     alignment: Alignment.bottomRight,
        //     child: IconButton(
        //       splashRadius: 1,
        //       iconSize: 36,
        //       onPressed: () {},
        //       icon: Icon(
        //         Icons.add_circle_outline_rounded,
        //         color: Palette.SecondaryColor,
        //       ),
        //       alignment: Alignment.bottomRight,
        //       padding: EdgeInsets.only(
        //         right: getProportionateScreenWidth(15),
        //         bottom: getProportionateScreenWidth(10),
        //       ),
        //     ),
        //   ),
        // ),
      ],
    ),
  );
}

Widget instruction(String text) {
  return Container(
    padding: EdgeInsets.symmetric(
      vertical: getProportionateScreenHeight(10),
      horizontal: getProportionateScreenWidth(10),
    ),
    margin: EdgeInsets.only(
      bottom: getProportionateScreenHeight(5),
    ),
    decoration: BoxDecoration(
      color: Color(0xffFEFFE1),
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
      border: Border.all(color: Palette.LightOrangeColor),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.lightbulb_outline_rounded,
          color: Palette.LightOrangeColor,
          size: 20,
        ),
        Text(
          text,
          style: TextStyle(
              color: Palette.LightOrangeColor,
              fontWeight: FontWeight.bold,
              fontSize: 12),
        ),
      ],
    ),
  );
}
