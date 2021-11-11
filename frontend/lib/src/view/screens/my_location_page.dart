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
import 'package:trip_planner/src/services/location_nearby_service.dart';
import 'package:trip_planner/src/view/widgets/baggage_cart.dart';
import 'package:trip_planner/src/view_models/search_view_model.dart';

class MyLocationPage extends StatefulWidget {
  @override
  _MyLocationPageState createState() => _MyLocationPageState();
}

class _MyLocationPageState extends State<MyLocationPage> {
  Completer<GoogleMapController> _controller = Completer();
  double zoomLevel = 11;

  @override
  void initState() {
    Provider.of<SearchViewModel>(context, listen: false).getMapStyle();
    Provider.of<SearchViewModel>(context, listen: false).getUserLocation();
    zoomLevel =
        Provider.of<SearchViewModel>(context, listen: false).getZoomLevel(3000);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    // print('${currentLocation.latitude} , ${currentLocation.longitude}');
    final searchViewModel = Provider.of<SearchViewModel>(context);

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
                            searchViewModel.updateMapView(
                                _controller, r['r'] * 1000);
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
            buildGoogleMap(_controller, searchViewModel, zoomLevel),
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.only(
                      left: getProportionateScreenWidth(15),
                      right: getProportionateScreenWidth(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: searchViewModel.locationTypes.map((type) {
                        return Padding(
                          padding: EdgeInsets.only(
                              right: getProportionateScreenWidth(5)),
                          child: TextButton(
                            child: Text(
                              type['type'],
                              style: TextStyle(fontSize: 14),
                            ),
                            style: TextButton.styleFrom(
                              primary: Colors.white,
                              backgroundColor: Palette.AdditionText,
                              shadowColor: Palette.Outline,
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                            onPressed: () {
                              print('Pressed');
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: getProportionateScreenHeight(10),
                      bottom: getProportionateScreenHeight(15),
                    ),
                    height: getProportionateScreenHeight(110),
                    child: ListView(
                      padding: EdgeInsets.only(
                          left: getProportionateScreenWidth(15)),
                      scrollDirection: Axis.horizontal,
                      physics: ClampingScrollPhysics(),
                      children: [
                        pinCard(),
                        pinCard(),
                        pinCard(),
                        pinCard(),
                        pinCard(),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget buildGoogleMap(Completer<GoogleMapController> _controller,
    SearchViewModel searchViewModel, double zoomLevel) {
  return Container(
    child: GoogleMap(
      circles: Set.from([
        Circle(
          circleId: CircleId('1'),
          center: LatLng(searchViewModel.userLocation!.latitude ?? 0,
              searchViewModel.userLocation!.longitude ?? 0),
          radius: searchViewModel.circleRadius,
          strokeColor: Palette.AdditionText,
          fillColor: Color.fromRGBO(110, 121, 140, 0.3),
          strokeWidth: 1,
        ),
      ]),
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      myLocationButtonEnabled: false,
      myLocationEnabled: true,
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(
        target: LatLng(searchViewModel.userLocation!.latitude ?? 0,
            searchViewModel.userLocation!.longitude ?? 0),
        zoom: zoomLevel,
      ),
      markers: {},
      onMapCreated: (GoogleMapController controller) {
        controller.setMapStyle(searchViewModel.mapStyle);
        _controller.complete(controller);
      },
    ),
  );
}

Widget pinCard() {
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
              image: NetworkImage(
                  'https://storage.googleapis.com/swapgap-bucket/post/5190314163699712-babbd605-e3ed-407f-bdc8-dba57e81c76e'),
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
                'บ้านหุ่นเหล็กบ้านหุ่นเหล็กบ้านหุ่นเหล็กบ้านหุ่นเหล็ก',
                style: TextStyle(
                  color: Palette.BodyText,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: getProportionateScreenHeight(5)),
              child: Text(
                'ห่างออกไป 0.35 km',
                style: TextStyle(
                  color: Palette.SecondaryColor,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
              splashRadius: 1,
              iconSize: 36,
              onPressed: () {},
              icon: Icon(
                Icons.add_circle_outline_rounded,
                color: Palette.SecondaryColor,
              ),
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.only(
                right: getProportionateScreenWidth(15),
                bottom: getProportionateScreenWidth(10),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
