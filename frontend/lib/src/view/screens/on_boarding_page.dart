import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/assets.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/src/view_models/login_view_model.dart';

class OnBoardingPage extends StatefulWidget {
  @override
  OnBoardingPageState createState() => new OnBoardingPageState();
}

class OnBoardingPageState extends State<OnBoardingPage> {
  List<Slide> slides = [];

  late Function goToTab;

  @override
  void initState() {
    super.initState();

    slides.add(
      new Slide(
        title: "ค้นหาสถานที่อย่างรวดเร็ว",
        styleTitle: FontAssets.headingOnboarding,
        description:
            "สะดวกในการค้นหา ที่เที่ยว ที่พัก ที่กิน\nและอีกมากมายใน EZTrip",
        styleDescription: FontAssets.bodyText,
        pathImage: ImageAssets.boarding_1,
      ),
    );
    slides.add(
      new Slide(
        title: "เช็คสถานที่รอบตัวคุณ",
        styleTitle: FontAssets.headingOnboarding,
        description: "ดูสถานที่น่าสนใจรอบตัวคุณ โดยที่คุณสามารถ\nกำหนดรัศมีได้",
        styleDescription: FontAssets.bodyText,
        pathImage: ImageAssets.boarding_2,
      ),
    );
    slides.add(
      new Slide(
        title: "จัดการกระเป๋าเดินทาง",
        styleTitle: FontAssets.headingOnboarding,
        description:
            "เลือกสถานที่ที่ถูกใจไว้ในกระเป๋าเดินทาง เปิดกลับมาดูได้\nและสามารถลบออก โดยการปัดซ้ายที่สถานที่นั้น",
        styleDescription: FontAssets.bodyText,
        pathImage: ImageAssets.boarding_3,
      ),
    );
    slides.add(
      new Slide(
        title: "สร้างทริปด้วยตัวคุณเอง",
        styleTitle: FontAssets.headingOnboarding,
        description:
            "วางแผนการท่องเที่ยวด้วย EZTrip ที่แนะนำสถานที่ให้คุณ\nอีกทั้งคุณยังจัดการได้เอง เพียงลากลำดับขึ้นลง",
        styleDescription: FontAssets.bodyText,
        pathImage: ImageAssets.boarding_4,
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

  List<Widget> renderListCustomTabs() {
    List<Widget> tabs = [];
    for (int i = 0; i < slides.length; i++) {
      Slide currentSlide = slides[i];
      tabs.add(Container(
        width: double.infinity,
        height: double.infinity,
        // color: Colors.amber,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              GestureDetector(
                  child: Image.asset(
                currentSlide.pathImage!,
                width: 400,
                height: 400,
                fit: BoxFit.fitWidth,
              )),
              Container(
                child: Text(
                  currentSlide.title!,
                  style: currentSlide.styleTitle,
                  textAlign: TextAlign.center,
                ),
                margin: EdgeInsets.only(top: 40),
              ),
              Container(
                child: Text(
                  currentSlide.description!,
                  style: currentSlide.styleDescription,
                  textAlign: TextAlign.center,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
                margin: EdgeInsets.symmetric(vertical: 20.0),
              ),
            ],
          ),
        ),
      ));
    }
    return tabs;
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
      onDonePress: () => loginViewModel.goToSurveyPage(context),
      doneButtonStyle: myButtonStyle(),

      // Dot indicator
      colorDot: Palette.DotNotActive,
      colorActiveDot: Palette.PrimaryColor,
      sizeDot: 12,
      // typeDotAnimation: dotSliderAnimation.SIZE_TRANSITION,

      // Tabs
      listCustomTabs: this.renderListCustomTabs(),
      backgroundColorAllSlides: Colors.white,
      refFuncGoToTab: (refFunc) {
        this.goToTab = refFunc;
      },
    );
  }
}
