import 'package:admin/src/assets.dart';
import 'package:admin/src/models/location_detail_response.dart';
import 'package:admin/src/palette.dart';
import 'package:admin/src/shared_pref.dart';
import 'package:admin/src/size_config.dart';
import 'package:admin/src/view_models/dashboard_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class LocationDetailPage extends StatefulWidget {
  static const route = '/dashboard/location';

  const LocationDetailPage({
    Key? key,
    // required this.locationId,
  }) : super(key: key);

  // final int locationId;

  @override
  _LocationDetailPageState createState() => _LocationDetailPageState();
}

class _LocationDetailPageState extends State<LocationDetailPage> {
  String? username;
  @override
  void initState() {
    SharedPref().getUsername().then((value) {
      setState(() {
        username = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var locationId = ModalRoute.of(context)!.settings.arguments as int;
    SizeConfig().init(context);
    final dashBoardViewModel = Provider.of<DashBoardViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: const [
            Text(
              "EZtrip",
              style: FontAssets.headingText,
            ),
            Text(
              " Admin",
              style: TextStyle(
                fontSize: 20,
                color: Palette.webText,
              ),
            )
          ],
        ),
        actions: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                username ?? "Admin",
                style: FontAssets.bodyText,
              ),
              IconButton(
                onPressed: () => dashBoardViewModel.logout(context),
                icon: const Icon(
                  Icons.logout,
                  color: Palette.additionText,
                ),
              ),
              SizedBox(
                width: getProportionateScreenWidth(8),
              )
            ],
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: FutureBuilder(
        future: dashBoardViewModel.getLocationDetailById(locationId),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            var location = snapshot.data as LocationDetailResponse;
            return Container(
              margin:
                  EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth / 4),
              child: Column(
                children: [],
              ),
            );
          } else {
            return loading();
          }
        },
      ),
    );
  }
}

Widget loading() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SpinKitDoubleBounce(
        color: Palette.primaryColor,
        size: getProportionateScreenWidth(30),
      ),
      const Text('กรุณารอสักครู่...', style: FontAssets.bodyText)
    ],
  );
}
