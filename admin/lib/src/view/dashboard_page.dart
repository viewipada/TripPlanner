import 'package:admin/src/assets.dart';
import 'package:admin/src/models/location_card_response.dart';
import 'package:admin/src/palette.dart';
import 'package:admin/src/shared_pref.dart';
import 'package:admin/src/size_config.dart';
import 'package:admin/src/view_models/dashboard_view_model.dart';
import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

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
    Provider.of<DashBoardViewModel>(context, listen: false).getLocationBy(0);
    Provider.of<DashBoardViewModel>(context, listen: false)
        .getLocationRequest();
    textController.clear();

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
              hintText: 'ค้นหาชื่อสถานที่',
            ),
            onChanged: (value) {
              if (value == "") {
                dashboardViewModel.isSearchMode();
              } else {
                dashboardViewModel.isQueryMode();
                dashboardViewModel.query(value);
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.screenWidth / 6,
              vertical: getProportionateScreenHeight(25)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.centerRight,
                margin:
                    EdgeInsets.only(bottom: getProportionateScreenHeight(10)),
                child: ElevatedButton.icon(
                  onPressed: () {
                    textController.clear();
                    dashboardViewModel.isSearchMode();
                    dashboardViewModel.goToCreateLocation(context);
                  },
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
              buildColumn(),
              const Divider(),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: getProportionateScreenHeight(15)),
                child: dashboardViewModel.locationsRequest == null
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 3,
                        itemBuilder: (context, index) => loadingRow())
                    : dashboardViewModel.locationsRequest!.isEmpty
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: getProportionateScreenHeight(10)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  'ไม่มีรายการรอตรวจสอบ',
                                  style: FontAssets.bodyText,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                        : ListView(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            children: dashboardViewModel.locationsRequest!
                                .map(
                                  (item) => buildCard(context,
                                      dashboardViewModel, item, textController),
                                )
                                .toList(),
                          ),
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
                    dropdownHeight: getProportionateScreenHeight(200) + 20,
                    dropdownItemGap: 0,
                    dropdownWidth: getProportionateScreenWidth(45),
                    dropdownItemHeight: getProportionateScreenHeight(50),
                    resultWidth: getProportionateScreenWidth(50),
                    resultHeight: getProportionateScreenHeight(50),
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
                      dashboardViewModel.getLocationBy(selectedItem['value']);
                    },
                  ),
                ],
              ),
              buildColumn(),
              const Divider(),
              Visibility(
                visible: !dashboardViewModel.isQuery,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: getProportionateScreenHeight(15)),
                  child: dashboardViewModel.locations.isEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 3,
                          itemBuilder: (context, index) => loadingRow())
                      : ListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: dashboardViewModel.locations
                              .map(
                                (item) => buildCard(context, dashboardViewModel,
                                    item, textController),
                              )
                              .toList(),
                        ),
                ),
              ),
              Visibility(
                visible: dashboardViewModel.isQuery,
                child: dashboardViewModel.queryResult.isEmpty
                    ? Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: getProportionateScreenHeight(30)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'ไม่พบผลลัพธ์ที่คุณค้นหา',
                              style: FontAssets.bodyText,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                            vertical: getProportionateScreenHeight(15)),
                        children: dashboardViewModel.queryResult
                            .map(
                              (item) => buildCard(context, dashboardViewModel,
                                  item, textController),
                            )
                            .toList(),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget loadingRow() {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Expanded(
        child: Shimmer.fromColors(
          baseColor: Palette.darkGrey,
          highlightColor: Palette.tagGrey,
          child: Container(
            margin: EdgeInsets.only(
              top: getProportionateScreenHeight(15),
              bottom: getProportionateScreenHeight(15),
              right: getProportionateScreenWidth(10),
            ),
            height: getProportionateScreenHeight(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Palette.outline,
            ),
          ),
        ),
      ),
      Expanded(
        flex: 2,
        child: Shimmer.fromColors(
          baseColor: Palette.darkGrey,
          highlightColor: Palette.tagGrey,
          child: Container(
            margin: EdgeInsets.only(
              top: getProportionateScreenHeight(15),
              bottom: getProportionateScreenHeight(15),
              right: getProportionateScreenWidth(10),
            ),
            height: getProportionateScreenHeight(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Palette.outline,
            ),
          ),
        ),
      ),
      Expanded(
        flex: 3,
        child: Shimmer.fromColors(
          baseColor: Palette.darkGrey,
          highlightColor: Palette.tagGrey,
          child: Container(
            margin: EdgeInsets.only(
              top: getProportionateScreenHeight(15),
              bottom: getProportionateScreenHeight(15),
              right: getProportionateScreenWidth(10),
            ),
            height: getProportionateScreenHeight(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Palette.outline,
            ),
          ),
        ),
      ),
      Expanded(
        child: Shimmer.fromColors(
          baseColor: Palette.darkGrey,
          highlightColor: Palette.tagGrey,
          child: Container(
            margin: EdgeInsets.only(
              top: getProportionateScreenHeight(15),
              bottom: getProportionateScreenHeight(15),
              right: getProportionateScreenWidth(10),
            ),
            height: getProportionateScreenHeight(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Palette.outline,
            ),
          ),
        ),
      ),
      Expanded(
        child: Shimmer.fromColors(
          baseColor: Palette.darkGrey,
          highlightColor: Palette.tagGrey,
          child: Container(
            margin: EdgeInsets.only(
              top: getProportionateScreenHeight(15),
              bottom: getProportionateScreenHeight(15),
              right: getProportionateScreenWidth(10),
            ),
            height: getProportionateScreenHeight(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Palette.outline,
            ),
          ),
        ),
      ),
    ],
  );
}

Widget buildCard(BuildContext context, DashBoardViewModel dashBoardViewModel,
    LocationCardResponse location, textController) {
  return OnHover(
    builder: (isHovered) {
      return InkWell(
        onTap: () {
          textController.clear();
          dashBoardViewModel.isSearchMode();
          dashBoardViewModel.goToLocationDetail(context, location.locationId);
        },
        child: Container(
          padding:
              EdgeInsets.symmetric(vertical: getProportionateScreenHeight(15)),
          color: isHovered ? const Color(0xffDEF1FF) : null,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  DateFormat('dd/MM/yyyy')
                      .format(DateTime.parse(location.updateDate)),
                  style: FontAssets.bodyText,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'location.username',
                  style: FontAssets.bodyText,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  location.locationName,
                  style: FontAssets.bodyText,
                ),
              ),
              Expanded(
                child: Text(
                  location.category == 1
                      ? "ที่เที่ยว"
                      : location.category == 2
                          ? "ที่กิน"
                          : location.category == 3
                              ? "ที่พัก"
                              : "ของฝาก",
                  style: FontAssets.bodyText,
                ),
              ),
              Expanded(
                child: Text(
                  location.locationType,
                  style: FontAssets.bodyText,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget buildColumn() {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: getProportionateScreenHeight(15)),
    child: Row(
      children: const [
        Expanded(
          child: Text(
            'วันที่',
            style: FontAssets.columnText,
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            'ชื่อผู้ใช้',
            style: FontAssets.columnText,
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            'ชื่อสถานที่',
            style: FontAssets.columnText,
          ),
        ),
        Expanded(
          child: Text(
            'หมวดหมู่',
            style: FontAssets.columnText,
          ),
        ),
        Expanded(
          child: Text(
            'ประเภท',
            style: FontAssets.columnText,
          ),
        ),
      ],
    ),
  );
}

class OnHover extends StatefulWidget {
  final Widget Function(bool isHovered) builder;

  const OnHover({Key? key, required this.builder}) : super(key: key);

  @override
  _OnHoverState createState() => _OnHoverState();
}

class _OnHoverState extends State<OnHover> {
  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => onEntered(true),
      onExit: (_) => onEntered(false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        child: widget.builder(isHovered),
      ),
    );
  }

  void onEntered(bool isHovered) {
    setState(() {
      this.isHovered = isHovered;
    });
  }
}
