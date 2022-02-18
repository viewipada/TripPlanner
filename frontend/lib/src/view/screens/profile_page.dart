import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/assets.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/size_config.dart';
import 'package:trip_planner/src/models/response/my_review_response.dart';
import 'package:trip_planner/src/models/response/trip_card_response.dart';
import 'package:trip_planner/src/models/trip.dart';
import 'package:trip_planner/src/models/trip_item.dart';
import 'package:trip_planner/src/repository/trip_item_operations.dart';
import 'package:trip_planner/src/repository/trips_operations.dart';
import 'package:trip_planner/src/view/screens/home_page.dart';
import 'package:trip_planner/src/view/widgets/loading.dart';
import 'package:trip_planner/src/view_models/profile_view_model.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TripsOperations tripsOperations = TripsOperations();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final profileViewModel = Provider.of<ProfileViewModel>(context);
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Builder(builder: (context) {
        final tabController = DefaultTabController.of(context)!;
        // tabController.addListener(() => searchViewModel.getSearchResultBy(
        //     searchViewModel.tabs[tabController.index]['value'],
        //     searchViewModel.dropdownItemList[0]['value']));

        return Scaffold(
          body: SafeArea(
            child: FutureBuilder(
              future: Provider.of<ProfileViewModel>(context, listen: false)
                  .getMyProfile(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            vertical: getProportionateScreenHeight(20),
                            horizontal: getProportionateScreenWidth(15),
                          ),
                          color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        profileViewModel
                                            .profileResponse.userImage),
                                    radius: 30,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: getProportionateScreenWidth(15)),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          profileViewModel
                                              .profileResponse.username,
                                          style: FontAssets.titleText,
                                        ),
                                        Text(
                                          'Sliver traveller',
                                          style: FontAssets.bodyText,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              IconButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20),
                                      ),
                                    ),
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Center(
                                            child: Container(
                                              margin: EdgeInsets.symmetric(
                                                vertical:
                                                    getProportionateScreenHeight(
                                                        15),
                                              ),
                                              height:
                                                  getProportionateScreenHeight(
                                                      5),
                                              width:
                                                  getProportionateScreenWidth(
                                                      50),
                                              decoration: BoxDecoration(
                                                color: Palette.Outline,
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                              ),
                                            ),
                                          ),
                                          ListTile(
                                            title: Text(
                                              'แก้ไขข้อมูลส่วนตัว',
                                              style: FontAssets.bodyText,
                                            ),
                                            onTap: () {
                                              Navigator.pop(context);
                                              profileViewModel
                                                  .goToEditProfile(context);
                                            },
                                          ),
                                          ListTile(
                                            title: Text(
                                              'ตั้งเวลาที่ใช้ในสถานที่',
                                              style: FontAssets.bodyText,
                                            ),
                                            onTap: () {},
                                          ),
                                          ListTile(
                                            title: Text(
                                              'ตั้งค่าความสนใจ',
                                              style: FontAssets.bodyText,
                                            ),
                                            onTap: () {},
                                          ),
                                          ListTile(
                                            title: Text(
                                              'ออกจากระบบ',
                                              style: TextStyle(
                                                  color: Palette.DeleteColor,
                                                  fontSize: 14),
                                            ),
                                            onTap: () {},
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: Icon(Icons.menu_rounded),
                                color: Palette.AdditionText,
                                iconSize: 30,
                                padding: EdgeInsets.zero,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          child: TabBar(
                            labelColor: Palette.BodyText,
                            indicatorColor: Palette.SecondaryColor,
                            labelStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Sukhumvit',
                            ),
                            unselectedLabelStyle: TextStyle(
                              fontSize: 16,
                              color: Palette.AdditionText,
                              fontFamily: 'Sukhumvit',
                            ),
                            tabs: [
                              Tab(
                                text: 'ทริปและรูปภาพ',
                              ),
                              Tab(
                                text: 'สถานที่',
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: TabBarView(
                            children: <Widget>[
                              SingleChildScrollView(
                                padding: EdgeInsets.only(
                                    top: getProportionateScreenHeight(10)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal:
                                            getProportionateScreenWidth(15),
                                        vertical:
                                            getProportionateScreenHeight(5),
                                      ),
                                      child: Text(
                                        'ทริปของฉัน',
                                        style: FontAssets.titleText,
                                      ),
                                    ),
                                    FutureBuilder(
                                      future: tripsOperations.getAllTrips(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          var data =
                                              snapshot.data as List<Trip>;
                                          return data.isNotEmpty
                                              ? ListView(
                                                  shrinkWrap: true,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  children: data.map((trip) {
                                                    return buildTripList(
                                                        profileViewModel,
                                                        trip,
                                                        context);
                                                  }).toList(),
                                                )
                                              : Center(
                                                  child: Text(
                                                      'คุณยังไม่เคยสร้างทริป'),
                                                );
                                        } else {
                                          return loadingTripCard('');
                                        }
                                        // if (snapshot.hasError) print('error');
                                        // var data = snapshot.data;
                                        // print(data);
                                        // return snapshot.hasData
                                        //     ? ListView(
                                        //         shrinkWrap: true,
                                        //         physics:
                                        //             NeverScrollableScrollPhysics(),
                                        //         children: (data as List<Trip>)
                                        //             .map((trip) {
                                        //           return buildTripList(
                                        //               profileViewModel, trip);
                                        //         }).toList(),
                                        //       )
                                        //     : Center(
                                        //         child: Text(
                                        //             'คุณยังไม่เคยสร้างทริป'),
                                        //       );
                                      },
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(
                                        getProportionateScreenWidth(15),
                                        getProportionateScreenHeight(15),
                                        getProportionateScreenWidth(15),
                                        getProportionateScreenHeight(5),
                                      ),
                                      child: Text(
                                        'รูปภาพ',
                                        style: FontAssets.titleText,
                                      ),
                                    ),
                                    profileViewModel.profileResponse.reviews ==
                                            []
                                        ? Center(
                                            child: Text(
                                                'คุณยังไม่เคยรีวิวสถานที่'),
                                          )
                                        : ListView(
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            children: profileViewModel
                                                .profileResponse.reviews
                                                .map((review) {
                                              return buildGridReviewPicture(
                                                  context, review);
                                            }).toList(),
                                          ),
                                    // SizedBox(height: getProportionateScreenHeight(5)),
                                  ],
                                ),
                              ),
                              createLocationTabEmpty(context, profileViewModel),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Loading();
                }
              },
            ),
          ),
        );
      }),
    );
  }
}

Widget createLocationTabEmpty(context, ProfileViewModel profileViewModel) {
  return Column(
    children: [
      Padding(
        padding: EdgeInsets.only(
          top: getProportionateScreenHeight(15),
          bottom: getProportionateScreenHeight(10),
        ),
        child: Text(
          'คุณยังไม่เคยสร้างสถานที่\nมาช่วยเพิ่มสถานที่กันเถอะ',
          style: FontAssets.bodyText,
          textAlign: TextAlign.center,
        ),
      ),
      ElevatedButton.icon(
        onPressed: () => profileViewModel.goToCreateLocationPage(context),
        icon: Icon(
          Icons.add,
          color: Colors.white,
          size: 20,
        ),
        label: Text(
          'สร้างสถานที่',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        style: ElevatedButton.styleFrom(
          primary: Palette.SecondaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
      ),
    ],
  );
}

Widget buildGridReviewPicture(BuildContext context, MyReviewResponse review) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(15)),
    margin: EdgeInsets.only(bottom: getProportionateScreenHeight(15)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'รีวิว ${review.locationName}',
          style: TextStyle(
              color: Palette.BodyText,
              fontSize: 14,
              fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            Text(
              '${review.rating} ',
              style: FontAssets.bodyText,
            ),
            RatingBarIndicator(
              unratedColor: Palette.Outline,
              rating: review.rating,
              itemBuilder: (context, index) => Icon(
                Icons.star_rounded,
                color: Palette.CautionColor,
              ),
              itemCount: 5,
              itemSize: 20,
            ),
          ],
        ),
        Text(
          review.caption,
          style: FontAssets.bodyText,
        ),
        Visibility(
          visible: review.images.isNotEmpty,
          child: GridView(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: getProportionateScreenWidth(10),
            ),
            children: review.images.map((image) {
              return GestureDetector(
                onLongPress: () => showDialog(
                  context: context,
                  builder: (_) => Dialog(
                    backgroundColor: Colors.transparent,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  child: Image.network(
                    image,
                    height: getProportionateScreenHeight(100),
                    width: getProportionateScreenHeight(100),
                    fit: BoxFit.cover,
                  ),
                  clipBehavior: Clip.antiAlias,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    ),
  );
}

Widget buildTripList(
    ProfileViewModel profileViewModel, Trip trip, BuildContext context) {
  TripItemOperations tripItemOperations = TripItemOperations();
  return InkWell(
    onTap: () {
      print('click on trip ${trip.tripId}');
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Container(
                  child: FutureBuilder(
                    future: tripItemOperations.getAllTripItemsByTripId(trip),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var data = snapshot.data as List<TripItem>;
                        return data.isNotEmpty
                            ? ListView(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                children: data.map((item) {
                                  return Text(item.locationName);
                                }).toList(),
                              )
                            : Center(
                                child: Text('คุณยังไม่เคยสร้างทริป'),
                              );
                      } else {
                        return Loading();
                      }
                    },
                  ),
                )),
      );
      // print(tripItemOperations.getAllTripItemsByTripId(trip));
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
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            child: trip.trumbnail == null
                ? Image.asset(ImageAssets.noPreview)
                : Image.network(
                    trip.trumbnail!,
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
                          bottom: getProportionateScreenHeight(5)),
                      child: Text(
                        trip.tripName,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: FontAssets.subtitleText,
                      ),
                    ),
                    Text(
                      'จาก ${trip.firstLocation} ไปยัง ${trip.lastLocation}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: FontAssets.bodyText,
                    ),
                    Text(
                      '${trip.totalTripItem} ที่เที่ยว',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: FontAssets.bodyText,
                    ),
                    Text(
                      profileViewModel.showTravelingDay(trip.totalDay),
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
}
