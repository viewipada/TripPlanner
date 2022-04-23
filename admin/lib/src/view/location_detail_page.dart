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
  // static const route = '/dashboard/location';

  const LocationDetailPage({
    Key? key,
    required this.locationId,
  }) : super(key: key);

  final int locationId;

  @override
  _LocationDetailPageState createState() => _LocationDetailPageState();
}

class _LocationDetailPageState extends State<LocationDetailPage> {
  String? username;
  bool isLoading = false;
  LocationDetailResponse? location;
  String remark = '';
  final textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    SharedPref().getUsername().then((value) {
      setState(() {
        username = value;
      });
    });
    Provider.of<DashBoardViewModel>(context, listen: false)
        .getLocationDetailById(widget.locationId)
        .then((value) {
      setState(() {
        location = value;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final dashBoardViewModel = Provider.of<DashBoardViewModel>(context);

    Future<void> _confirmRemark(BuildContext context) async {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text(
                'หมายเหตุ: ',
                style: FontAssets.subtitleText,
              ),
              content: SizedBox(
                width: SizeConfig.screenWidth / 3,
                height: getProportionateScreenHeight(150),
                child: Form(
                  key: _formKey,
                  child: Expanded(
                    child: TextFormField(
                      maxLines: 100,
                      maxLength: 120,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'โปรดระบุ';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          remark = value;
                        });
                      },
                      controller: textController,
                      decoration: const InputDecoration(
                          isDense: true,
                          hintText:
                              "โปรดระบุเหตุผลในการปฏิเสธคำขอสร้างสถานที่"),
                    ),
                  ),
                ),
              ),
              actions: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      bottom: getProportionateScreenHeight(15),
                      right: getProportionateScreenWidth(5)),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          isLoading = true;
                        });
                        dashBoardViewModel
                            .updateLocationStatus(
                                context, location!.locationId, "Deny", remark)
                            .then((value) {
                          if (value == 200) {
                            final snackBar = SnackBar(
                              backgroundColor: Palette.secondaryColor,
                              content: Text(
                                'ปฏิเสธคำขอสร้างสถานที่ ${location!.locationName} แล้ว',
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
                            setState(() {
                              isLoading = false;
                            });
                            Navigator.pop(context, 'update');
                          }
                        });
                      }
                    },
                    child: const Text(
                      "ยืนยัน",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary:
                          isLoading ? Palette.infoText : Palette.primaryColor,
                    ),
                  ),
                ),
              ],
            );
          });
    }

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
      body: location == null
          ? loading()
          : SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Container(
                margin: EdgeInsets.symmetric(
                    horizontal: SizeConfig.screenWidth / 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      child: Image.network(
                        location!.imageUrl,
                        height: getProportionateScreenHeight(350),
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      clipBehavior: Clip.antiAlias,
                    ),
                    subtitle('ชื่อสถานที่ ', '*'),
                    TextFormField(
                      initialValue: location!.locationName,
                      maxLines: 1,
                      readOnly: true,
                      enabled: false,
                    ),
                    subtitle('หมวดหมู่สถานที่ ', '*'),
                    TextFormField(
                      initialValue: location!.category == 1
                          ? "ที่เที่ยว"
                          : location!.category == 2
                              ? "ที่กิน"
                              : location!.category == 3
                                  ? "ที่พัก"
                                  : "ของฝาก",
                      maxLines: 1,
                      readOnly: true,
                      enabled: false,
                    ),
                    subtitle('ประเภทสถานที่ ', '*'),
                    TextFormField(
                      initialValue: location!.locationType,
                      maxLines: 1,
                      readOnly: true,
                      enabled: false,
                    ),
                    location!.category == 3
                        ? subtitle('ช่วงราคา ', '*')
                        : const SizedBox(),
                    location!.category == 3
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: TextFormField(
                                  initialValue: location!.minPrice.toString(),
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
                                  initialValue: location!.maxPrice.toString(),
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
                      initialValue: location!.province,
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
                            initialValue: location!.latitude.toString(),
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
                            initialValue: location!.longitude.toString(),
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
                        initialValue: location!.description,
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
                      initialValue: location!.contactNumber,
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
                      initialValue: location!.website,
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
                    buildOpeningHour("วันจันทร์", location!.openingHour.mon),
                    buildOpeningHour("วันอังคาร", location!.openingHour.tue),
                    buildOpeningHour("วันพุธ", location!.openingHour.wed),
                    buildOpeningHour("วันพฤหัสบดี", location!.openingHour.thu),
                    buildOpeningHour("วันศุกร์", location!.openingHour.fri),
                    buildOpeningHour("วันเสาร์", location!.openingHour.sat),
                    buildOpeningHour("วันอาทิตย์", location!.openingHour.sun),
                    location!.remark == '-'
                        ? const SizedBox()
                        : subtitle('หมายเหตุ', ''),
                    location!.remark == '-'
                        ? const SizedBox()
                        : TextFormField(
                            initialValue: location!.remark,
                            maxLines: 1,
                            readOnly: true,
                            enabled: false,
                          ),
                    location!.locationStatus == "In progress"
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: getProportionateScreenWidth(5)),
                                child: TextButton(
                                  onPressed: () {
                                    _confirmRemark(context);
                                  },
                                  child: Text(
                                    "ปฏิเสธ",
                                    style: TextStyle(
                                        color: isLoading
                                            ? Palette.infoText
                                            : Palette.deleteColor,
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
                                    setState(() {
                                      isLoading = true;
                                    });
                                    dashBoardViewModel
                                        .updateLocationStatus(
                                            context,
                                            location!.locationId,
                                            "Approved",
                                            remark)
                                        .then((value) {
                                      if (value == 200) {
                                        final snackBar = SnackBar(
                                          backgroundColor: Palette.primaryColor,
                                          content: Text(
                                            'อนุมัติคำขอสร้างสถานที่ ${location!.locationName} แล้ว',
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
                                        setState(() {
                                          isLoading = false;
                                        });
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
                                  style: ElevatedButton.styleFrom(
                                    primary: isLoading
                                        ? Palette.infoText
                                        : Palette.primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : location!.locationStatus == "Approved"
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
                                        setState(() {
                                          isLoading = true;
                                        });
                                        dashBoardViewModel
                                            .deleteLocation(
                                                context, location!.locationId)
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
                                            // setState(() {
                                            //   isLoading = false;
                                            // });
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
                                            // setState(() {
                                            //   isLoading = false;
                                            // });
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
                                        primary: isLoading
                                            ? Palette.infoText
                                            : Palette.deleteColor,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Container(
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.symmetric(
                                    vertical: getProportionateScreenHeight(25)),
                                child: Text(
                                  'สถานที่นี้ถูกปฏิเสธ โดย $username',
                                  style: FontAssets.disableText,
                                ),
                              ),
                  ],
                ),
              ),
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
