import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/size_config.dart';

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

  List<File> images = [];

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    // final navigationBarViewModel = Provider.of<NavigationBarViewModel>(context);
    Future pickImageFromSource(ImageSource source) async {
      try {
        final image = await ImagePicker().pickImage(source: source);
        if (image == null) return;
        final imageTemporary = File(image.path);
        setState(() {
          this.images.add(imageTemporary);
        });
      } on PlatformException catch (e) {
        print('Failed to pick image $e form camera');
      }
    }

    Future deleteImage(File image) async {
      setState(() {
        this.images.remove(image);
      });
    }

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
          child: Stack(
            children: [
              Column(
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
                      maxLines: 5,
                      maxLength: 120,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'ประทับใจ สถานที่สวย บรรยากาศชวนฝัน',
                        hintStyle: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomLeft,
                    margin: EdgeInsets.only(
                      bottom: getProportionateScreenHeight(15),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(15),
                      // vertical: getProportionateScreenHeight(15),
                    ),
                    child: Text(
                      'ใส่รูป',
                      style: TextStyle(
                        color: Palette.BodyText,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(15)),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: images.length == 3
                                ? null
                                : () {
                                    pickImageFromSource(ImageSource.camera);
                                  },
                            style: ElevatedButton.styleFrom(
                              shadowColor: Colors.transparent,
                              padding: EdgeInsets.symmetric(
                                vertical: getProportionateScreenHeight(10),
                              ),
                              primary: Colors.white,
                              side: BorderSide(
                                width: 1,
                                color: images.length == 3
                                    ? Palette.AdditionText
                                    : Palette.PrimaryColor,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_a_photo_rounded,
                                  color: images.length == 3
                                      ? Palette.AdditionText
                                      : Palette.PrimaryColor,
                                ),
                                Text(
                                  'กล้องถ่ายรูป',
                                  style: TextStyle(
                                    color: images.length == 3
                                        ? Palette.AdditionText
                                        : Palette.PrimaryColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: getProportionateScreenWidth(5),
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: images.length == 3
                                ? null
                                : () {
                                    pickImageFromSource(ImageSource.gallery);
                                  },
                            style: ElevatedButton.styleFrom(
                              shadowColor: Colors.transparent,
                              padding: EdgeInsets.symmetric(
                                vertical: getProportionateScreenHeight(10),
                              ),
                              primary: Colors.white,
                              side: BorderSide(
                                width: 1,
                                color: images.length == 3
                                    ? Palette.AdditionText
                                    : Palette.PrimaryColor,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_photo_alternate_rounded,
                                  color: images.length == 3
                                      ? Palette.AdditionText
                                      : Palette.PrimaryColor,
                                ),
                                Text(
                                  'คลังรูปภาพ',
                                  style: TextStyle(
                                    color: images.length == 3
                                        ? Palette.AdditionText
                                        : Palette.PrimaryColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    alignment: Alignment.topCenter,
                    margin: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(15),
                      vertical: getProportionateScreenHeight(15),
                    ),
                    child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                      ),
                      itemCount: images.length,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            Center(
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                child: Image.file(
                                  this.images[index],
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                ),
                                clipBehavior: Clip.antiAlias,
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: CircleAvatar(
                                backgroundColor: Palette.BackgroundColor,
                                radius: 12,
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    deleteImage(this.images[index]);
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
                ],
              ),
              Positioned(
                height: getProportionateScreenHeight(48),
                bottom: getProportionateScreenHeight(5),
                left: getProportionateScreenWidth(15),
                right: getProportionateScreenWidth(15),
                child: ElevatedButton(
                  onPressed: () {
                    print('ส่งรีวิว');
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
      ),
    );
  }
}
