import 'package:admin/src/assets.dart';
import 'package:admin/src/palette.dart';
import 'package:admin/src/shared_pref.dart';
import 'package:admin/src/size_config.dart';
import 'package:admin/src/view_models/dashboard_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
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
    SizeConfig().init(context);
    final dashboardViewModel = Provider.of<DashBoardViewModel>(context);

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
                onPressed: () {},
                icon: const Icon(
                  Icons.logout,
                  color: Palette.additionText,
                ),
              ),
            ],
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(5),
            vertical: getProportionateScreenHeight(25)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 20,
                  ),
                  label: const Text(
                    'สร้างสถานที่',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Palette.secondaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                )
              ],
            ),
            const Text(
              'รอตรวจสอบ',
              style: FontAssets.subtitleText,
            ),
            const Text(
              'สถานที่ทั้งหมด',
              style: FontAssets.subtitleText,
            ),
          ],
        ),
      ),
    );
  }
}
