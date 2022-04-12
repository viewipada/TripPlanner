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
            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Container(
                margin: EdgeInsets.symmetric(
                    horizontal: SizeConfig.screenWidth / 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      child: Image.network(
                        location.imageUrl,
                        height: getProportionateScreenHeight(350),
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      clipBehavior: Clip.antiAlias,
                    ),
                    subtitle('ชื่อสถานที่ ', '*'),
                    TextFormField(
                      initialValue: location.locationName,
                      maxLines: 1,
                      readOnly: true,
                      enabled: false,
                    ),
                    subtitle('หมวดหมู่สถานที่ ', '*'),
                    TextFormField(
                      initialValue: location.category == 1
                          ? "ที่เที่ยว"
                          : location.category == 2
                              ? "ที่กิน"
                              : location.category == 3
                                  ? "ที่พัก"
                                  : "ของฝาก",
                      maxLines: 1,
                      readOnly: true,
                      enabled: false,
                    ),
                    subtitle('ประเภทสถานที่ ', '*'),
                    TextFormField(
                      initialValue: location.locationType,
                      maxLines: 1,
                      readOnly: true,
                      enabled: false,
                    ),
                    location.locationType == 'ที่พัก'
                        ? subtitle('ช่วงราคา ', '*')
                        : const SizedBox(),
                    location.locationType == 'ที่พัก'
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: TextFormField(
                                  initialValue: location.minPrice.toString(),
                                  maxLines: 1,
                                  readOnly: true,
                                  enabled: false,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: getProportionateScreenWidth(5),
                                ),
                                child: const Icon(
                                  Icons.minimize_rounded,
                                  color: Palette.infoText,
                                ),
                              ),
                              Expanded(
                                child: TextFormField(
                                  initialValue: location.maxPrice.toString(),
                                  maxLines: 1,
                                  readOnly: true,
                                  enabled: false,
                                ),
                              ),
                            ],
                          )
                        : const SizedBox(),
                    subtitle('จังหวัด ', '*'),
                    TextFormField(
                      initialValue: location.province,
                      maxLines: 1,
                      readOnly: true,
                      enabled: false,
                    ),
                    subtitle('ตำแหน่งบนแผนที่ ', '*'),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: location.latitude.toString(),
                            maxLines: 1,
                            readOnly: true,
                            enabled: false,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: getProportionateScreenWidth(5),
                          ),
                          child: const Text(
                            ',',
                            style: FontAssets.headingText,
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            initialValue: location.longitude.toString(),
                            maxLines: 1,
                            readOnly: true,
                            enabled: false,
                          ),
                        ),
                      ],
                    ),
                    subtitle('เขียนแนะนำสถานที่เบื้องต้น ', '*'),
                    SizedBox(
                      height: getProportionateScreenHeight(150),
                      child: TextFormField(
                        initialValue: location.description,
                        maxLines: 100,
                        maxLength: 300,
                        readOnly: true,
                        enabled: false,
                        decoration: const InputDecoration(
                          counterText: "",
                        ),
                      ),
                    ),
                    subtitle('เบอร์ติดต่อ', ''),
                    TextFormField(
                      initialValue: location.contactNumber,
                      maxLines: 1,
                      maxLength: 10,
                      readOnly: true,
                      enabled: false,
                      decoration: const InputDecoration(
                        counterText: "",
                      ),
                    ),
                    subtitle('เว็บไซต์, Facebook', ''),
                    TextFormField(
                      initialValue: location.website,
                      maxLines: 1,
                      readOnly: true,
                      enabled: false,
                    ),
                    Container(
                      alignment: Alignment.bottomLeft,
                      margin: EdgeInsets.only(
                          top: getProportionateScreenHeight(15)),
                      child: const Text(
                        'วันเวลาทำการ',
                        style: FontAssets.columnText,
                      ),
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(15),
                    ),
                    // buildOpeningHour("วันจันทร์", location.openingHour[0]),
                    // buildOpeningHour("วันอังคาร", location.openingHour[1]),
                    // buildOpeningHour("วันพุธ", location.openingHour[2]),
                    // buildOpeningHour("วันพฤหัสบดี", location.openingHour[3]),
                    // buildOpeningHour("วันศุกร์", location.openingHour[4]),
                    // buildOpeningHour("วันเสาร์", location.openingHour[5]),
                    // buildOpeningHour("วันอาทิตย์", location.openingHour[6]),
                    buildOpeningHour("วันจันทร์", "ปิด"),
                    buildOpeningHour("วันอังคาร", "ปิด"),
                    buildOpeningHour("วันพุธ", "ปิด"),
                    buildOpeningHour("วันพฤหัสบดี", "ปิด"),
                    buildOpeningHour("วันศุกร์", "9:00 - 16:00"),
                    buildOpeningHour("วันเสาร์", "9:00 - 16:00"),
                    buildOpeningHour("วันอาทิตย์", "8:00 - 20:00"),
                    location.locationStatus == "In progress"
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: getProportionateScreenWidth(5)),
                                child: TextButton(
                                  onPressed: () {
                                    dashBoardViewModel
                                        .updateLocationStatus(context,
                                            location.locationId, "Deny")
                                        .then((value) {
                                      if (value == 200) {
                                        final snackBar = SnackBar(
                                          backgroundColor:
                                              Palette.secondaryColor,
                                          content: Text(
                                            'ปฏิเสธคำขอสร้างสถานที่ ${location.locationName} แล้ว',
                                            style: const TextStyle(
                                              fontFamily: 'Sukhumvit',
                                              fontSize: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      }
                                    });
                                  },
                                  child: const Text(
                                    "ปฏิเสธ",
                                    style: TextStyle(
                                        color: Palette.deleteColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                ),
                              ),
                              Container(
                                height: getProportionateScreenHeight(48),
                                width: getProportionateScreenWidth(50),
                                margin: EdgeInsets.symmetric(
                                    vertical: getProportionateScreenHeight(25)),
                                child: ElevatedButton(
                                  onPressed: () {
                                    dashBoardViewModel
                                        .updateLocationStatus(context,
                                            location.locationId, "Approved")
                                        .then((value) {
                                      if (value == 200) {
                                        final snackBar = SnackBar(
                                          backgroundColor: Palette.primaryColor,
                                          content: Text(
                                            'อนุมัติคำขอสร้างสถานที่ ${location.locationName} แล้ว',
                                            style: const TextStyle(
                                              fontFamily: 'Sukhumvit',
                                              fontSize: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      }
                                    });
                                  },
                                  child: const Text(
                                    "อนุมัติ",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : location.locationStatus == "Approved"
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    height: getProportionateScreenHeight(48),
                                    width: getProportionateScreenWidth(50),
                                    margin: EdgeInsets.symmetric(
                                        vertical:
                                            getProportionateScreenHeight(25)),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        dashBoardViewModel
                                            .deleteLocation(
                                                context, location.locationId)
                                            .then((value) {
                                          if (value == 200) {
                                            const snackBar = SnackBar(
                                              backgroundColor:
                                                  Palette.primaryColor,
                                              content: Text(
                                                'ลบสถานที่สำเร็จ',
                                                style: TextStyle(
                                                  fontFamily: 'Sukhumvit',
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            );
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);
                                          } else {
                                            const snackBar = SnackBar(
                                              backgroundColor:
                                                  Palette.secondaryColor,
                                              content: Text(
                                                'ลบสถานที่ไม่สำเร็จ',
                                                style: TextStyle(
                                                  fontFamily: 'Sukhumvit',
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            );
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);
                                          }
                                        });
                                      },
                                      child: const Text(
                                        "ลบสถานที่",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        primary: Palette.deleteColor,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : SizedBox(
                                height: getProportionateScreenHeight(25),
                              ),
                  ],
                ),
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

Widget subtitle(String text, String symbol) {
  return Container(
    alignment: Alignment.bottomLeft,
    padding: EdgeInsets.symmetric(
      vertical: getProportionateScreenHeight(15),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          text,
          style: FontAssets.columnText,
        ),
        Text(
          symbol,
          style: FontAssets.requiredField,
        ),
      ],
    ),
  );
}

Widget buildOpeningHour(String day, String openingHour) {
  return Column(
    children: [
      ListTile(
        tileColor: Colors.white,
        title: Row(
          children: [
            Expanded(
              child: Text(
                day,
                style: FontAssets.bodyText,
              ),
            ),
            Expanded(
              child: Text(
                openingHour,
                style: FontAssets.bodyText,
              ),
            ),
          ],
        ),
      ),
      const Divider()
    ],
  );
}
