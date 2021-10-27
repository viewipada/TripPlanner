import 'package:flutter/material.dart';
import 'package:trip_planner/assets.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/size_config.dart';
import 'package:trip_planner/src/view/screens/baggage_page.dart';

class BaggageCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    
    return Stack(
      alignment: Alignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(right: getProportionateScreenWidth(15)),
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
        ),
        Positioned(
          top: getProportionateScreenHeight(3),
          right: getProportionateScreenWidth(5),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: Palette.NotificationColor),
            alignment: Alignment.center,
            child: Text('10'),
          ),
        )
      ],
    );
  }
}
