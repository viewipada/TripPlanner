import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/assets.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/size_config.dart';
import 'package:trip_planner/src/view/widgets/baggage_cart.dart';
import 'package:trip_planner/src/view_models/search_view_model.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // @override
  // void initState() {
  //   Provider.of<SearchViewModel>(context, listen: false).getUserLocation();
  //   super.initState();
  // }
  final tripList = [
    {
      "tripId": 1,
      "tripName": "วัดม่วง",
      "imageUrl":
          "https://cms.dmpcdn.com/travel/2020/05/26/fafac540-9f50-11ea-81a6-432b2bbc8436_original.jpg",
      "startedPoint": "บ้าน",
      "endedPoint": "วัดม่วง",
      "sumOfLocation": 15,
      "travelingDay": 3
    },
    {
      "tripId": 2,
      "tripName": "บ้านหุ่นเหล็ก",
      "imageUrl":
          "https://storage.googleapis.com/swapgap-bucket/post/5190314163699712-babbd605-e3ed-407f-bdc8-dba57e81c76e",
      "startedPoint": "บ้านพ่อ",
      "endedPoint": "วัดหุ่นเหล็ก",
      "sumOfLocation": 5,
      "travelingDay": 2
    },
    {
      "tripId": 3,
      "tripName": "วัดขุนอินทประมูล",
      "imageUrl":
          "https://tiewpakklang.com/wp-content/uploads/2018/09/33716.jpg",
      "startedPoint": "บ้านแม่",
      "endedPoint": "สนามบินสุวรรณภูเก็ต",
      "sumOfLocation": 15,
      "travelingDay": 3
    }
  ];

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    // final searchViewModel = Provider.of<SearchViewModel>(context);
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
            child: Container(
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
                                  'https://picsum.photos/id/237/200/300'),
                              radius: 30,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: getProportionateScreenWidth(15)),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'มุก วิภา',
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
                          onPressed: () {},
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
                    margin: EdgeInsets.only(
                        bottom: getProportionateScreenHeight(10)),
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
                              ListView(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                children: tripList.map((trip) {
                                  return InkWell(
                                    onTap: () {
                                      print('click on trip ');
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal:
                                            getProportionateScreenWidth(15),
                                      ),
                                      height: getProportionateScreenHeight(110),
                                      child: Row(
                                        children: [
                                          Card(
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10.0))),
                                            child: Image.network(
                                              'https://cms.dmpcdn.com/travel/2020/05/26/fafac540-9f50-11ea-81a6-432b2bbc8436_original.jpg',
                                              fit: BoxFit.cover,
                                              height:
                                                  getProportionateScreenHeight(
                                                      100),
                                              width:
                                                  getProportionateScreenHeight(
                                                      100),
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
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          bottom:
                                                              getProportionateScreenHeight(
                                                                  5)),
                                                      child: Text(
                                                        'อ่างทองไม่เหงา มีเรา 3 คน',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                        style: FontAssets
                                                            .subtitleText,
                                                      ),
                                                    ),
                                                    Text(
                                                      'จาก นี่ ไปยัง นั่น',
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style:
                                                          FontAssets.bodyText,
                                                    ),
                                                    Text(
                                                      '10 ที่เที่ยว',
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style:
                                                          FontAssets.bodyText,
                                                    ),
                                                    Text(
                                                      '2 วัน 1 คืน',
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style:
                                                          FontAssets.bodyText,
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
                              buildGridReviewPicture(),
                              buildGridReviewPicture(),
                              buildGridReviewPicture(),
                              SizedBox(height: getProportionateScreenHeight(5)),
                            ],
                          ),
                        ),
                        createLocationTabEmpty(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

Widget createLocationTabEmpty() {
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
        onPressed: () {},
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

Widget buildGridReviewPicture() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(15)),
    margin: EdgeInsets.only(bottom: getProportionateScreenHeight(10)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'รีวิว วัดม่วง',
          style: TextStyle(
              color: Palette.BodyText,
              fontSize: 14,
              fontWeight: FontWeight.bold),
        ),
        Text(
          'บรรยากาศดีมากๆๆๆค่ะ ต้องมาอีกให้ดั้ยยย',
          style: FontAssets.bodyText,
        ),
        GridView(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: getProportionateScreenWidth(10),
          ),
          children: [
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              child: Image.asset(
                ImageAssets.homeBanner,
                height: getProportionateScreenHeight(100),
                width: getProportionateScreenHeight(100),
                fit: BoxFit.cover,
              ),
              clipBehavior: Clip.antiAlias,
            ),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              child: Image.asset(
                ImageAssets.homeBanner,
                height: getProportionateScreenHeight(100),
                width: getProportionateScreenHeight(100),
                fit: BoxFit.cover,
              ),
              clipBehavior: Clip.antiAlias,
            ),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              child: Image.asset(
                ImageAssets.homeBanner,
                height: getProportionateScreenHeight(100),
                width: getProportionateScreenHeight(100),
                fit: BoxFit.cover,
              ),
              clipBehavior: Clip.antiAlias,
            ),
          ],
        ),
      ],
    ),
  );
}
