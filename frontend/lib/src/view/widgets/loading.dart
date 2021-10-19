import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shimmer/shimmer.dart';
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

class ShimmerLocationCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Shimmer.fromColors(
      baseColor: Palette.DarkGrey,
      highlightColor: Palette.TagGrey,
      child: Container(
        width: 100,
        height: 100,
        margin: EdgeInsets.only(right: getProportionateScreenWidth(15)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Palette.Outline,
        ),
      ),
    );
  }
}

class ShimmerTripCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: getProportionateScreenHeight(15),
        horizontal: getProportionateScreenWidth(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ShimmerLocationCard(),
          Expanded(
            child: Shimmer.fromColors(
              baseColor: Palette.DarkGrey,
              highlightColor: Palette.TagGrey,
              child: Container(
                margin: EdgeInsets.symmetric(
                  vertical: getProportionateScreenHeight(5),
                ),
                height: getProportionateScreenHeight(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Palette.Outline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
