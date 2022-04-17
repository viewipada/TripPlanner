import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/assets.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/size_config.dart';
import 'package:trip_planner/src/models/response/location_created_response.dart';
import 'package:trip_planner/src/models/response/my_review_response.dart';
import 'package:trip_planner/src/models/trip.dart';
import 'package:trip_planner/src/repository/trips_operations.dart';
import 'package:trip_planner/src/view/widgets/loading.dart';
import 'package:trip_planner/src/view/widgets/tag_category.dart';
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

    final SlidableController slidableController = SlidableController();
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
                                          profileViewModel.profileResponse.rank,
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
                                              'ตั้งค่าความสนใจ',
                                              style: FontAssets.bodyText,
                                            ),
                                            onTap: () {
                                              Navigator.pop(context);
                                              profileViewModel
                                                  .goToSurveyPage(context);
                                            },
                                          ),
                                          ListTile(
                                            title: Text(
                                              'ออกจากระบบ',
                                              style: TextStyle(
                                                  color: Palette.DeleteColor,
                                                  fontSize: 14),
                                            ),
                                            onTap: () => profileViewModel
                                                .logout(context),
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
                                                    return Slidable(
                                                        key: Key(
                                                            '${trip.tripId}'),
                                                        controller:
                                                            slidableController,
                                                        actionPane:
                                                            SlidableDrawerActionPane(),
                                                        actionExtentRatio: 0.25,
                                                        movementDuration:
                                                            Duration(
                                                                milliseconds:
                                                                    500),
                                                        secondaryActions: [
                                                          IconSlideAction(
                                                            caption: 'ลบรายการ',
                                                            color: Palette
                                                                .DeleteColor,
                                                            icon: Icons.delete,
                                                            onTap: () {
                                                              profileViewModel
                                                                  .deleteTrip(
                                                                      trip);
                                                              Slidable.of(
                                                                      context)
                                                                  ?.close();
                                                            },
                                                          )
                                                        ],
                                                        child: buildTripList(
                                                            profileViewModel,
                                                            trip,
                                                            context));
                                                  }).toList(),
                                                )
                                              : Center(
                                                  child: Text(
                                                    'คุณยังไม่เคยสร้างทริป',
                                                    style: FontAssets.bodyText,
                                                  ),
                                                );
                                        } else {
                                          return Column(
                                            children: [
                                              ShimmerTripCard(),
                                              ShimmerTripCard(),
                                              ShimmerTripCard(),
                                            ],
                                          );
                                        }
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
                                    profileViewModel
                                            .profileResponse.reviews.isEmpty
                                        ? Center(
                                            child: Text(
                                              'คุณยังไม่เคยรีวิวสถานที่',
                                              style: FontAssets.bodyText,
                                            ),
                                          )
                                        : ListView(
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            children: profileViewModel
                                                .profileResponse.reviews
                                                .map((review) {
                                              return buildGridReviewPicture(
                                                  context,
                                                  review,
                                                  profileViewModel);
                                            }).toList(),
                                          ),
                                    // SizedBox(height: getProportionateScreenHeight(5)),
                                  ],
                                ),
                              ),
                              FutureBuilder(
                                future: profileViewModel.getLocationRequest(),
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (snapshot.hasData) {
                                    var locationList = snapshot.data
                                        as List<LocationCreatedResponse>;
                                    return locationList.isEmpty
                                        ? createLocationTabEmpty(
                                            context, profileViewModel)
                                        : buildLocationReqList(
                                            context,
                                            profileViewModel,
                                            locationList,
                                            slidableController);
                                  } else {
                                    return Loading();
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return loadingProfileTab();
                }
              },
            ),
          ),
        );
      }),
    );
  }
}

Widget buildLocationReqList(
    BuildContext context,
    ProfileViewModel profileViewModel,
    List<LocationCreatedResponse> locationList,
    slidableController) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.only(
              right: getProportionateScreenWidth(15),
              top: getProportionateScreenHeight(15),
            ),
            child: ElevatedButton.icon(
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
          )
        ],
      ),
      Padding(
        padding: EdgeInsets.only(
            left: getProportionateScreenWidth(15),
            top: getProportionateScreenHeight(10)),
        child: Text(
          'กำลังตรวจสอบ',
          style: FontAssets.titleText,
        ),
      ),
      Column(
          children: locationList
              .where((element) => element.locationStatus == 'In progress')
              .map((location) => buildLocationRequest(
                  profileViewModel, location, context, slidableController))
              .toList()),
      locationList
              .where((element) => element.locationStatus == 'In progress')
              .isEmpty
          ? Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(15)),
              child: Text(
                'ไม่มีรายการ',
                style: FontAssets.bodyText,
              ),
            )
          : SizedBox(),
      Padding(
        padding: EdgeInsets.only(
            left: getProportionateScreenWidth(15),
            top: getProportionateScreenHeight(10)),
        child: Text(
          'ถูกปฏิเสธ',
          style: FontAssets.titleText,
        ),
      ),
      Column(
          children: locationList
              .where((element) => element.locationStatus == 'Deny')
              .map((location) => buildLocationRequest(
                  profileViewModel, location, context, slidableController))
              .toList()),
      locationList.where((element) => element.locationStatus == 'Deny').isEmpty
          ? Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(15)),
              child: Text(
                'ไม่มีรายการ',
                style: FontAssets.bodyText,
              ),
            )
          : SizedBox(),
      Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(15)),
        child: Text(
          'ตรวจสอบแล้ว',
          style: FontAssets.titleText,
        ),
      ),
      Column(
          children: locationList
              .where((element) => element.locationStatus == 'Approved')
              .map((location) => buildLocationRequest(
                  profileViewModel, location, context, slidableController))
              .toList()),
      locationList
              .where((element) => element.locationStatus == 'Approved')
              .isEmpty
          ? Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(15)),
              child: Text(
                'ไม่มีรายการ',
                style: FontAssets.bodyText,
              ),
            )
          : SizedBox(),
    ],
  );
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

Widget buildGridReviewPicture(BuildContext context, MyReviewResponse review,
    ProfileViewModel profileViewModel) {
  _showReviewMenu(BuildContext context, ProfileViewModel profileViewModel,
          int locationId, String locationName) =>
      showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            contentPadding: EdgeInsets.zero,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  selectedTileColor: Palette.SelectedListTileColor,
                  onTap: () {
                    Navigator.pop(context);
                    profileViewModel.goToReviewPage(
                        context, locationId, locationName);
                  },
                  title: Text(
                    'แก้ไขรีวิว',
                    style: FontAssets.bodyText,
                    textAlign: TextAlign.center,
                  ),
                ),
                Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  selectedTileColor: Palette.SelectedListTileColor,
                  onTap: () {
                    profileViewModel.deleteReview(locationId);
                    final snackBar = SnackBar(
                      backgroundColor: Palette.SecondaryColor,
                      content: Container(
                        child: Text(
                          'ลบรีวิว ${locationName}',
                          style: TextStyle(
                            fontFamily: 'Sukhumvit',
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    Navigator.pop(context);
                  },
                  title: Text(
                    'ลบรีวิว',
                    style: FontAssets.bodyText,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  return Container(
    padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(15)),
    margin: EdgeInsets.only(bottom: getProportionateScreenHeight(15)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'รีวิว ${review.locationName}',
              style: TextStyle(
                  color: Palette.BodyText,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
            IconButton(
              onPressed: () => _showReviewMenu(context, profileViewModel,
                  review.locationId, review.locationName),
              icon: Icon(
                Icons.more_horiz_rounded,
                color: Palette.AdditionText,
              ),
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
            ),
          ],
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
        review.caption == ""
            ? SizedBox(
                height: getProportionateScreenHeight(5),
              )
            : Text(
                review.caption,
                style: FontAssets.bodyText,
              ),
        review.images.isNotEmpty
            ? GridView(
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
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
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
              )
            : SizedBox(
                height: getProportionateScreenHeight(5),
              ),
      ],
    ),
  );
}

Widget buildTripList(
    ProfileViewModel profileViewModel, Trip trip, BuildContext context) {
  return InkWell(
    onTap: () => profileViewModel.goToTripDetailPage(context, trip),
    child: Container(
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(15),
      ),
      color: Colors.white,
      height: getProportionateScreenHeight(110),
      child: Stack(
        children: [
          Row(
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
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(
                                bottom: getProportionateScreenHeight(5)),
                            child: Text(
                              trip.tripName,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: FontAssets.subtitleText,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            trip.totalTripItem > 1
                                ? 'จาก ${trip.firstLocation} ไปยัง ${trip.lastLocation}'
                                : 'เริ่มต้นที่ ${trip.firstLocation}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: FontAssets.bodyText,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '${trip.totalTripItem} สถานที่',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: FontAssets.bodyText,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            profileViewModel.showTravelingDay(trip.totalDay),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: FontAssets.bodyText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          trip.status == 'finished'
              ? Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: getProportionateScreenHeight(5)),
                    child: TagCategory(category: 'เสร็จสิ้น'),
                  ),
                )
              : SizedBox(),
        ],
      ),
    ),
  );
}

Widget buildLocationRequest(
    ProfileViewModel profileViewModel,
    LocationCreatedResponse location,
    BuildContext context,
    slidableController) {
  return Slidable(
    key: Key('${location.locationId}'),
    controller: slidableController,
    actionPane: SlidableDrawerActionPane(),
    actionExtentRatio: 0.25,
    movementDuration: Duration(milliseconds: 500),
    secondaryActions: [
      IconSlideAction(
        caption: 'ลบรายการ',
        color: Palette.DeleteColor,
        icon: Icons.delete,
        onTap: () {
          profileViewModel.deleteLocation(location.locationId);
          Slidable.of(context)?.close();
        },
      )
    ],
    child: InkWell(
      onTap: () => location.locationStatus == 'Approved'
          ? profileViewModel.goToLocationDetail(context, location.locationId)
          : profileViewModel.goToEditLocationRequestDetail(
              context, location.locationId),
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(15),
        ),
        height: getProportionateScreenHeight(110),
        child: Stack(
          children: [
            Row(
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  child: location.imageUrl == ""
                      ? Image.asset(ImageAssets.noPreview)
                      : Image.network(
                          location.imageUrl,
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
                              location.locationName,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: FontAssets.subtitleText,
                            ),
                          ),
                          Text(
                            '${location.description}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: FontAssets.bodyText,
                          ),
                          Spacer(),
                          Padding(
                            padding: EdgeInsets.only(
                                bottom: getProportionateScreenHeight(5)),
                            child: TagCategory(
                                category: location.category == 1
                                    ? "ที่เที่ยว"
                                    : location.category == 2
                                        ? "ที่กิน"
                                        : "ที่พัก"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Widget loadingProfileTab() {
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
                    backgroundColor: Palette.AdditionText,
                    radius: 30,
                  ),
                ],
              ),
              IconButton(
                onPressed: () => null,
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
                child: GestureDetector(
                  child: Text('ทริปและรูปภาพ'),
                  onTap: () => null,
                ),
                // text: ,
              ),
              Tab(
                child: GestureDetector(
                  child: Text('สถานที่'),
                  onTap: () => null,
                ),
                // text: ,
              ),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            children: <Widget>[
              SingleChildScrollView(
                padding: EdgeInsets.only(top: getProportionateScreenHeight(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(15),
                        vertical: getProportionateScreenHeight(5),
                      ),
                      child: Text(
                        'ทริปของฉัน',
                        style: FontAssets.titleText,
                      ),
                    ),
                    ShimmerTripCard(),
                    ShimmerTripCard(),
                    ShimmerTripCard(),
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
                    Padding(
                      padding: EdgeInsets.only(
                          left: getProportionateScreenWidth(15)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ShimmerLocationCard(),
                          ShimmerLocationCard(),
                          ShimmerLocationCard(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  SizedBox(
                    height: getProportionateScreenHeight(15),
                  ),
                  ShimmerTripCard(),
                  ShimmerTripCard(),
                  ShimmerTripCard(),
                ],
              )
            ],
          ),
        ),
      ],
    ),
  );
}
