import 'package:flutter/material.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/size_config.dart';

class TagCategory extends StatelessWidget {
  TagCategory({
    required this.category,
  });

  final String category;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      decoration: BoxDecoration(
        color: Palette.TagGrey,
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(9),
        vertical: getProportionateScreenHeight(2),
      ),
      child: Text(
        this.category,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
    );
  }
}
