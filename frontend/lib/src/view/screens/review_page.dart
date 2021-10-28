import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/size_config.dart';
import 'package:trip_planner/src/view/screens/home_page.dart';
import 'package:trip_planner/src/view_models/navigation_bar_view_model.dart';

class ReviewPage extends StatefulWidget {
  ReviewPage({
    required this.locationName,
  });

  final String locationName;

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  @override
  Widget build(BuildContext context) {
    // final navigationBarViewModel = Provider.of<NavigationBarViewModel>(context);

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "ให้คะแนนสถานที่",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Container(
                alignment: Alignment.bottomLeft,
                padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(15),
                  vertical: getProportionateScreenHeight(15),
                ),
                child: Text(
                  'สถานที่นี้เป็นอย่างไรบ้าง?',
                  style: TextStyle(
                    color: Palette.BodyText,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Center(
                child: RatingBar.builder(
                  glow: false,
                  unratedColor: Palette.Outline,
                  initialRating: 0,
                  minRating: 1,
                  direction: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, _) => Icon(
                    Icons.star_rounded,
                    color: Palette.CautionColor,
                  ),
                  onRatingUpdate: (rating) {
                    print(rating);
                  },
                ),
              ),
              Container(
                alignment: Alignment.bottomLeft,
                padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(15),
                  vertical: getProportionateScreenHeight(15),
                ),
                child: Text(
                  'เขียนความรู้สึก หรือ บรรยากาศที่คุณได้จากที่นี่',
                  style: TextStyle(
                    color: Palette.BodyText,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(15),
                ),
                child: TextField(
                  maxLines: null,
                  maxLength: 120,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'ประทับใจ สถานที่สวย บรรยากาศชวนฝัน',
                  ),
                  onSubmitted: (String value) async {
                    await showDialog<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Thanks!'),
                          content: Text(
                              'You typed "$value", which has length ${value.characters.length}.'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
