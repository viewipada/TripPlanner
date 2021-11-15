import 'package:flutter/material.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/size_config.dart';
import 'package:trip_planner/src/models/response/baggage_response.dart';
import 'package:trip_planner/src/view/widgets/tag_category.dart';

class StartPointCard extends StatelessWidget {
  StartPointCard({
    required this.item,
  });
  final BaggageResponse item;

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
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    image: NetworkImage(item.imageUrl),
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
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: getProportionateScreenHeight(5),
                      ),
                      child: Text(
                        item.locationName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Text(
                      item.description,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 12,
                        color: Palette.BodyText,
                      ),
                    ),
                    Spacer(
                      flex: 2,
                    ),
                    TagCategory(
                      category: item.category,
                    )
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
