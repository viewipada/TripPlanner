import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:trip_planner/assets.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/size_config.dart';
import 'package:trip_planner/src/models/response/review_response.dart';
import 'package:intl/intl.dart';

class ReviewCard extends StatelessWidget {
  ReviewCard({
    required this.reviews,
  });

  final List<ReviewResponse> reviews;

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
      child: Column(
        children: reviews.map((review) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  review.profileImage,
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(10),
                    vertical: getProportionateScreenHeight(5),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            review.username,
                            style: FontAssets.subtitleText,
                          ),
                          Text(
                            DateFormat('dd/MM/yyyy')
                                .format(DateTime.parse(review.createdDate)),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Palette.AdditionText,
                            ),
                          ),
                        ],
                      ),
                      RatingBarIndicator(
                        unratedColor: Palette.Outline,
                        rating: review.rating.toDouble(),
                        itemBuilder: (context, index) => Icon(
                          Icons.star_rounded,
                          color: Palette.CautionColor,
                        ),
                        itemCount: 5,
                        itemSize: 20,
                      ),
                      Text(
                        review.caption,
                        style: FontAssets.bodyText,
                      ),
                      Visibility(
                        visible: review.images.isNotEmpty,
                        child: GridView(
                          padding: EdgeInsets.zero,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            // crossAxisSpacing: getProportionateScreenWidth(5),
                          ),
                          children: review.images.map((image) {
                            return GestureDetector(
                              onLongPress: () => showDialog(
                                context: context,
                                builder: (_) => Dialog(
                                  backgroundColor: Colors.transparent,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.network(
                                      image,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                child: Image.network(
                                  image,
                                  height: getProportionateScreenHeight(100),
                                  width: getProportionateScreenHeight(100),
                                  fit: BoxFit.cover,
                                ),
                                clipBehavior: Clip.antiAlias,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
