import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/assets.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/size_config.dart';
import 'package:trip_planner/src/models/response/location_card_response.dart';
import 'package:trip_planner/src/models/response/trip_card_response.dart';
import 'package:trip_planner/src/view/widgets/baggage_cart.dart';
import 'package:trip_planner/src/view/widgets/loading.dart';
import 'package:trip_planner/src/view/widgets/location_card.dart';
import 'package:trip_planner/src/view/widgets/trip_card.dart';
import 'package:trip_planner/src/view_models/home_view_model.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<LocationCardResponse>? hotLocations;
  List<LocationCardResponse>? recommendLocations;
  List<TripCardResponse>? trips;
  @override
  void initState() {
    super.initState();
    Provider.of<HomeViewModel>(context, listen: false)
        .getHotLocationList()
        .then((value) {
      setState(() {
        hotLocations = value;
      });
    });
    Provider.of<HomeViewModel>(context, listen: false)
        .getLocationRecommendedList()
        .then((value) {
      setState(() {
        recommendLocations = value;
      });
    });
    Provider.of<HomeViewModel>(context, listen: false)
        .getTripRecommendedList()
        .then((value) {
      setState(() {
        trips = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final homeViewModel = Provider.of<HomeViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.fromLTRB(
            getProportionateScreenWidth(15),
            getProportionateScreenHeight(5),
            0,
            getProportionateScreenHeight(5),
          ),
          child: Image.asset(
            ImageAssets.logo,
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
        ),
        title: Text(
          "เริ่มต้นความสนุกกับ EZtrip",
          style: FontAssets.headingText,
        ),
        actions: [
          BaggageCart(),
        ],
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Image.asset(
                  ImageAssets.homeBanner,
                  fit: BoxFit.fitWidth,
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  top: getProportionateScreenHeight(15),
                ),
                margin: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(15)),
                child: Text(
                  'สร้างทริปง่าย ๆ ได้ด้วยตัวคุณ',
                  textAlign: TextAlign.start,
                  style: FontAssets.titleText,
                ),
              ),
              Container(
                width: double.infinity,
                height: getProportionateScreenHeight(48),
                margin: EdgeInsets.symmetric(
                  vertical: getProportionateScreenHeight(10),
                  horizontal: getProportionateScreenWidth(15),
                ),
                child: ElevatedButton(
                  onPressed: () => homeViewModel.goToTripFormPage(context),
                  child: Text(
                    'เริ่มสร้างทริป',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Palette.PrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: getProportionateScreenHeight(15),
              ),
              Divider(),
              hotLocations == null
                  ? loadingLocationCard(" สถานที่ยอดฮิต")
                  : LocationCard(
                      header: " สถานที่ยอดฮิต",
                      locationList: homeViewModel.hotLocationList,
                    ),
              Divider(),
              recommendLocations == null
                  ? loadingLocationCard(" แนะนำสำหรับคุณ")
                  : LocationCard(
                      header: " แนะนำสำหรับคุณ",
                      locationList: homeViewModel.locationRecommendedList,
                    ),
              Divider(),
              trips == null
                  ? loadingTripCard(" ทริปที่คุณอาจถูกใจ")
                  : TripCard(
                      header: " ทริปที่คุณอาจถูกใจ",
                      tripList: homeViewModel.tripRecommendedList,
                    )
            ],
          ),
        ),
      ),
    );
  }
}

Widget loadingLocationCard(String header) {
  return Container(
    padding: EdgeInsets.only(
      top: getProportionateScreenHeight(15),
    ),
    child: Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(15),
          ),
          child: Container(
            alignment: Alignment.bottomLeft,
            child: Text(
              header,
              textAlign: TextAlign.start,
              style: FontAssets.titleText,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: getProportionateScreenWidth(15)),
          padding: EdgeInsets.only(top: getProportionateScreenHeight(10)),
          alignment: Alignment.topCenter,
          height: getProportionateScreenHeight(160),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShimmerLocationCard(),
              ShimmerLocationCard(),
              ShimmerLocationCard(),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget loadingTripCard(String header) {
  return Container(
    padding: EdgeInsets.symmetric(
      vertical: getProportionateScreenHeight(15),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(15),
          ),
          margin: EdgeInsets.only(bottom: getProportionateScreenHeight(5)),
          child: Text(
            header,
            textAlign: TextAlign.start,
            style: FontAssets.titleText,
          ),
        ),
        ShimmerTripCard(),
      ],
    ),
  );
}
