import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/assets.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/size_config.dart';
import 'package:trip_planner/src/view_models/survey_view_model.dart';

class SurvayPage extends StatefulWidget {
  @override
  _SurvayPageState createState() => _SurvayPageState();
}

class _SurvayPageState extends State<SurvayPage> {
  bool isLoading = false;
  bool hasData = false;
  bool loadingData = true;

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
    final surveyViewModel = Provider.of<SurveyViewModel>(context);

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
                        '${surveyViewModel.selectedActivities.length}/3',
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
                    crossAxisCount: 3,
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 0,
                    // ),
                    children: surveyViewModel.activities.map((image) {
                      return InkWell(
                        onTap: () => surveyViewModel.selectedActivities.length <
                                3
                            ? surveyViewModel.selectActivity(image['value'])
                            : surveyViewModel.selectedActivities
                                    .contains(image['value'])
                                ? surveyViewModel.selectActivity(image['value'])
                                : alertDialog(
                                    context, "เลือกได้สูงสุด 3 อย่าง"),
                        child: Stack(
                          children: [
                            Card(
                              color: Colors.black,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              child: Opacity(
                                opacity: surveyViewModel.selectedActivities
                                        .contains(image['value'])
                                    ? 0.4
                                    : 1,
                                child: Image.asset(
                                  image["imageUrl"],
                                  height: SizeConfig.screenWidth / 3,
                                  width: SizeConfig.screenWidth / 3,
                                  fit: BoxFit.cover,
                                ),
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
                            Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: getProportionateScreenHeight(10),
                                  horizontal: getProportionateScreenWidth(10),
                                ),
                                child: surveyViewModel.selectedActivities
                                        .contains(image['value'])
                                    ? Icon(
                                        Icons.check_circle,
                                        color: Palette.PrimaryColor,
                                      )
                                    : Icon(
                                        Icons.circle,
                                        color: Palette.BorderInputColor,
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
                        '${surveyViewModel.selectedRestaurant.length}/3',
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
                    children: surveyViewModel.restaurant
                        .map(
                          (place) => ListTile(
                            title: Text(
                              place,
                              style: FontAssets.bodyText,
                            ),
                            trailing: surveyViewModel.selectedRestaurant
                                    .contains(place)
                                ? Icon(
                                    Icons.check_circle,
                                    color: Palette.PrimaryColor,
                                  )
                                : Icon(
                                    Icons.circle_outlined,
                                    color: Palette.InfoText,
                                  ),
                            onTap: () =>
                                surveyViewModel.selectedRestaurant.length < 3
                                    ? surveyViewModel.selectRestaurant(place)
                                    : surveyViewModel.selectedRestaurant
                                            .contains(place)
                                        ? surveyViewModel
                                            .selectRestaurant(place)
                                        : alertDialog(
                                            context, "เลือกได้สูงสุด 3 อย่าง"),
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
                        '${surveyViewModel.selectedHotel.length}/3',
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
                    children: surveyViewModel.hotel
                        .map(
                          (place) => ListTile(
                            title: Text(
                              place,
                              style: FontAssets.bodyText,
                            ),
                            trailing:
                                surveyViewModel.selectedHotel.contains(place)
                                    ? Icon(
                                        Icons.check_circle,
                                        color: Palette.PrimaryColor,
                                      )
                                    : Icon(
                                        Icons.circle_outlined,
                                        color: Palette.InfoText,
                                      ),
                            onTap: () => surveyViewModel.selectedHotel.length <
                                    3
                                ? surveyViewModel.selectHotel(place)
                                : surveyViewModel.selectedHotel.contains(place)
                                    ? surveyViewModel.selectHotel(place)
                                    : alertDialog(
                                        context, "เลือกได้สูงสุด 3 อย่าง"),
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: getProportionateScreenWidth(15),
                    ),
                    Expanded(
                      child: TextField(
                        maxLines: 1,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(hintText: "ต่ำสุด"),
                        onChanged: (value) =>
                            surveyViewModel.updateMinPrice(value.trim()),
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
                      child: TextField(
                        maxLines: 1,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(hintText: "สูงสุด"),
                        onChanged: (value) =>
                            surveyViewModel.updateMaxPrice(value.trim()),
                      ),
                    ),
                    SizedBox(
                      width: getProportionateScreenWidth(15),
                    ),
                  ],
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
                      if (surveyViewModel.selectedActivities.isEmpty) {
                        alertDialog(context,
                            'กรุณาเลือกกิจกรรมที่อยากทำ\nอย่างน้อย 1 อย่าง');
                      } else if (surveyViewModel.selectedRestaurant.isEmpty) {
                        alertDialog(
                            context, 'กรุณาเลือกร้านอาหาร\nอย่างน้อย 1 อย่าง');
                      } else if (surveyViewModel.selectedHotel.isEmpty) {
                        alertDialog(
                            context, 'กรุณาเลือกที่พัก\nอย่างน้อย 1 อย่าง');
                      } else {
                        //post api
                        print(surveyViewModel.minPrice);
                        print(surveyViewModel.maxPrice);
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
