import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_place/google_place.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/assets.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/size_config.dart';
import 'package:trip_planner/src/models/response/baggage_response.dart';
import 'package:trip_planner/src/models/response/location_recommend_response.dart';
import 'package:trip_planner/src/view/widgets/loading.dart';
import 'package:trip_planner/src/view/widgets/start_point_card.dart';
import 'package:trip_planner/src/view_models/search_start_point_view_model.dart';
import 'package:trip_planner/src/view_models/search_view_model.dart';
import 'package:trip_planner/src/view_models/trip_stepper_view_model.dart';

class LocationRecommendPage extends StatefulWidget {
  LocationRecommendPage({
    required this.locationCategory,
  });
  final String locationCategory;

  @override
  _LocationRecommendPageState createState() =>
      _LocationRecommendPageState(this.locationCategory);
}

class _LocationRecommendPageState extends State<LocationRecommendPage> {
  final String locationCategory;
  _LocationRecommendPageState(this.locationCategory);

  // @override
  // void initState() {
  //   Provider.of<TripStepperViewModel>(context, listen: false)
  //       .getLocationRecommend();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final searchStartPointViewModel =
        Provider.of<SearchStartPointViewModel>(context);
    final tripStepperViewModel = Provider.of<TripStepperViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          color: Palette.BackIconColor,
          onPressed: () {
            searchStartPointViewModel.goBack(context);
          },
        ),
        title: Text(
          locationCategory,
          style: FontAssets.headingText,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: tripStepperViewModel.getLocationRecommend(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              var locationList =
                  snapshot.data as List<LocationRecommendResponse>;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(
                      top: getProportionateScreenHeight(20),
                    ),
                    child: OutlinedButton(
                      onPressed: () {},
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: getProportionateScreenHeight(10)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.map_outlined),
                            Text(
                              ' ดูตำแหน่งบนแผนที่',
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
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(15),
                      vertical: getProportionateScreenHeight(10),
                    ),
                    child: Text(
                      'แนะนำจากเส้นทางระหว่างสถานที่',
                      style: FontAssets.bodyText,
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: locationList
                          .map(
                            (location) => InkWell(
                              onTap: () =>
                                  tripStepperViewModel.goToLocationDetail(
                                      context, location.locationId),
                              child: Container(
                                height: getProportionateScreenHeight(110),
                                child: Stack(
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                            left:
                                                getProportionateScreenWidth(15),
                                          ),
                                          child: Center(
                                            child: Container(
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Image(
                                                  width:
                                                      getProportionateScreenHeight(
                                                          100),
                                                  height:
                                                      getProportionateScreenHeight(
                                                          100),
                                                  fit: BoxFit.cover,
                                                  image: NetworkImage(
                                                      location.imageUrl),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.fromLTRB(
                                              getProportionateScreenWidth(10),
                                              getProportionateScreenHeight(5),
                                              getProportionateScreenWidth(15),
                                              getProportionateScreenHeight(5),
                                            ),
                                            child: Container(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    location.locationName,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style:
                                                        FontAssets.subtitleText,
                                                  ),
                                                  // Text(
                                                  //   'เปิดกี่โมง',
                                                  //   overflow: TextOverflow.ellipsis,
                                                  //   maxLines: 2,
                                                  //   style: FontAssets.bodyText,
                                                  // ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        '${location.rating} ',
                                                        style:
                                                            FontAssets.bodyText,
                                                      ),
                                                      RatingBarIndicator(
                                                        unratedColor:
                                                            Palette.Outline,
                                                        rating: location.rating,
                                                        itemBuilder:
                                                            (context, index) =>
                                                                Icon(
                                                          Icons.star_rounded,
                                                          color: Palette
                                                              .CautionColor,
                                                        ),
                                                        itemCount: 5,
                                                        itemSize: 20,
                                                      ),
                                                    ],
                                                  ),
                                                  Spacer(),
                                                  Text(
                                                    '${location.distance} m จากจุดก่อนหน้า',
                                                    style: FontAssets
                                                        .mealsRecommendText,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: ElevatedButton(
                                        onPressed: () => tripStepperViewModel
                                            .selectedLocation(
                                                context, location),
                                        child: Icon(Icons.add,
                                            color: Colors.white),
                                        style: ElevatedButton.styleFrom(
                                            shape: CircleBorder()),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              );
            } else
              return Loading();
          },
        ),
      ),
    );
  }
}
