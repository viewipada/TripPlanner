import 'package:flutter/material.dart';
import 'package:trip_planner/assets.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/size_config.dart';
import 'package:trip_planner/src/view/widgets/tag_category.dart';

class StartPointCard extends StatelessWidget {
  StartPointCard({
    required this.imageUrl,
    required this.locationName,
    required this.description,
    required this.category,
  });
  final String imageUrl;
  final String locationName;
  final String description;
  final String category;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Container(
      height: getProportionateScreenHeight(110),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: getProportionateScreenWidth(15),
            ),
            child: Center(
              child: Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image(
                    width: getProportionateScreenHeight(100),
                    height: getProportionateScreenHeight(100),
                    fit: BoxFit.cover,
                    image: imageUrl == ''
                        ? Image.asset(ImageAssets.noPreview).image
                        : imageUrl == 'myLocation'
                            ? Image.asset(ImageAssets.myLocation).image
                            : NetworkImage(imageUrl),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                getProportionateScreenWidth(10),
                getProportionateScreenHeight(5),
                getProportionateScreenWidth(15),
                getProportionateScreenHeight(5),
              ),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      locationName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: description ==
                              'เลือกตำแหน่งปัจจุบันเป็นจุดเริ่มต้นทริป'
                          ? TextStyle(
                              color: Palette.PrimaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)
                          : FontAssets.subtitleText,
                    ),
                    Text(
                      description,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: FontAssets.bodyText,
                    ),
                    Spacer(
                      flex: 2,
                    ),
                    Visibility(
                      visible: category != '',
                      child: TagCategory(
                        category: category,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
