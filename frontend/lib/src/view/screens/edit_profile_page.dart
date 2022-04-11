import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/assets.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/size_config.dart';
import 'package:trip_planner/src/view/widgets/loading.dart';
import 'package:trip_planner/src/view_models/profile_view_model.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool isLoading = false;

  @override
  void initState() {
    Provider.of<ProfileViewModel>(context, listen: false).getProfileDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final profileViewModel = Provider.of<ProfileViewModel>(context);

    Future<void> _displayEditGenderDialog(BuildContext context) async {
      String? editGender = profileViewModel.gender;
      return showDialog(
        context: context,
        builder: (BuildContext context) => StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              'เลือกเพศ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Palette.BodyText,
              ),
              textAlign: TextAlign.center,
            ),
            content: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Radio<String>(
                        value: 'ชาย',
                        groupValue: editGender,
                        onChanged: (String? value) {
                          setState(() {
                            editGender = value!;
                          });
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
                        groupValue: editGender,
                        onChanged: (String? value) {
                          setState(() {
                            editGender = value!;
                          });
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
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'ยกเลิก'),
                child: const Text(
                  'ยกเลิก',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, 'ยืนยัน');
                  profileViewModel.setGenderValue(editGender!);
                },
                child: const Text(
                  'ยืนยัน',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                style:
                    TextButton.styleFrom(backgroundColor: Palette.PrimaryColor),
              ),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: TextButton(
            onPressed: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                title: const Text(
                  'ต้องการยกเลิกแก้ไขข้อมูลส่วนตัวหรือไม่',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Palette.BodyText,
                  ),
                  textAlign: TextAlign.center,
                ),
                content: const Text(
                  'หากคุณยกเลิก ข้อมูลที่คุณแก้ไขจะไม่ถูกบันทึก',
                  style: TextStyle(
                    fontSize: 14,
                    color: Palette.AdditionText,
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'ทำต่อ'),
                    child: const Text(
                      'ทำต่อ',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, 'ยกเลิก');
                      profileViewModel.goBack(context);
                    },
                    child: const Text(
                      'ยกเลิก',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Palette.NotificationColor,
                    ),
                  ),
                ],
              ),
            ),
            child: Text("ยกเลิก"),
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(15),
              ),
              alignment: Alignment.centerLeft,
            ),
          ),
          leadingWidth: getProportionateScreenWidth(70),
          title: Text(
            "แก้ไขข้อมูลส่วนตัว",
            style: FontAssets.headingText,
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: SafeArea(
          child: profileViewModel.profileDetailsResponse == null
              ? Loading()
              : Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: getProportionateScreenHeight(35)),
                          child: profileViewModel.profileImage == null
                              ? CircleAvatar(
                                  backgroundImage: NetworkImage(profileViewModel
                                      .profileDetailsResponse!.userImage),
                                  radius: getProportionateScreenHeight(70),
                                )
                              : CircleAvatar(
                                  backgroundImage:
                                      FileImage(profileViewModel.profileImage!),
                                  radius: getProportionateScreenHeight(70),
                                ),
                        ),
                      ),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            showModalBottomSheet(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                              context: context,
                              builder: (BuildContext context) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      height: getProportionateScreenHeight(10),
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.camera_alt_outlined),
                                      title: Text(
                                        'กล้องถ่ายรูป',
                                        style: FontAssets.bodyText,
                                      ),
                                      onTap: () {
                                        Navigator.pop(context);
                                        profileViewModel.pickImageFromSource(
                                            ImageSource.camera);
                                      },
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.photo_outlined),
                                      title: Text(
                                        'คลังรูปภาพ',
                                        style: FontAssets.bodyText,
                                      ),
                                      onTap: () {
                                        Navigator.pop(context);
                                        profileViewModel.pickImageFromSource(
                                            ImageSource.gallery);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Text('อัพโหลดรูปภาพ',
                              style: TextStyle(fontSize: 14)),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: getProportionateScreenHeight(15),
                          horizontal: getProportionateScreenWidth(15),
                        ),
                        child: Text(
                          'ข้อมูลเบื้องต้น',
                          style: FontAssets.titleText,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            tileColor: Colors.white,
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'ชื่อผู้ใช้',
                                  style: FontAssets.subtitleText,
                                ),
                                Text(
                                  profileViewModel.username,
                                  style: FontAssets.bodyText,
                                ),
                              ],
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.white,
                            ),
                          ),
                          Divider(),
                          ListTile(
                            tileColor: Colors.white,
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'วัน/เดือน/ปี เกิด',
                                  style: FontAssets.subtitleText,
                                ),
                                Text(
                                  DateFormat('dd/MM/yyyy').format(
                                      DateTime.parse(
                                          profileViewModel.birthdate)),
                                  style: FontAssets.bodyText,
                                ),
                              ],
                            ),
                            trailing: Icon(
                              Icons.mode_edit_outline_rounded,
                              color: Palette.AdditionText,
                            ),
                            onTap: () => profileViewModel.pickDate(context),
                          ),
                          Divider(),
                          ListTile(
                            tileColor: Colors.white,
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'เพศ',
                                  style: FontAssets.subtitleText,
                                ),
                                Text(
                                  profileViewModel.gender!,
                                  style: FontAssets.bodyText,
                                ),
                              ],
                            ),
                            trailing: Icon(
                              Icons.mode_edit_outline_rounded,
                              color: Palette.AdditionText,
                            ),
                            onTap: () => _displayEditGenderDialog(context),
                          ),
                          Divider(),
                        ],
                      ),
                      Spacer(),
                      Container(
                        width: double.infinity,
                        height: getProportionateScreenHeight(48),
                        margin: EdgeInsets.symmetric(
                            vertical: getProportionateScreenHeight(15),
                            horizontal: getProportionateScreenWidth(15)),
                        child: isLoading
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SpinKitFadingCircle(
                                    color: Palette.PrimaryColor,
                                    size: getProportionateScreenHeight(24),
                                  ),
                                  SizedBox(
                                      width: getProportionateScreenWidth(10)),
                                  const Text(
                                    'กำลังบันทึกการแก้ไข...',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Palette.PrimaryColor,
                                    ),
                                  ),
                                ],
                              )
                            : ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  profileViewModel
                                      .updateUserProfileDetail(context)
                                      .then((value) {
                                    if (value == 201) {
                                      setState(() {
                                        isLoading = false;
                                      });
                                      const snackBar = SnackBar(
                                        backgroundColor: Palette.PrimaryColor,
                                        content: Text(
                                          'แก้ไขข้อมูลส่วนตัวสำเร็จ',
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
                                child: Text(
                                  'บันทึกข้อมูล',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: Palette.PrimaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
