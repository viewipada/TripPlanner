import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/assets.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/size_config.dart';
import 'package:trip_planner/src/view_models/login_view_model.dart';

class OnBoardingPage extends StatefulWidget {
  @override
  OnBoardingPageState createState() => new OnBoardingPageState();
}

class OnBoardingPageState extends State<OnBoardingPage> {
  List<Slide> slides = [];

  @override
  void initState() {
    super.initState();

    slides.add(
      new Slide(
        title: "RULER",
        marginTitle: EdgeInsets.only(top: 60, bottom: 20),
        styleTitle: FontAssets.headingText,
        description:
            "Much evil soon high in hope do view. Out may few northward believing attempted.",
        styleDescription: FontAssets.subtitleText,
        pathImage: ImageAssets.boarding_1,
        heightImage: 400,
        foregroundImageFit: BoxFit.fitWidth,
        backgroundColor: Colors.white,
      ),
    );
    slides.add(
      new Slide(
        title: "RULER",
        marginTitle: EdgeInsets.only(top: 60, bottom: 20),
        styleTitle: FontAssets.headingText,
        description:
            "Much evil soon high in hope do view. Out may few northward believing attempted.",
        styleDescription: FontAssets.subtitleText,
        pathImage: ImageAssets.boarding_2,
        heightImage: 400,
        foregroundImageFit: BoxFit.fitWidth,
        backgroundColor: Colors.white,
      ),
    );
    slides.add(
      new Slide(
        title: "RULER",
        marginTitle: EdgeInsets.only(top: 60, bottom: 20),
        styleTitle: FontAssets.headingText,
        description:
            "Much evil soon high in hope do view. Out may few northward believing attempted.",
        styleDescription: FontAssets.subtitleText,
        pathImage: ImageAssets.boarding_3,
        heightImage: 400,
        foregroundImageFit: BoxFit.fitWidth,
        backgroundColor: Colors.white,
      ),
    );
    slides.add(
      new Slide(
        title: "RULER",
        marginTitle: EdgeInsets.only(top: 60, bottom: 20),
        styleTitle: FontAssets.headingText,
        description:
            "Much evil soon high in hope do view. Out may few northward believing attempted.",
        styleDescription: FontAssets.subtitleText,
        pathImage: ImageAssets.boarding_4,
        heightImage: 400,
        foregroundImageFit: BoxFit.fitWidth,
        backgroundColor: Colors.white,
      ),
    );
  }

  Widget renderNextBtn() {
    return Text(
      'ถัดไป',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
        color: Colors.white,
      ),
    );
  }

  Widget renderDoneBtn() {
    return Text(
      'เริ่ม',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
        color: Colors.white,
      ),
    );
  }

  Widget renderSkipBtn() {
    return Text(
      'ข้าม',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );
  }

  ButtonStyle myButtonStyle() {
    return ButtonStyle(
      padding: MaterialStateProperty.all(EdgeInsets.all(11)),
      backgroundColor: MaterialStateProperty.all<Color>(Palette.PrimaryColor),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loginViewModel = Provider.of<LoginViewModel>(context);

    return new IntroSlider(
      slides: this.slides,
      // Skip button
      renderSkipBtn: this.renderSkipBtn(),
      // skipButtonStyle: myButtonStyle(),

      // Next button
      renderNextBtn: this.renderNextBtn(),
      nextButtonStyle: myButtonStyle(),

      // Done button
      renderDoneBtn: this.renderDoneBtn(),
      onDonePress: () => loginViewModel.goToHomePage(context),
      doneButtonStyle: myButtonStyle(),

      // Dot indicator
      colorDot: Palette.DotNotActive,
      colorActiveDot: Palette.PrimaryColor,
      sizeDot: 10,
    );
  }
}
