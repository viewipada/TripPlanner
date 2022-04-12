import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/assets.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/size_config.dart';
import 'package:trip_planner/src/view/widgets/loading.dart';
import 'package:trip_planner/src/view/widgets/review_card.dart';
import 'package:trip_planner/src/view_models/location_detail_view_model.dart';

class LocationDetailReviewsPage extends StatefulWidget {
  LocationDetailReviewsPage({
    required this.locationId,
    required this.locationName,
    required this.totalReview,
    required this.avgRating,
  });

  final int locationId;
  final String locationName;
  final int totalReview;
  final double avgRating;

  @override
  _LocationDetailReviewsPageState createState() =>
      _LocationDetailReviewsPageState(this.locationId);
}

class _LocationDetailReviewsPageState extends State<LocationDetailReviewsPage> {
  final int _locationId;
  _LocationDetailReviewsPageState(this._locationId);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final locationDetailViewModel =
        Provider.of<LocationDetailViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          color: Palette.BackIconColor,
          onPressed: () {
            locationDetailViewModel.goBack(context);
          },
        ),
        title: Text(
          "รีวิว",
          style: FontAssets.headingText,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder(
        future: Provider.of<LocationDetailViewModel>(context, listen: false)
            .getReviewsByLocationId(this._locationId),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: getProportionateScreenHeight(15),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(15)),
                    child: Text(
                      'รีวิว (${widget.locationName})',
                      textAlign: TextAlign.start,
                      style: FontAssets.subtitleText,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(
                      getProportionateScreenWidth(15),
                      getProportionateScreenHeight(5),
                      getProportionateScreenWidth(15),
                      getProportionateScreenHeight(5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'ทั้งหมด (${widget.totalReview})',
                          textAlign: TextAlign.start,
                          style: FontAssets.subtitleText,
                        ),
                        Row(
                          children: [
                            Text(
                              '${locationDetailViewModel.locationDetail.averageRating} ',
                              style: FontAssets.bodyText,
                            ),
                            RatingBarIndicator(
                              unratedColor: Palette.Outline,
                              rating: locationDetailViewModel
                                  .locationDetail.averageRating
                                  .toDouble(),
                              itemBuilder: (context, index) => Icon(
                                Icons.star_rounded,
                                color: Palette.CautionColor,
                              ),
                              itemCount: 5,
                              itemSize: 20,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ReviewCard(
                    reviews: snapshot.data,
                  ),
                ],
              ),
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
      ),
    );
  }
}
