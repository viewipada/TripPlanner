import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/size_config.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SpinKitDoubleBounce(
          color: Palette.PrimaryColor,
          size: getProportionateScreenWidth(100),
        ),
        Text('กรุณารอสักครู่...')
      ],
    );
  }
}
