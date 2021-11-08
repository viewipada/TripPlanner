import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/size_config.dart';
import 'package:trip_planner/src/view/widgets/baggage_cart.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final isSelected = <bool>[false, false, false];

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    // final homeViewModel = Provider.of<HomeViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "สำรวจ",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          BaggageCart(),
        ],
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(15),
            vertical: getProportionateScreenHeight(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: getProportionateScreenHeight(5),
                ),
                child: Text(
                  'หาอะไรทำรอบตัวคุณ',
                  style: TextStyle(
                    color: Palette.BodyText,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              Container(
                height: getProportionateScreenHeight(48),
                width: double.infinity,
                margin: EdgeInsets.symmetric(
                  vertical: getProportionateScreenHeight(5),
                ),
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    Icons.map_rounded,
                    color: Colors.white,
                  ),
                  label: Text(
                    'สถานที่รอบตัว',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: Palette.PrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                  vertical: getProportionateScreenHeight(5),
                ),
                child: Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: Icon(
                        Icons.camera_alt_outlined,
                        color: Palette.LightGreenColor,
                      ),
                      label: Text(
                        'ที่เที่ยว',
                        style: TextStyle(
                          color: Palette.AdditionText,
                          fontSize: 14,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        alignment: Alignment.center,
                        side: BorderSide(color: Palette.PrimaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            bottomLeft: Radius.circular(8),
                            topRight: Radius.zero,
                            bottomRight: Radius.zero,
                          ),
                        ),
                        fixedSize: Size(
                          (SizeConfig.screenWidth -
                                  getProportionateScreenWidth(30)) /
                              3,
                          getProportionateScreenHeight(48),
                        ),
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: Icon(
                        Icons.fastfood_outlined,
                        color: Palette.PeachColor,
                      ),
                      label: Text(
                        'ที่กิน',
                        style: TextStyle(
                          color: Palette.AdditionText,
                          fontSize: 14,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        alignment: Alignment.center,
                        side: BorderSide(color: Palette.PrimaryColor),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero),
                        fixedSize: Size(
                          (SizeConfig.screenWidth -
                                  getProportionateScreenWidth(30)) /
                              3,
                          getProportionateScreenHeight(48),
                        ),
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: Icon(
                        Icons.airline_seat_individual_suite_outlined,
                        color: Palette.LightOrangeColor,
                        size: 27,
                      ),
                      label: Text(
                        'ที่พัก',
                        style: TextStyle(
                          color: Palette.AdditionText,
                          fontSize: 14,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        alignment: Alignment.center,
                        side: BorderSide(color: Palette.PrimaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                            topLeft: Radius.zero,
                            bottomLeft: Radius.zero,
                          ),
                        ),
                        fixedSize: Size(
                          (SizeConfig.screenWidth -
                                  getProportionateScreenWidth(30)) /
                              3,
                          getProportionateScreenHeight(48),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
