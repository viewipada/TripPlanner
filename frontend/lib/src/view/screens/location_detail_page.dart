import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/assets.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/size_config.dart';
import 'package:trip_planner/src/models/response/opening_hour.dart';
import 'package:trip_planner/src/repository/shared_pref.dart';
import 'package:trip_planner/src/view/widgets/baggage_cart.dart';
import 'package:trip_planner/src/view/widgets/loading.dart';
import 'package:trip_planner/src/view/widgets/review_card.dart';
import 'package:trip_planner/src/view/widgets/tag_category.dart';
import 'package:trip_planner/src/view_models/location_detail_view_model.dart';

class LocationDetailPage extends StatefulWidget {
  LocationDetailPage({
    required this.locationId,
  });

  final int locationId;

  @override
  _LocationDetailPageState createState() =>
      _LocationDetailPageState(this.locationId);
}

class _LocationDetailPageState extends State<LocationDetailPage> {
  final int _locationId;
  _LocationDetailPageState(this._locationId);
  Completer<GoogleMapController> _controller = Completer();
  var isInBaggage;
  int baggageCount = 0;
  @override
  void initState() {
    super.initState();
    SharedPref().getBaggageItems().then((value) {
      setState(() {
        baggageCount = value.length;
        isInBaggage = value.contains('${_locationId}');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final locationDetailViewModel =
        Provider.of<LocationDetailViewModel>(context);

    return Scaffold(
        body: FutureBuilder(
      future: Provider.of<LocationDetailViewModel>(context, listen: false)
          .getLocationDetailById(this._locationId),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: getProportionateScreenHeight(220),
                flexibleSpace: FlexibleSpaceBar(
                  background: Image.network(
                    locationDetailViewModel.locationDetail.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_rounded),
                  color: Palette.BackIconColor,
                  onPressed: () {
                    locationDetailViewModel.goBack(context);
                  },
                ),
                actions: [
                  BaggageCart(),
                ],
                backgroundColor: Colors.transparent,
                elevation: 0.0,
              ),
              SliverToBoxAdapter(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(
                        getProportionateScreenWidth(15),
                        getProportionateScreenHeight(15),
                        getProportionateScreenWidth(15),
                        getProportionateScreenHeight(5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              locationDetailViewModel
                                  .locationDetail.locationName,
                              style: FontAssets.titleText,
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                constraints: BoxConstraints(),
                                onPressed: () {
                                  locationDetailViewModel
                                      .tryToCheckin(this._locationId)
                                      .then((value) {
                                    if (value == 200) {
                                      final snackBar = SnackBar(
                                        backgroundColor: Palette.SecondaryColor,
                                        content: Text(
                                          '???????????????????????????????????????',
                                          style: const TextStyle(
                                            fontFamily: 'Sukhumvit',
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    } else {
                                      alertDialog(context,
                                          '?????????????????????????????????????????????????????????????????? ?????????????????????????????????????????????\n?????????????????????????????????????????????????????????????????????????????????????????? 500 ????????????');
                                    }
                                  });
                                },
                                icon: Icon(
                                  Icons.pin_drop_outlined,
                                  color: Palette.AdditionText,
                                  size: 26,
                                ),
                                padding: EdgeInsets.zero,
                              ),
                              SizedBox(
                                width: getProportionateScreenWidth(15),
                              ),
                              isInBaggage == null
                                  ? SizedBox()
                                  : IconButton(
                                      constraints: BoxConstraints(),
                                      onPressed: () {
                                        if (isInBaggage) {
                                          locationDetailViewModel
                                              .removeBaggageItem(_locationId)
                                              .then((value) {
                                            if (value == 200)
                                              setState(() {
                                                isInBaggage = false;
                                              });
                                          });
                                        } else {
                                          if (baggageCount == 30) {
                                            alertDialog(context,
                                                '??????????????????????????????????????????????????????????????????!\n???????????????????????????????????????????????????????????????????????? 30 ?????????????????????');
                                          } else {
                                            locationDetailViewModel
                                                .addBaggageItem(_locationId)
                                                .then((value) {
                                              if (value == 201)
                                                setState(() {
                                                  isInBaggage = true;
                                                });
                                            });
                                          }
                                        }
                                      },
                                      icon: ImageIcon(
                                        AssetImage(isInBaggage
                                            ? IconAssets.baggageDelete
                                            : IconAssets.baggageAdd),
                                        color: isInBaggage
                                            ? Palette.DeleteColor
                                            : Palette.AdditionText,
                                      ),
                                      padding: EdgeInsets.zero,
                                    ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: getProportionateScreenWidth(15)),
                      child: TagCategory(
                        category:
                            locationDetailViewModel.locationDetail.category == 1
                                ? '???????????????????????????'
                                : locationDetailViewModel
                                            .locationDetail.category ==
                                        2
                                    ? '??????????????????'
                                    : '??????????????????',
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(
                        getProportionateScreenWidth(15),
                        getProportionateScreenHeight(10),
                        getProportionateScreenWidth(15),
                        getProportionateScreenHeight(5),
                      ),
                      child: LayoutBuilder(
                        builder: (context, size) {
                          var span = TextSpan(
                            text: locationDetailViewModel
                                .locationDetail.description,
                            style: FontAssets.bodyText,
                          );

                          var tp = TextPainter(
                            maxLines: 3,
                            textAlign: TextAlign.left,
                            textDirection: TextDirection.ltr,
                            text: span,
                          );

                          tp.layout(maxWidth: size.maxWidth);

                          var exceeded = tp.didExceedMaxLines;

                          return Column(
                            children: [
                              Text.rich(
                                span,
                                overflow: TextOverflow.ellipsis,
                                maxLines:
                                    locationDetailViewModel.readMore ? 100 : 3,
                              ),
                              Visibility(
                                visible: exceeded,
                                child: Container(
                                  margin: EdgeInsets.only(
                                    bottom: getProportionateScreenHeight(5),
                                  ),
                                  width: double.infinity,
                                  height: 20,
                                  child: TextButton(
                                    onPressed: () {
                                      locationDetailViewModel
                                          .toggleReadmoreButton();
                                    },
                                    child: Text(locationDetailViewModel.readMore
                                        ? '????????????????????????'
                                        : '?????????????????????????????????'),
                                    style: TextButton.styleFrom(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.zero,
                                      textStyle: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'Sukhumvit'),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(
                        getProportionateScreenWidth(10),
                        getProportionateScreenHeight(10),
                        getProportionateScreenWidth(15),
                        getProportionateScreenHeight(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.hourglass_empty_rounded,
                            color: Palette.SecondaryColor,
                            size: 18,
                          ),
                          Text(
                            ' ?????????????????????????????? ${locationDetailViewModel.locationDetail.duration}hr',
                            style: FontAssets.bodyText,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(
                        getProportionateScreenWidth(15),
                        0,
                        getProportionateScreenWidth(15),
                        getProportionateScreenHeight(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '?????????????????????????????????????????????',
                            style: FontAssets.subtitleText,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Palette.PrimaryColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            padding: EdgeInsets.fromLTRB(
                              getProportionateScreenWidth(8),
                              getProportionateScreenHeight(3),
                              getProportionateScreenWidth(8),
                              getProportionateScreenHeight(3),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                Text(
                                  ' ????????????????????????????????? ${locationDetailViewModel.locationDetail.totalCheckin} ???????????????',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: getProportionateScreenHeight(175),
                      child: GoogleMap(
                        myLocationButtonEnabled: false,
                        // myLocationEnabled: true,
                        mapType: MapType.normal,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                              locationDetailViewModel.locationDetail.latitude,
                              locationDetailViewModel.locationDetail.longitude),
                          zoom: 15,
                        ),
                        zoomControlsEnabled: false,
                        markers: {
                          Marker(
                              markerId: MarkerId(locationDetailViewModel
                                  .locationDetail.locationName),
                              position: LatLng(
                                  locationDetailViewModel
                                      .locationDetail.latitude,
                                  locationDetailViewModel
                                      .locationDetail.longitude),
                              infoWindow: InfoWindow(
                                title: locationDetailViewModel
                                    .locationDetail.locationName,
                              )),
                        },
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        getProportionateScreenWidth(15),
                        getProportionateScreenHeight(15),
                        getProportionateScreenWidth(15),
                        getProportionateScreenHeight(10),
                      ),
                      child: Text(
                        '??????????????????????????????',
                        style: FontAssets.subtitleText,
                      ),
                    ),
                    locationDetailViewModel.locationDetail.category == 3
                        ? detailLocation('????????????????????????',
                            '${locationDetailViewModel.locationDetail.minPrice} - ${locationDetailViewModel.locationDetail.maxPrice} ?????????')
                        : SizedBox(),
                    openingHour(
                      '?????????????????????????????????-?????????',
                      locationDetailViewModel.locationDetail.openingHour,
                    ),
                    detailLocation('?????????????????????????????????',
                        locationDetailViewModel.locationDetail.contactNumber),
                    detailLocation('????????????????????????',
                        locationDetailViewModel.locationDetail.website),
                    SizedBox(
                      height: getProportionateScreenHeight(10),
                    ),
                    Divider(),
                    Container(
                      padding: EdgeInsets.fromLTRB(
                        getProportionateScreenWidth(15),
                        getProportionateScreenHeight(10),
                        getProportionateScreenWidth(15),
                        getProportionateScreenHeight(5),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Container(
                              child: Text(
                                '??????????????? (${locationDetailViewModel.locationDetail.totalReview})',
                                textAlign: TextAlign.start,
                                style: FontAssets.subtitleText,
                              ),
                            ),
                          ),
                          Visibility(
                            visible: locationDetailViewModel
                                    .locationDetail.totalReview >
                                3,
                            child: Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  locationDetailViewModel
                                      .goToLocationDetailReviewsPage(
                                    context,
                                    locationDetailViewModel
                                        .locationDetail.locationId,
                                    locationDetailViewModel
                                        .locationDetail.locationName,
                                    locationDetailViewModel
                                        .locationDetail.totalReview,
                                    double.parse(locationDetailViewModel
                                        .locationDetail.averageRating),
                                  );
                                },
                                child: Container(
                                  child: Text(
                                    "????????????????????????????????? >> ",
                                    textAlign: TextAlign.end,
                                    style: FontAssets.hintText,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(
                        getProportionateScreenWidth(15),
                        0,
                        getProportionateScreenWidth(15),
                        getProportionateScreenHeight(5),
                      ),
                      child: Row(
                        children: [
                          Text(
                            '${locationDetailViewModel.locationDetail.averageRating} ',
                            style: FontAssets.bodyText,
                          ),
                          RatingBarIndicator(
                            unratedColor: Palette.Outline,
                            rating: double.parse(locationDetailViewModel
                                .locationDetail.averageRating),
                            itemBuilder: (context, index) => Icon(
                              Icons.star_rounded,
                              color: Palette.CautionColor,
                            ),
                            itemCount: 5,
                            itemSize: 20,
                          ),
                        ],
                      ),
                    ),
                    ReviewCard(
                      reviews: locationDetailViewModel.locationDetail.reviews,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        getProportionateScreenWidth(15),
                        getProportionateScreenHeight(5),
                        getProportionateScreenWidth(15),
                        getProportionateScreenHeight(15),
                      ),
                      child: OutlinedButton(
                        onPressed: () {
                          locationDetailViewModel.goToReviewPage(
                              context,
                              locationDetailViewModel
                                  .locationDetail.locationName,
                              locationDetailViewModel
                                  .locationDetail.locationId);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.send_rounded,
                            ),
                            Text(
                              ' ????????????????????????????????????????????????',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          primary: Palette.SecondaryColor,
                          alignment: Alignment.center,
                          side: BorderSide(color: Palette.SecondaryColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          print(snapshot.error);
          return Container(
            color: Colors.red,
          );
        } else {
          return Loading();
        }
      },
    ));
  }
}

Widget detailLocation(String title, String detail) {
  return Container(
    margin: EdgeInsets.fromLTRB(
      getProportionateScreenWidth(15),
      0,
      getProportionateScreenWidth(15),
      getProportionateScreenHeight(5),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Text(
            title,
            style: TextStyle(color: Palette.BodyText, fontSize: 14),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            detail,
            style: FontAssets.bodyText,
          ),
        ),
      ],
    ),
  );
}

Widget openingHour(String title, OpeningHour openingHour) {
  return Container(
    margin: EdgeInsets.fromLTRB(
      getProportionateScreenWidth(15),
      0,
      getProportionateScreenWidth(15),
      getProportionateScreenHeight(5),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Text(
            title,
            style: TextStyle(color: Palette.BodyText, fontSize: 14),
          ),
        ),
        Expanded(
          flex: 2,
          child: openingHour.mon == "?????????" &&
                  openingHour.tue == "?????????" &&
                  openingHour.wed == "?????????" &&
                  openingHour.thu == "?????????" &&
                  openingHour.fri == "?????????" &&
                  openingHour.sat == "?????????" &&
                  openingHour.sun == "?????????"
              ? Text(
                  "-",
                  style: FontAssets.bodyText,
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "???????????????????????????",
                            style: FontAssets.bodyText,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "${openingHour.mon}",
                            style: FontAssets.bodyText,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "???????????????????????????",
                            style: FontAssets.bodyText,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "${openingHour.tue}",
                            style: FontAssets.bodyText,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "??????????????????",
                            style: FontAssets.bodyText,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "${openingHour.wed}",
                            style: FontAssets.bodyText,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "?????????????????????????????????",
                            style: FontAssets.bodyText,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "${openingHour.thu}",
                            style: FontAssets.bodyText,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "????????????????????????",
                            style: FontAssets.bodyText,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "${openingHour.fri}",
                            style: FontAssets.bodyText,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "????????????????????????",
                            style: FontAssets.bodyText,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "${openingHour.sat}",
                            style: FontAssets.bodyText,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "??????????????????????????????",
                            style: FontAssets.bodyText,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "${openingHour.sun}",
                            style: FontAssets.bodyText,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ],
    ),
  );
}

alertDialog(BuildContext context, String title) {
  return showDialog<String>(
    context: context,
    builder: (BuildContext _context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Palette.BodyText,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
      contentPadding: EdgeInsets.zero,
      actionsAlignment: MainAxisAlignment.center,
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(
            _context,
          ),
          child: const Text(
            '????????????!',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}
