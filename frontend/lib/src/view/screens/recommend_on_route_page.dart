import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:trip_planner/assets.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/size_config.dart';
import 'package:trip_planner/src/models/response/location_recommend_response.dart';
import 'package:trip_planner/src/models/trip_item.dart';
import 'package:trip_planner/src/view/widgets/loading.dart';
import 'package:trip_planner/src/view_models/trip_stepper_view_model.dart';

class RecommendOnRoutePage extends StatefulWidget {
  final List<TripItem> tripItems;
  final List<LocationRecommendResponse> locationList;

  RecommendOnRoutePage({
    required this.tripItems,
    required this.locationList,
  });

  @override
  _RecommendOnRoutePageState createState() =>
      _RecommendOnRoutePageState(this.tripItems, this.locationList);
}

class _RecommendOnRoutePageState extends State<RecommendOnRoutePage> {
  List<TripItem> tripItems;
  final List<LocationRecommendResponse> locationList;

  _RecommendOnRoutePageState(this.tripItems, this.locationList);

  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();
    Provider.of<TripStepperViewModel>(context, listen: false).getMapStyle();
    Provider.of<TripStepperViewModel>(context, listen: false)
        .getPolyline(tripItems);
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
      ),
      body: SafeArea(
        child: Stack(
          children: [
            FutureBuilder(
              future: tripStepperViewModel.getMarkersRecommend(
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
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  0,
                  getProportionateScreenHeight(15),
                  getProportionateScreenWidth(15),
                  getProportionateScreenHeight(10),
                ),
                child: Container(
                  decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
                    BoxShadow(
                        color: Colors.black54,
                        blurRadius: 5,
                        offset: Offset(0.75, 0.75)),
                  ]),
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
                      onPressed: () => Navigator.pop(context),
                    ),
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
        // Future.delayed(Duration(seconds: 1));
        controller.setMapStyle(tripStepperViewModel.mapStyle);
        _controller.complete(controller);
      },
    ),
  );
}

Widget pinCard(LocationRecommendResponse location) {
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
          children: [
            Container(
              width: SizeConfig.screenWidth - getProportionateScreenWidth(230),
              padding: EdgeInsets.only(top: getProportionateScreenHeight(15)),
              child: Text(
                '${location.locationName}',
                style: FontAssets.subtitleText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Row(
              children: [
                Text(
                  '${location.rating} ',
                  style: FontAssets.bodyText,
                ),
                RatingBarIndicator(
                  unratedColor: Palette.Outline,
                  rating: location.rating,
                  itemBuilder: (context, index) => Icon(
                    Icons.star_rounded,
                    color: Palette.CautionColor,
                  ),
                  itemCount: 5,
                  itemSize: 20,
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: getProportionateScreenHeight(5)),
              child: Text(
                '${location.distance} km จากจุดก่อนหน้า',
                style: TextStyle(
                  color: Palette.SecondaryColor,
                  fontSize: 14,
                ),
              ),
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
