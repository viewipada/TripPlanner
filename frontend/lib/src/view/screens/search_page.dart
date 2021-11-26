import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/assets.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/size_config.dart';
import 'package:trip_planner/src/view/widgets/baggage_cart.dart';
import 'package:trip_planner/src/view_models/search_view_model.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  void initState() {
    Provider.of<SearchViewModel>(context, listen: false).getUserLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final searchViewModel = Provider.of<SearchViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "สำรวจ",
          style: FontAssets.headingText,
        ),
        centerTitle: true,
        actions: [
          BaggageCart(),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin:
                    EdgeInsets.only(bottom: getProportionateScreenHeight(10)),
                decoration: BoxDecoration(
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.black54,
                        blurRadius: 5.0,
                        offset: Offset(0.0, 0.75))
                  ],
                  color: Colors.white,
                ),
                child: InkWell(
                  onTap: () => searchViewModel.goToSearchResultPage(context),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(15),
                      vertical: getProportionateScreenHeight(10),
                    ),
                    child: TextField(
                      enabled: false,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: Palette.AdditionText,
                          size: 30,
                        ),
                        hintText: 'ค้นหาที่เที่ยวเลย',
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: getProportionateScreenHeight(5),
                  horizontal: getProportionateScreenWidth(15),
                ),
                child: Text(
                  'หาอะไรทำรอบตัวคุณ',
                  style: FontAssets.titleText,
                ),
              ),
              Container(
                height: getProportionateScreenHeight(48),
                width: double.infinity,
                margin: EdgeInsets.symmetric(
                  vertical: getProportionateScreenHeight(5),
                  horizontal: getProportionateScreenWidth(15),
                ),
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (searchViewModel.userLocation != null) {
                      searchViewModel.goToMyLocationPage(
                          context, 'ทุกแบบ', searchViewModel.userLocation!);
                    }
                  },
                  icon: Icon(
                    Icons.map_rounded,
                    color: Colors.white,
                  ),
                  label: Text(
                    'สถานที่รอบตัว',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: Palette.PrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                  vertical: getProportionateScreenHeight(5),
                  horizontal: getProportionateScreenWidth(15),
                ),
                child: Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {
                        if (searchViewModel.userLocation != null) {
                          searchViewModel.goToMyLocationPage(context,
                              'ที่เที่ยว', searchViewModel.userLocation!);
                        }
                      },
                      icon: Icon(
                        Icons.camera_alt_outlined,
                        color: Palette.LightGreenColor,
                      ),
                      label: Text(
                        'ที่เที่ยว',
                        style: TextStyle(
                          color: Palette.AdditionText,
                          fontSize: 14,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        alignment: Alignment.center,
                        side: BorderSide(color: Palette.PrimaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            bottomLeft: Radius.circular(8),
                            topRight: Radius.zero,
                            bottomRight: Radius.zero,
                          ),
                        ),
                        fixedSize: Size(
                          (SizeConfig.screenWidth -
                                  getProportionateScreenWidth(30)) /
                              3,
                          getProportionateScreenHeight(48),
                        ),
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {
                        if (searchViewModel.userLocation != null) {
                          searchViewModel.goToMyLocationPage(
                              context, 'ที่กิน', searchViewModel.userLocation!);
                        }
                      },
                      icon: Icon(
                        Icons.fastfood_outlined,
                        color: Palette.PeachColor,
                      ),
                      label: Text(
                        'ที่กิน',
                        style: TextStyle(
                          color: Palette.AdditionText,
                          fontSize: 14,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        alignment: Alignment.center,
                        side: BorderSide(color: Palette.PrimaryColor),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero),
                        fixedSize: Size(
                          (SizeConfig.screenWidth -
                                  getProportionateScreenWidth(30)) /
                              3,
                          getProportionateScreenHeight(48),
                        ),
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {
                        if (searchViewModel.userLocation != null) {
                          searchViewModel.goToMyLocationPage(
                              context, 'ที่พัก', searchViewModel.userLocation!);
                        }
                      },
                      icon: Icon(
                        Icons.hotel_outlined,
                        color: Palette.LightOrangeColor,
                        size: 27,
                      ),
                      label: Text(
                        'ที่พัก',
                        style: TextStyle(
                          color: Palette.AdditionText,
                          fontSize: 14,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        alignment: Alignment.center,
                        side: BorderSide(color: Palette.PrimaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                            topLeft: Radius.zero,
                            bottomLeft: Radius.zero,
                          ),
                        ),
                        fixedSize: Size(
                          (SizeConfig.screenWidth -
                                  getProportionateScreenWidth(30)) /
                              3,
                          getProportionateScreenHeight(48),
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
    );
  }
}
