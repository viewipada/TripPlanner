import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/assets.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/size_config.dart';
import 'package:trip_planner/src/view_models/review_view_model.dart';

class ReviewPage extends StatefulWidget {
  ReviewPage({
    required this.locationName,
  });

  final String locationName;

  @override
  _ReviewPageState createState() => _ReviewPageState(this.locationName);
}

class _ReviewPageState extends State<ReviewPage> {
  final String locationName;
  _ReviewPageState(this.locationName);

  String _caption = '';
  double _rating = 0;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final reviewViewModel = Provider.of<ReviewViewModel>(context);

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: TextButton(
            onPressed: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                title: const Text(
                  'ต้องการยกเลิกรีวิวหรือไม่',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Palette.BodyText,
                  ),
                  textAlign: TextAlign.center,
                ),
                content: const Text(
                  'หากคุณยกเลิก รีวิวที่คุณเขียนจะไม่ถูกเพิ่มในสถานที่นี้',
                  style: TextStyle(
                    fontSize: 14,
                    color: Palette.AdditionText,
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'ทำต่อ'),
                    child: const Text(
                      'ทำต่อ',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, 'ทำต่อ');
                      reviewViewModel.goBack(context);
                    },
                    child: const Text(
                      'ยกเลิก',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Palette.NotificationColor,
                    ),
                  ),
                ],
              ),
            ),
            child: Text("ยกเลิก"),
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(15),
              ),
              alignment: Alignment.centerLeft,
            ),
          ),
          leadingWidth: getProportionateScreenWidth(70),
          title: Text(
            "ให้คะแนนสถานที่",
            style: FontAssets.headingText,
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Container(
              height: SizeConfig.screenHeight -
                  AppBar().preferredSize.height -
                  MediaQuery.of(context).padding.bottom -
                  MediaQuery.of(context).padding.top,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.bottomLeft,
                    padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(15),
                      vertical: getProportionateScreenHeight(15),
                    ),
                    child: Text(
                      '${this.locationName} เป็นอย่างไรบ้าง?',
                      style: FontAssets.subtitleText,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      bottom: getProportionateScreenHeight(15),
                    ),
                    child: Center(
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
                          _rating = rating;
                        },
                      ),
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
                      style: FontAssets.subtitleText,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(15),
                    ),
                    padding: EdgeInsets.only(
                        bottom: getProportionateScreenHeight(15)),
                    child: TextField(
                      maxLines: 5,
                      maxLength: 120,
                      decoration: const InputDecoration(
                        hintText: 'ประทับใจ สถานที่สวย บรรยากาศชวนฝัน',
                      ),
                      onChanged: (value) => _caption = value.trim(),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenWidth(15),
                        ),
                        child: Text(
                          'ใส่รูป',
                          style: FontAssets.subtitleText,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenWidth(30),
                        ),
                        child: Text(
                          '${reviewViewModel.images.length}/3',
                          style: TextStyle(
                            fontSize: 12.5,
                            color: Palette.AdditionText,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(15),
                      vertical: getProportionateScreenHeight(15),
                    ),
                    child: Row(
                      children: [
                        addImageButton(
                          reviewViewModel,
                          ImageSource.camera,
                          Icons.add_a_photo_rounded,
                          'กล้องถ่ายรูป',
                        ),
                        SizedBox(
                          width: getProportionateScreenWidth(5),
                        ),
                        addImageButton(
                          reviewViewModel,
                          ImageSource.gallery,
                          Icons.add_photo_alternate_rounded,
                          'คลังรูปภาพ',
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    alignment: Alignment.topCenter,
                    margin: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(15),
                    ),
                    child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                      ),
                      itemCount: reviewViewModel.images.length,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  top: getProportionateScreenHeight(5)),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                child: Image.file(
                                  reviewViewModel.images[index],
                                  height: getProportionateScreenHeight(100),
                                  width: getProportionateScreenHeight(100),
                                  fit: BoxFit.cover,
                                ),
                                clipBehavior: Clip.antiAlias,
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: getProportionateScreenHeight(5),
                              child: CircleAvatar(
                                backgroundColor: Palette.BackgroundColor,
                                radius: 12,
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    reviewViewModel.deleteImage(
                                        reviewViewModel.images[index]);
                                  },
                                  icon: Icon(
                                    Icons.cancel_rounded,
                                    size: 24,
                                    color: Palette.DeleteColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        Positioned(
                          height: getProportionateScreenHeight(48),
                          bottom: getProportionateScreenHeight(15),
                          left: getProportionateScreenWidth(15),
                          right: getProportionateScreenWidth(15),
                          child: ElevatedButton(
                            onPressed: () {
                              _rating != 0
                                  ? print(
                                      'rating => ${_rating}\ncaption => ${_caption}\nimages => ${reviewViewModel.images}')
                                  : showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        title: Text(
                                          'กรุณาให้คะแนนสถานที่นี้',
                                          style: TextStyle(
                                            color: Palette.BodyText,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        contentPadding: EdgeInsets.zero,
                                        actionsAlignment:
                                            MainAxisAlignment.center,
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, 'โอเค'),
                                            child: const Text(
                                              'โอเค!',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                            },
                            child: Text(
                              'ส่งรีวิว',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Palette.PrimaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget addImageButton(ReviewViewModel reviewViewModel, ImageSource source,
    IconData iconData, String title) {
  final _color = reviewViewModel.images.length == 3
      ? Palette.AdditionText
      : Palette.PrimaryColor;

  return Expanded(
    child: ElevatedButton(
      onPressed: reviewViewModel.images.length == 3
          ? null
          : () {
              reviewViewModel.pickImageFromSource(source);
            },
      style: ElevatedButton.styleFrom(
        shadowColor: Colors.transparent,
        padding: EdgeInsets.symmetric(
          vertical: getProportionateScreenHeight(10),
        ),
        primary: Colors.white,
        side: BorderSide(
          width: 1,
          color: _color,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            iconData,
            color: _color,
          ),
          Text(
            title,
            style: TextStyle(
              color: _color,
              fontSize: 14,
            ),
          ),
        ],
      ),
    ),
  );
}
