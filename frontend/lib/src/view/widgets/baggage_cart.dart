import 'package:flutter/material.dart';
import 'package:trip_planner/assets.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/size_config.dart';
import 'package:trip_planner/src/view/screens/baggage_page.dart';

class BaggageCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Padding(
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
          icon: ImageIcon(
            AssetImage(IconAssets.baggage),
          ),
          color: Colors.white,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BaggagePage()),
            );
          },
        ),
      ),
    );
  }
}
