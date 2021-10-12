import 'package:flutter/material.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/size_config.dart';

class ReviewCard extends StatelessWidget {
  // ReviewCard({
    // required this.category,
  // });

  // final String category;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      padding: EdgeInsets.fromLTRB(
        getProportionateScreenWidth(15),
        getProportionateScreenHeight(5),
        getProportionateScreenWidth(5),
        getProportionateScreenHeight(5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
              'https://th.jobsdb.com/en-th/cms/employer/wp-content/plugins/all-in-one-seo-pack/images/default-user-image.png',
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.fromLTRB(
                getProportionateScreenWidth(10),
                getProportionateScreenHeight(5),
                getProportionateScreenWidth(10),
                getProportionateScreenHeight(5),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Jane Cooper',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Palette.BodyText,
                        ),
                      ),
                      Text(
                        'February 28, 2018',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Palette.AdditionText,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'ReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReview',
                    style: TextStyle(
                      fontSize: 12,
                      color: Palette.AdditionText,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
