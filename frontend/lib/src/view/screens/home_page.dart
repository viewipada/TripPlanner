import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/assets.dart';
import 'package:trip_planner/size_config.dart';
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
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          BaggageCart(),
        ],
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: Image.asset(
                  ImageAssets.homeBanner,
                  fit: BoxFit.fitWidth,
                ),
              ),
              FutureBuilder(
                future: Provider.of<HomeViewModel>(context, listen: false)
                    .getHotLocationList(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return LocationCard(
                      header: " สถานที่ยอดฮิต",
                      locationList: homeViewModel.hotLocationList,
                    );
                  } else {
                    return loadingLocationCard(" สถานที่ยอดฮิต");
                  }
                },
              ),
              Divider(),
              FutureBuilder(
                future: Provider.of<HomeViewModel>(context, listen: false)
                    .getLocationRecommendedList(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return LocationCard(
                      header: " แนะนำสำหรับคุณ",
                      locationList: homeViewModel.locationRecommendedList,
                    );
                  } else {
                    return loadingLocationCard(" แนะนำสำหรับคุณ");
                  }
                },
              ),
              Divider(),
              FutureBuilder(
                future: Provider.of<HomeViewModel>(context, listen: false)
                    .getTripRecommendedList(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return TripCard(
                      header: " ทริปที่คุณอาจถูกใจ",
                      tripList: homeViewModel.tripRecommendedList,
                    );
                  } else {
                    return loadingTripCard(" ทริปที่คุณอาจถูกใจ");
                  }
                },
              ),
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
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
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
          child: Text(
            header,
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ShimmerTripCard(),
      ],
    ),
  );
}
