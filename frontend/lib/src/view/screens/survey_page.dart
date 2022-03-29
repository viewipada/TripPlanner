import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/assets.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/size_config.dart';
import 'package:trip_planner/src/view_models/review_view_model.dart';

class SurvayPage extends StatefulWidget {
  @override
  _SurvayPageState createState() => _SurvayPageState();
}

class _SurvayPageState extends State<SurvayPage> {
  bool isLoading = false;
  bool hasData = false;
  bool loadingData = true;
  List _images = [
    {
      "imageUrl": ImageAssets.Act1,
      "label": "บันจี้จัมป์",
    },
    {
      "imageUrl": ImageAssets.Act2,
      "label": "เต้นรำ",
    },
    {
      "imageUrl": ImageAssets.Act3,
      "label": "ปีนเขา",
    },
    {
      "imageUrl": ImageAssets.Act4,
      "label": "พายเรือล่องแก่ง",
    },
    {
      "imageUrl": ImageAssets.Act5,
      "label": "ดูพระอาทิตย์ขึ้น-ตก",
    },
    {
      "imageUrl": ImageAssets.Act6,
      "label": "ดูทะเลหมอก",
    },
    {
      "imageUrl": ImageAssets.Act7,
      "label": "ล่องเรือ",
    },
    {
      "imageUrl": ImageAssets.Act8,
      "label": "ถ่ายภาพสถานที่",
    },
    {
      "imageUrl": ImageAssets.Act9,
      "label": "ดูงานศิลปะ",
    },
    {
      "imageUrl": ImageAssets.Act10,
      "label": "ดูสวนดอกไม้",
    },
    {
      "imageUrl": ImageAssets.Act11,
      "label": "สำรวจประวัติศาสตร์",
    },
    {
      "imageUrl": ImageAssets.Act12,
      "label": "เที่ยวเมืองจำลอง", //สถานที่ท่องเที่ยวบรรยากาศต่างประเทศ
    },
  ];

  List<String> restaurant = [
    "อาหารเส้น",
    "ร้านอาหาร/ภัตตาคาร",
    "สตรีทฟู้ด",
    "ปิ้งย่าง/บุฟเฟ่ต์",
    "เบเกอรี่",
    "คาเฟ่"
  ];
  List<String> hotel = [
    "รีสอร์ท",
    "แคมป์",
    "โรงแรม",
    "บังกะโล/บ้านพัก",
    "โฮมสเตย์/เกสเฮาส์"
  ];

  @override
  void initState() {
    super.initState();
    // Provider.of<ProfileViewModel>(context, listen: false)
    //     .getSurvayData()
    //     .then((value) {
    //   setState(() {
    //     loadingData = false;
    //     hasData = value != null;
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final survayViewModel = Provider.of<ReviewViewModel>(context);
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      body: SafeArea(
        child:
            // child:
            // loadingData
            //     ? Loading()
            //     :
            SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Container(
            // height: SizeConfig.screenHeight -
            //     AppBar().preferredSize.height -
            //     MediaQuery.of(context).padding.bottom -
            //     MediaQuery.of(context).padding.top,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: getProportionateScreenWidth(25),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(15),
                    // vertical: getProportionateScreenHeight(15),
                  ),
                  child: Text(
                    'ตั้งค่าความสนใจ',
                    style: FontAssets.titleText,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: getProportionateScreenHeight(5),
                    bottom: getProportionateScreenHeight(15),
                  ),
                  child: Center(
                    child: Text(
                      'เราจะแนะนำสถานที่เที่ยวให้เหมาะสมกับการตั้งค่าที่คุณเลือก',
                      style: FontAssets.bodyText,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.bottomLeft,
                  padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(15),
                  ),
                  margin:
                      EdgeInsets.only(bottom: getProportionateScreenHeight(5)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'กิจกรรมที่อยากทำ',
                        style: FontAssets.subtitleText,
                      ),
                      Text(
                        '0/3',
                        style: FontAssets.bodyText,
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(15)),
                  child: GridView.count(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    // child: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 0,
                    // ),
                    children: _images.map((image) {
                      return Container(
                        // color: Colors.green,
                        // height: SizeConfig.screenWidth / 2,
                        child: Stack(
                          // mainAxisSize: MainAxisSize.min,
                          children: [
                            Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              child: Image.asset(
                                image["imageUrl"],
                                height: SizeConfig.screenWidth / 3,
                                width: SizeConfig.screenWidth / 3,
                                fit: BoxFit.cover,
                              ),
                              clipBehavior: Clip.antiAlias,
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: getProportionateScreenHeight(8),
                                  horizontal: getProportionateScreenWidth(10),
                                ),
                                child: Text(
                                  image["label"],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Container(
                  alignment: Alignment.bottomLeft,
                  padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(15),
                    vertical: getProportionateScreenHeight(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'ร้านอาหาร',
                        style: FontAssets.subtitleText,
                      ),
                      Text(
                        '0/3',
                        style: FontAssets.bodyText,
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(15),
                  ),
                  child: ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: restaurant
                        .map(
                          (place) => ListTile(
                            title: Text(
                              place,
                              style: FontAssets.bodyText,
                            ),
                            trailing: Icon(
                              Icons.circle_outlined,
                              color: Palette.InfoText,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                Container(
                  alignment: Alignment.bottomLeft,
                  padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(15),
                    vertical: getProportionateScreenHeight(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'ที่พัก',
                        style: FontAssets.subtitleText,
                      ),
                      Text(
                        '0/3',
                        style: FontAssets.bodyText,
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(15),
                  ),
                  child: ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: hotel
                        .map(
                          (place) => ListTile(
                            title: Text(
                              place,
                              style: FontAssets.bodyText,
                            ),
                            trailing: Icon(
                              Icons.circle_outlined,
                              color: Palette.InfoText,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                Container(
                  alignment: Alignment.bottomLeft,
                  padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(15),
                    vertical: getProportionateScreenHeight(15),
                  ),
                  child: Text(
                    'ราคาห้องพักที่พอใจ',
                    style: FontAssets.subtitleText,
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: getProportionateScreenWidth(15),
                      ),
                      Expanded(
                        child: TextFormField(
                          maxLines: 1,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'โปรดระบุ';
                            }
                            return null;
                          },
                          decoration: InputDecoration(hintText: "ต่ำสุด"),
                          // onChanged: (value) => createLocationViewModel
                          //     .updateMinPrice(value.trim()),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenWidth(5),
                        ),
                        child: Icon(
                          Icons.minimize_rounded,
                          color: Palette.InfoText,
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          maxLines: 1,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'โปรดระบุ';
                            }
                            return null;
                          },
                          decoration: InputDecoration(hintText: "สูงสุด"),
                          // onChanged: (value) => createLocationViewModel
                          //     .updateMaxPrice(value.trim()),
                        ),
                      ),
                      SizedBox(
                        width: getProportionateScreenWidth(15),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: getProportionateScreenHeight(48),
                  margin: EdgeInsets.symmetric(
                    vertical: getProportionateScreenHeight(15),
                    horizontal: getProportionateScreenWidth(15),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        //post api
                      } else {
                        alertDialog(context, 'กรุณาระบุราคาห้องพักที่พอใจ');
                      }
                    },
                    child: Text(
                      'บันทึก',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Palette.PrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
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
        style: TextStyle(
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
            'โอเค!',
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
