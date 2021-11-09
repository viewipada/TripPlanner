import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:trip_planner/assets.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/size_config.dart';
import 'package:trip_planner/src/models/response/travel_nearby_response.dart';
import 'package:trip_planner/src/view/widgets/baggage_cart.dart';
import 'package:trip_planner/src/view/widgets/loading.dart';
import 'package:trip_planner/src/view/widgets/tag_category.dart';
import 'package:trip_planner/src/view_models/search_view_model.dart';

class MyLocationPage extends StatefulWidget {
  MyLocationPage({
    required this.category,
    required this.userLocation,
  });

  final String category;
  final LocationData userLocation;

  @override
  _MyLocationPageState createState() =>
      _MyLocationPageState(this.category, this.userLocation);
}

class _MyLocationPageState extends State<MyLocationPage> {
  final String category;
  final LocationData userLocation;
  _MyLocationPageState(this.category, this.userLocation);

  Completer<GoogleMapController> _controller = Completer();
  double zoomLevel = 11;

  @override
  void initState() {
    Provider.of<SearchViewModel>(context, listen: false).getMapStyle();
    Provider.of<SearchViewModel>(context, listen: false)
        .getLocationNearby(category, userLocation);
    zoomLevel =
        Provider.of<SearchViewModel>(context, listen: false).getZoomLevel(3000);
    Provider.of<SearchViewModel>(context, listen: false)
        .initialCategory(category);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
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
            FutureBuilder(
              future: searchViewModel
                  .getMarkersWithRadius(searchViewModel.circleRadius),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return buildGoogleMap(
                      _controller, searchViewModel, zoomLevel, userLocation);
                } else {
                  return Loading();
                }
              },
            ),
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
                        onPressed: () => showModalBottomSheet(
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (context) => makeDismissible(
                              locationListView(searchViewModel), context),
                        ),
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
                      children:
                          searchViewModel.locationCategories.map((category) {
                        return Padding(
                          padding: EdgeInsets.only(
                              bottom: getProportionateScreenHeight(10),
                              right: getProportionateScreenWidth(5)),
                          child: TextButton(
                            child: Text(
                              category['category'],
                              style: TextStyle(fontSize: 14),
                            ),
                            style: TextButton.styleFrom(
                              primary: Colors.white,
                              backgroundColor: category['isSelected'] == true
                                  ? Palette.SecondaryColor
                                  : Palette.AdditionText,
                              shadowColor: Palette.Outline,
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                            onPressed: () {
                              searchViewModel.getLocationNearby(
                                  category['category'], userLocation);
                              searchViewModel.updateCategorySelection(category);
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  Visibility(
                    visible: searchViewModel.locationPinCard.isNotEmpty,
                    child: Container(
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
                            searchViewModel.itemScrollController,
                        itemCount: searchViewModel.locationPinCard.length,
                        itemBuilder: (context, index) => InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                ),
                                context: context,
                                builder: (BuildContext context) {
                                  return locationDetailsBottomSheet(
                                    searchViewModel.locationPinCard[index],
                                    searchViewModel,
                                    context,
                                  );
                                },
                              );
                            },
                            child: pinCard(
                                searchViewModel.locationPinCard[index])),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget buildGoogleMap(
    Completer<GoogleMapController> _controller,
    SearchViewModel searchViewModel,
    double zoomLevel,
    LocationData userLocation) {
  return Container(
    child: GoogleMap(
      circles: Set.from([
        Circle(
          circleId: CircleId('radiusFormUserLocation'),
          center: LatLng(
            userLocation.latitude ?? 0,
            userLocation.longitude ?? 0,
          ),
          radius: searchViewModel.circleRadius,
          strokeColor: Palette.AdditionText,
          fillColor: Color.fromRGBO(110, 121, 140, 0.6),
          strokeWidth: 1,
        ),
      ]),
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      myLocationButtonEnabled: false,
      myLocationEnabled: true,
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(
        target: LatLng(
          userLocation.latitude ?? 0,
          userLocation.longitude ?? 0,
        ),
        zoom: zoomLevel,
      ),
      markers: searchViewModel.markers,
      onMapCreated: (GoogleMapController controller) {
        Future.delayed(Duration(seconds: 1));
        controller.setMapStyle(searchViewModel.mapStyle);
        _controller.complete(controller);
      },
    ),
  );
}

Widget pinCard(LocationNearbyResponse location) {
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
                location.locationName,
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
                'ห่างออกไป ${location.ditanceFromeUser} km',
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

Widget makeDismissible(Widget child, BuildContext context) => GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).pop(),
      child: GestureDetector(onTap: () {}, child: child),
    );

Widget locationListView(SearchViewModel searchViewModel) {
  return DraggableScrollableSheet(
    initialChildSize: 0.5,
    minChildSize: 0.3,
    maxChildSize: 0.8,
    builder: (_, controller) => Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.symmetric(
              vertical: getProportionateScreenHeight(15),
            ),
            height: getProportionateScreenHeight(5),
            width: getProportionateScreenWidth(50),
            decoration: BoxDecoration(
              color: Palette.Outline,
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          Expanded(
            child: searchViewModel.locationPinCard.isEmpty
                ? Center(
                    child: Text(
                      'ไม่มีรายการสถานที่ใกล้ตัวคุณ',
                      style:
                          TextStyle(fontSize: 14, color: Palette.AdditionText),
                    ),
                  )
                : ListView(
                    controller: controller,
                    children: searchViewModel.locationPinCard
                        .map(
                          (item) => Container(
                            height: getProportionateScreenHeight(110),
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: getProportionateScreenWidth(15),
                                  ),
                                  child: Center(
                                    child: Container(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image(
                                          width:
                                              getProportionateScreenHeight(100),
                                          height:
                                              getProportionateScreenHeight(100),
                                          fit: BoxFit.cover,
                                          image: NetworkImage(item.imageUrl),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(
                                      getProportionateScreenWidth(10),
                                      getProportionateScreenHeight(5),
                                      getProportionateScreenWidth(15),
                                      getProportionateScreenHeight(5),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                            bottom:
                                                getProportionateScreenHeight(5),
                                          ),
                                          child: Text(
                                            item.locationName,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                            bottom:
                                                getProportionateScreenHeight(5),
                                          ),
                                          child: Text(
                                            item.description,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Palette.BodyText,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              TagCategory(
                                                category: item.category,
                                              ),
                                              ElevatedButton.icon(
                                                onPressed: () {},
                                                icon: Icon(
                                                  Icons.add,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                                label: Text(
                                                  'เพิ่มลงกระเป๋า',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                    primary:
                                                        Palette.PrimaryColor,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    elevation: 0),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
          ),
        ],
      ),
    ),
  );
}

Widget locationDetailsBottomSheet(LocationNearbyResponse location,
    SearchViewModel searchViewModel, BuildContext context) {
  return Container(
    padding: EdgeInsets.symmetric(
        vertical: getProportionateScreenHeight(15),
        horizontal: getProportionateScreenWidth(15)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            margin: EdgeInsets.only(
              bottom: getProportionateScreenHeight(15),
            ),
            height: getProportionateScreenHeight(5),
            width: getProportionateScreenWidth(50),
            decoration: BoxDecoration(
              color: Palette.Outline,
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        ),
        Text(
          location.locationName,
          style: TextStyle(
            color: Palette.BodyText,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            margin: EdgeInsets.symmetric(
                vertical: getProportionateScreenHeight(15)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: NetworkImage(location.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            location.description,
            style: TextStyle(
              color: Palette.AdditionText,
              fontSize: 12,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  searchViewModel.goToLocationDetail(
                      context, location.locationId);
                },
                child: Text(
                  'ดูเพิ่มเติม',
                  style: TextStyle(fontSize: 14),
                ),
              ),
              SizedBox(width: getProportionateScreenWidth(15)),
              ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 20,
                ),
                label: Text(
                  'เพิ่มลงกระเป๋า',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    primary: Palette.PrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    elevation: 0),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
