import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/assets.dart';
import 'package:trip_planner/size_config.dart';
import 'package:trip_planner/src/view/widgets/baggage_cart.dart';
import 'package:trip_planner/src/view/widgets/location_card.dart';
import 'package:trip_planner/src/view/widgets/trip_card.dart';
import 'package:trip_planner/src/view_models/home_view_model.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    Provider.of<HomeViewModel>(context, listen: false).getHotLocationList();
    Provider.of<HomeViewModel>(context, listen: false)
        .getLocationRecommendedList();
    Provider.of<HomeViewModel>(context, listen: false).getTripRecommendedList();
    super.initState();
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
              LocationCard(
                header: " สถานที่ยอดฮิต",
                locationList: homeViewModel.hotLocationList,
              ),
              Divider(),
              LocationCard(
                header: " แนะนำสำหรับคุณ",
                locationList: homeViewModel.locationRecommendedList,
              ),
              Divider(),
              TripCard(
                header: " ทริปที่คุณอาจถูกใจ",
                tripList: homeViewModel.tripRecommendedList,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
