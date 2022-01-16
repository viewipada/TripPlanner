import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/assets.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/size_config.dart';
import 'package:trip_planner/src/view_models/login_view_model.dart';

class PdpaPage extends StatefulWidget {
  @override
  _PdpaPageState createState() => _PdpaPageState();
}

class _PdpaPageState extends State<PdpaPage> {
  final passwordFocusNode = FocusNode();
  final confirmPasswordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final loginViewModel = Provider.of<LoginViewModel>(context);

    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: getProportionateScreenHeight(35)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: getProportionateScreenHeight(50),
                                height: getProportionateScreenHeight(50),
                                margin: EdgeInsets.only(
                                    left: getProportionateScreenWidth(35)),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      spreadRadius: 1,
                                      blurRadius: 3,
                                      offset: Offset(
                                          3, 5), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Container(
                                  margin: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(ImageAssets.logo),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(
                                    right: getProportionateScreenWidth(35),
                                    left: getProportionateScreenWidth(20),
                                  ),
                                  child: Text(
                                    'โปรดระบุข้อมูลเพื่อประสบการณ์ที่\nยอดเยี่ยมสำหรับคุณ',
                                    style: FontAssets.subtitleText,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: getProportionateScreenWidth(15)),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  'วัน/เดือน/ปี เกิด',
                                  style: FontAssets.subtitleText,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: OutlinedButton(
                                  onPressed: () {
                                    loginViewModel.pickDate(context);
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.calendar_today_rounded,
                                      ),
                                      Text(
                                        loginViewModel.startDate,
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                        vertical:
                                            getProportionateScreenHeight(10)),
                                    backgroundColor: Colors.white,
                                    primary: Palette.PrimaryColor,
                                    alignment: Alignment.center,
                                    side:
                                        BorderSide(color: Palette.PrimaryColor),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: getProportionateScreenWidth(15)),
                          margin: EdgeInsets.only(
                              bottom: getProportionateScreenHeight(15)),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'เพศ',
                                  style: FontAssets.subtitleText,
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    Radio<String>(
                                      value: 'ชาย',
                                      groupValue: loginViewModel.gender,
                                      onChanged: (String? value) {
                                        loginViewModel.setGenderValue(value!);
                                      },
                                    ),
                                    Text(
                                      'ชาย',
                                      style: FontAssets.bodyText,
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    Radio<String>(
                                      value: 'หญิง',
                                      groupValue: loginViewModel.gender,
                                      onChanged: (String? value) {
                                        loginViewModel.setGenderValue(value!);
                                      },
                                    ),
                                    Text(
                                      'หญิง',
                                      style: FontAssets.bodyText,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(),
                        Container(
                          margin: EdgeInsets.only(
                              bottom: getProportionateScreenHeight(15)),
                          child: Image(
                            fit: BoxFit.fitWidth,
                            image:
                                Image.asset(ImageAssets.pdpaBackground).image,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: getProportionateScreenWidth(15),
                          ),
                          child: Text(
                            'ความยินยอมเรื่องข้อมูลส่วนบุคคล',
                            style: FontAssets.subtitleText,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: getProportionateScreenWidth(15),
                            vertical: getProportionateScreenHeight(5),
                          ),
                          child: Text(
                            'EZtrip ให้ความสำคัญต่อข้อมูลส่วนบุคคลของคุณ โดยข้อมูลข้างต้นจะนำไปใช้ในการพัฒนาและปรับปรุงระบบแนะนำให้มีประสิทธิภาพยิ่งขึ้น เพื่อให้คุณได้รับประสบการณ์การใช้งานที่ดีและประทับใจ ทั้งนี้ ข้อมูลจะถูกจัดเก็บไว้ในฐานข้อมูลของระบบ โดยไม่มีการเปิดเผยให้ผู้ใช้อื่นเห็นหรือเผยแพร่ออกสู่สาธารณะ',
                            style: FontAssets.bodyText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Checkbox(
                        checkColor: Colors.white,
                        value: loginViewModel.agree,
                        onChanged: (bool? value) {
                          loginViewModel.setAgreeCheckbox(value!);
                        },
                      ),
                      Text(
                        'รับทราบและให้ความยินยอมในการใช้ข้อมูลต่อ EZtrip',
                        style: FontAssets.bodyText,
                      ),
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    height: getProportionateScreenHeight(48),
                    margin: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(15),
                    ),
                    child: ElevatedButton(
                      onPressed: () => loginViewModel.validateData()
                          ? loginViewModel.goToHomePage(context)
                          : null,
                      child: Text(
                        'ยืนยันข้อมูล',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: loginViewModel.validateData()
                            ? Palette.PrimaryColor
                            : Palette.InfoText,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: getProportionateScreenHeight(15)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
