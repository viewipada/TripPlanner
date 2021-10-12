import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/assets.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/size_config.dart';
import 'package:trip_planner/src/view/screens/baggage_page.dart';
import 'package:trip_planner/src/view/widgets/tag_category.dart';

class LocationDetailPage extends StatefulWidget {
  @override
  _LocationDetailPageState createState() => _LocationDetailPageState();
}

class _LocationDetailPageState extends State<LocationDetailPage> {
  @override
  void initState() {
    // Provider.of<HomeViewModel>(context, listen: false).getHotLocationList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: getProportionateScreenHeight(200),
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                'https://s.isanook.com/tr/0/ui/283/1415945/4818d35d2f9cc6f942b4195377b4bb87_1560943626.jpg',
                fit: BoxFit.cover,
              ),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_rounded),
              color: Palette.BackIconColor,
              onPressed: () {},
            ),
            actions: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                  0,
                  getProportionateScreenHeight(5),
                  getProportionateScreenWidth(15),
                  getProportionateScreenHeight(5),
                ),
                child: CircleAvatar(
                  backgroundColor: Palette.SecondaryColor,
                  radius: 20,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(Icons.shopping_bag_outlined),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BaggagePage()),
                      );
                    },
                  ),
                ),
              ),
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
                        'บ้านหุ่นเหล็ก',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        constraints: BoxConstraints(),
                        onPressed: () {},
                        icon: Icon(Icons.directions_outlined),
                        padding: EdgeInsets.zero,
                      )
                    ],
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(left: getProportionateScreenWidth(15)),
                  child: TagCategory(
                    category: 'ที่เที่ยว',
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(
                    getProportionateScreenWidth(15),
                    getProportionateScreenHeight(10),
                    getProportionateScreenWidth(15),
                    getProportionateScreenHeight(10),
                  ),
                  child: Text(
                    'getProportionateScreenHeight(10)getProportionateScreenHeight(10)getProportionateScreenHeight(10)getProportionateScreenHeight(10)getProportionateScreenHeight(10)getProportionateScreenHeight(10)getProportionateScreenHeight(10)getProportionateScreenHeight(10)getProportionateScreenHeight(10)getProportionateScreenHeight(10)getProportionateScreenHeight(10)getProportionateScreenHeight(10)getProportionateScreenHeight(10)',
                    style: TextStyle(
                      fontSize: 12,
                      color: Palette.BodyText,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    bottom: getProportionateScreenHeight(10),
                  ),
                  width: double.infinity,
                  height: 20,
                  child: TextButton(
                    onPressed: () {},
                    child: Text('ดูเพิ่มเติม'),
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
                detailLocation(
                    'วันเวลาเปิด-ปิด', 'เปิดทุกวัน เวลา 8.00 - 19.00 น.'),
                detailLocation('เบอร์ติดต่อ', '081 234 5678'),
                detailLocation('เว็บไซต์', 'http://www.BanHunLek.com/'),
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
                              ' เช็คอินแล้ว 45 คน',
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
                  height: getProportionateScreenHeight(180),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(
                    getProportionateScreenWidth(15),
                    getProportionateScreenHeight(10),
                    getProportionateScreenWidth(15),
                    getProportionateScreenHeight(10),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.hourglass_empty_rounded,
                        color: Palette.SecondaryColor,
                        size: 18,
                      ),
                      Text(
                        ' เวลาที่ใช้ 1hr',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider()
              ],
            ),
          ),
        ],
      ),
    );
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
