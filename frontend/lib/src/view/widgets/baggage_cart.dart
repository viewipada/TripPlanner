import 'package:flutter/material.dart';
import 'package:trip_planner/assets.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/size_config.dart';
import 'package:trip_planner/src/repository/shared_pref.dart';
import 'package:trip_planner/src/view/screens/baggage_page.dart';

class BaggageCart extends StatefulWidget {
  @override
  _BaggageCartState createState() => _BaggageCartState();
}

class _BaggageCartState extends State<BaggageCart> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Stack(
      alignment: Alignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(right: getProportionateScreenWidth(15)),
          child: CircleAvatar(
            backgroundColor: Palette.SecondaryColor,
            radius: 20,
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: ImageIcon(
                AssetImage(IconAssets.baggage),
              ),
              color: Colors.white,
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BaggagePage()),
                );
                if (result != null) setState(() {});
              },
            ),
          ),
        ),
        FutureBuilder(
          future: SharedPref().getBaggageItems(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              var baggageList = snapshot.data as List<String>;
              return baggageList.isEmpty
                  ? SizedBox()
                  : Positioned(
                      top: getProportionateScreenHeight(3),
                      right: getProportionateScreenWidth(5),
                      child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Palette.NotificationColor),
                          alignment: Alignment.center,
                          child: Text('${baggageList.length}')),
                    );
            } else {
              return SizedBox();
            }
          },
        ),
      ],
    );
  }
}
