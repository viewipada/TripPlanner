import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/assets.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/size_config.dart';
import 'package:trip_planner/src/models/response/trip_card_response.dart';
import 'package:trip_planner/src/view_models/home_view_model.dart';

class TripCard extends StatelessWidget {
  TripCard({
    required this.header,
    required this.tripList,
  });

  final String header;
  final List<TripCardResponse> tripList;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final homeViewModel = Provider.of<HomeViewModel>(context);

    return Container(
      // color: Colors.amber,
      padding: EdgeInsets.symmetric(
        vertical: getProportionateScreenHeight(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(15),
            ),
            child: Text(
              this.header,
              textAlign: TextAlign.start,
              style: FontAssets.titleText,
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: getProportionateScreenHeight(5)),
            child: ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: tripList.map((trip) {
                return InkWell(
                  onTap: () {
                    homeViewModel.goToOtherTripPage(context, trip.tripId);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(15),
                    ),
                    height: getProportionateScreenHeight(110),
                    child: Row(
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          child: Image.network(
                            trip.imageUrl,
                            fit: BoxFit.cover,
                            height: getProportionateScreenHeight(100),
                            width: getProportionateScreenHeight(100),
                          ),
                          clipBehavior: Clip.antiAlias,
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                              getProportionateScreenWidth(10),
                              getProportionateScreenHeight(5),
                              0,
                              getProportionateScreenHeight(5),
                            ),
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(
                                        bottom:
                                            getProportionateScreenHeight(5)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            trip.tripName,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: FontAssets.subtitleText,
                                          ),
                                        ),
                                        // IconButton(
                                        //   constraints: BoxConstraints(),
                                        //   padding: EdgeInsets.zero,
                                        //   icon: ImageIcon(
                                        //     AssetImage(IconAssets.copyToEdit),
                                        //   ),
                                        //   color: Palette.DarkGrey,
                                        //   onPressed: () {},
                                        // ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    'จาก ${trip.startedPoint} ไปยัง ${trip.endedPoint}',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: FontAssets.bodyText,
                                  ),
                                  Text(
                                    trip.sumOfLocation.toString() + ' สถานที่',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: FontAssets.bodyText,
                                  ),
                                  Text(
                                    homeViewModel
                                        .showTravelingDay(trip.travelingDay),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: FontAssets.bodyText,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
