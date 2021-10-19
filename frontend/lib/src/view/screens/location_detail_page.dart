import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/assets.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/size_config.dart';
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
                expandedHeight: getProportionateScreenHeight(200),
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
                        children: [
                          Text(
                            locationDetailViewModel.locationDetail.locationName,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              IconButton(
                                constraints: BoxConstraints(),
                                onPressed: () {
                                  print('นำทางบน google map');
                                },
                                icon: Icon(
                                  Icons.directions_outlined,
                                  size: 23,
                                ),
                                padding: EdgeInsets.zero,
                              ),
                              SizedBox(
                                width: getProportionateScreenWidth(24),
                              ),
                              IconButton(
                                constraints: BoxConstraints(),
                                onPressed: () {
                                  print('เพิ่มลง cart');
                                },
                                icon: ImageIcon(
                                  AssetImage(IconAssets.baggageAdd),
                                  color: Colors.black,
                                ),
                                padding: EdgeInsets.zero,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: getProportionateScreenWidth(15)),
                      child: TagCategory(
                        category:
                            locationDetailViewModel.locationDetail.category,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(
                        getProportionateScreenWidth(15),
                        getProportionateScreenHeight(10),
                        getProportionateScreenWidth(15),
                        getProportionateScreenHeight(5),
                      ),
                      child: Text(
                        locationDetailViewModel.locationDetail.description,
                        style: TextStyle(
                          fontSize: 12,
                          color: Palette.BodyText,
                        ),
                        maxLines: locationDetailViewModel.readMore ? 100 : 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        bottom: getProportionateScreenHeight(5),
                      ),
                      width: double.infinity,
                      height: 20,
                      child: TextButton(
                        onPressed: () {
                          locationDetailViewModel.toggleReadmoreButton();
                        },
                        child: Text(locationDetailViewModel.readMore
                            ? 'ดูน้อยลง'
                            : 'ดูเพิ่มเติม'),
                        style: TextButton.styleFrom(
                          alignment: Alignment.center,
                          padding: EdgeInsets.zero,
                          textStyle: TextStyle(fontSize: 10),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        getProportionateScreenWidth(15),
                        0,
                        getProportionateScreenWidth(15),
                        getProportionateScreenHeight(10),
                      ),
                      child: Text(
                        'รายละเอียด',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Palette.BodyText,
                        ),
                      ),
                    ),
                    detailLocation('วันเวลาเปิด-ปิด',
                        locationDetailViewModel.locationDetail.openingHour),
                    detailLocation('เบอร์ติดต่อ',
                        locationDetailViewModel.locationDetail.contactNumber),
                    detailLocation('เว็บไซต์',
                        locationDetailViewModel.locationDetail.website),
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
                            'ตำแหน่งบนแผนที่',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Palette.BodyText,
                            ),
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
                                  ' เช็คอินแล้ว ${locationDetailViewModel.locationDetail.totalCheckin} คน',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
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
                      color: Colors.amber,
                      width: double.infinity,
                      height: getProportionateScreenHeight(170),
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
                            ' เวลาที่ใช้ ${locationDetailViewModel.locationDetail.duration}hr',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
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
                                'รีวิว (${locationDetailViewModel.locationDetail.totalReview})',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                print('ดู review เพิ่มเติม');
                              },
                              child: Container(
                                child: Text(
                                  "ดูเพิ่มเติม >> ",
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    color: Palette.AdditionText,
                                    fontSize: 12,
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
                            style: TextStyle(
                              fontSize: 12,
                              color: Palette.AdditionText,
                            ),
                          ),
                          RatingBarIndicator(
                            rating: locationDetailViewModel
                                .locationDetail.averageRating,
                            itemBuilder: (context, index) => Icon(
                              Icons.star_rounded,
                              color: Palette.CautionColor,
                            ),
                            itemCount: 5,
                            itemSize: 18,
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
                        getProportionateScreenHeight(5),
                      ),
                      child: OutlinedButton(
                        onPressed: () {
                          print('เพิ่มรีวิวของคุณ');
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.send_rounded,
                            ),
                            Text(
                              ' เพิ่มรีวิวของคุณ',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        style: OutlinedButton.styleFrom(
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
      children: [
        Expanded(
          flex: 1,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Palette.BodyText,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            detail,
            style: TextStyle(
              fontSize: 12,
              color: Palette.AdditionText,
            ),
          ),
        ),
      ],
    ),
  );
}