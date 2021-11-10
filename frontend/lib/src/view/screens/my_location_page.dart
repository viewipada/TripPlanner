import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/assets.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/size_config.dart';
import 'package:trip_planner/src/view/widgets/baggage_cart.dart';
import 'package:trip_planner/src/view_models/search_view_model.dart';

class MyLocationPage extends StatefulWidget {
  @override
  _MyLocationPageState createState() => _MyLocationPageState();
}

class _MyLocationPageState extends State<MyLocationPage> {
  @override
  void initState() {
    Provider.of<SearchViewModel>(context, listen: false).getMapStyle();
    Provider.of<SearchViewModel>(context, listen: false).getUserLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    // print('${currentLocation.latitude} , ${currentLocation.longitude}');
    final searchViewModel = Provider.of<SearchViewModel>(context);
    // final List radius = [
    //   {'r': 1, 'isSelected': false},
    //   {'r': 3, 'isSelected': true},
    //   {'r': 5, 'isSelected': false}
    // ];
    _showRadiusSelectionAlert(
            BuildContext context, SearchViewModel searchViewModel) =>
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              'แสดงสถานที่ในรัศมี',
              style: TextStyle(
                fontSize: 14,
                color: Palette.AdditionText,
              ),
              textAlign: TextAlign.center,
            ),
            titlePadding: EdgeInsets.symmetric(
                vertical: getProportionateScreenHeight(20)),
            contentPadding: EdgeInsets.zero,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: searchViewModel.radius
                  .map(
                    (r) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Divider(),
                        ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: r['r'] == 5
                                ? BorderRadius.only(
                                    topLeft: Radius.zero,
                                    bottomLeft: Radius.circular(16),
                                    topRight: Radius.zero,
                                    bottomRight: Radius.circular(16),
                                  )
                                : BorderRadius.zero,
                          ),
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          selected: r['isSelected'],
                          selectedTileColor: Palette.SelectedListTileColor,
                          onTap: () {
                            searchViewModel.updateRadius(r);
                            Navigator.pop(context, r);
                          },
                          title: Text(
                            'รอบตัว ${r['r']} km',
                            style: TextStyle(
                              fontSize: 14,
                              color: r['isSelected']
                                  ? Palette.PrimaryColor
                                  : Palette.BodyText,
                              fontWeight: r['isSelected']
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
        );

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
        child: Stack(
          children: [
            buildGoogleMap(searchViewModel),
            Align(
              alignment: Alignment.topRight,
              child: Column(
                children: [
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
                        onPressed: () {},
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(right: getProportionateScreenWidth(15)),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 20,
                      child: IconButton(
                        constraints: BoxConstraints(),
                        padding: EdgeInsets.zero,
                        icon: ImageIcon(
                          AssetImage(IconAssets.radiusPin),
                        ),
                        color: Palette.SecondaryColor,
                        onPressed: () {
                          _showRadiusSelectionAlert(context, searchViewModel);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                color: Colors.amber,
                margin: EdgeInsets.symmetric(
                  vertical: getProportionateScreenHeight(15),
                ),
                height: 110,
                child: ListView(
                  padding:
                      EdgeInsets.only(left: getProportionateScreenWidth(15)),
                  scrollDirection: Axis.horizontal,
                  physics: ClampingScrollPhysics(),
                  children: [
                    Container(
                      color: Colors.blue,
                      width: SizeConfig.screenWidth -
                          getProportionateScreenWidth(50),
                      height: double.infinity,
                      margin: EdgeInsets.only(
                        right: getProportionateScreenWidth(15),
                      ),
                    ),
                    Container(
                      color: Colors.blue,
                      width: SizeConfig.screenWidth -
                          getProportionateScreenWidth(50),
                      height: double.infinity,
                      margin: EdgeInsets.only(
                        right: getProportionateScreenWidth(15),
                      ),
                    ),
                    Container(
                      color: Colors.blue,
                      width: SizeConfig.screenWidth -
                          getProportionateScreenWidth(50),
                      height: double.infinity,
                      margin: EdgeInsets.only(
                        right: getProportionateScreenWidth(15),
                      ),
                    ),
                    Container(
                      color: Colors.blue,
                      width: SizeConfig.screenWidth -
                          getProportionateScreenWidth(50),
                      height: double.infinity,
                      margin: EdgeInsets.only(
                        right: getProportionateScreenWidth(15),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget buildGoogleMap(SearchViewModel searchViewModel) {
  Completer<GoogleMapController> _controller = Completer();

  return Container(
      // child: GoogleMap(
      //   circles: Set.from([
      //     Circle(
      //       circleId: CircleId('1'),
      //       center: LatLng(searchViewModel.userLocation!.latitude ?? 0,
      //           searchViewModel.userLocation!.longitude ?? 0),
      //       radius: 5000,
      //       strokeColor: Palette.AdditionText,
      //       fillColor: Color.fromRGBO(110, 121, 140, 0.3),
      //       strokeWidth: 1,
      //     ),
      //   ]),
      //   zoomControlsEnabled: false,
      //   mapToolbarEnabled: false,
      //   myLocationButtonEnabled: false,
      //   myLocationEnabled: true,
      //   mapType: MapType.normal,
      //   initialCameraPosition: CameraPosition(
      //     target: LatLng(searchViewModel.userLocation!.latitude ?? 0,
      //         searchViewModel.userLocation!.longitude ?? 0),
      //     zoom: 12.5,
      //   ),
      //   markers: {
      //     Marker(
      //       markerId: MarkerId('1'),
      //       position: LatLng(searchViewModel.userLocation!.latitude ?? 0,
      //           searchViewModel.userLocation!.longitude ?? 0),
      //       infoWindow: InfoWindow(
      //         title:
      //             '${searchViewModel.userLocation!.latitude} , ${searchViewModel.userLocation!.longitude}',
      //       ),
      //     ),
      //   },
      //   onMapCreated: (GoogleMapController controller) {
      //     controller.setMapStyle(searchViewModel.mapStyle);
      //     _controller.complete(controller);
      //   },
      // ),
      );
}
