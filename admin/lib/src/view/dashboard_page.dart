import 'package:admin/src/assets.dart';
import 'package:admin/src/palette.dart';
import 'package:admin/src/shared_pref.dart';
import 'package:admin/src/size_config.dart';
import 'package:admin/src/view_models/dashboard_view_model.dart';
import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final textController = TextEditingController();

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
        leading: Padding(
          padding: EdgeInsets.only(left: getProportionateScreenWidth(5)),
          child: Row(
            children: const [
              Text(
                "EZtrip",
                style: FontAssets.headingText,
              ),
              Expanded(
                child: Text(
                  " Admin",
                  style: TextStyle(
                    fontSize: 20,
                    color: Palette.webText,
                  ),
                ),
              ),
            ],
          ),
        ),
        leadingWidth: getProportionateScreenWidth(50),
        title: SizedBox(
          width: SizeConfig.screenWidth / 2,
          child: TextField(
            controller: textController,
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.search_rounded,
                size: 30,
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.cancel_rounded, color: Palette.outline),
                onPressed: () {
                  textController.clear();
                  dashboardViewModel.isSearchMode();
                },
              ),
              hintText: 'ค้นหาสถานที่',
            ),
            onChanged: (value) {
              if (value.length == 0) {
                // dashboardViewModel.isSearchMode();
              } else {
                // dashboardViewModel.isQueryMode();
                // dashboardViewModel.query(allLocationList, value);
              }
            },
          ),
        ),
        centerTitle: true,
        actions: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                username ?? "Admin",
                style: FontAssets.bodyText,
              ),
              IconButton(
                onPressed: () => dashboardViewModel.logout(context),
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
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.screenWidth / 4,
            vertical: getProportionateScreenHeight(25)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.centerRight,
              margin: EdgeInsets.only(
                  bottom: getProportionateScreenHeight(10)),
              child: ElevatedButton.icon(
                onPressed: () => dashboardViewModel.goToCreateLocation(context),
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
                  primary: Palette.webText,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
            ),
            const Text(
              'รอตรวจสอบ',
              style: FontAssets.subtitleText,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'สถานที่ทั้งหมด',
                  style: FontAssets.subtitleText,
                ),
                CoolDropdown(
                  dropdownList: dashboardViewModel.dropdownItemList,
                  defaultValue: dashboardViewModel.dropdownItemList[0],
                  dropdownHeight: 220,
                  dropdownItemGap: 0,
                  dropdownWidth: getProportionateScreenWidth(40),
                  resultWidth: getProportionateScreenWidth(50),
                  triangleHeight: 0,
                  gap: getProportionateScreenHeight(5),
                  resultTS: const TextStyle(
                    color: Palette.additionText,
                    fontSize: 14,
                    fontFamily: 'Sukhumvit',
                  ),
                  selectedItemTS: const TextStyle(
                    color: Palette.primaryColor,
                    fontSize: 14,
                    fontFamily: 'Sukhumvit',
                  ),
                  unselectedItemTS: const TextStyle(
                    color: Palette.bodyText,
                    fontSize: 14,
                    fontFamily: 'Sukhumvit',
                  ),
                  onChange: (selectedItem) {
                    dashboardViewModel.getSearchResultBy(selectedItem['value']);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
