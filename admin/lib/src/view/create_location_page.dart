import 'package:admin/src/assets.dart';
import 'package:admin/src/palette.dart';
import 'package:admin/src/shared_pref.dart';
import 'package:admin/src/size_config.dart';
import 'package:admin/src/view_models/create_location_view_model.dart';
import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CreateLocationPage extends StatefulWidget {
  const CreateLocationPage({Key? key}) : super(key: key);

  @override
  _CreateLocationPageState createState() => _CreateLocationPageState();
}

class _CreateLocationPageState extends State<CreateLocationPage> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
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
    final createLocationViewModel =
        Provider.of<CreateLocationViewModel>(context);

    _showTimeSetting(BuildContext context,
        CreateLocationViewModel createLocationViewModel, day) {
      String _openTime = day['openTime'];
      String _closedTime = day['closedTime'];

      return showDialog<String>(
        context: context,
        builder: (BuildContext context) => StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              'ตั้งเวลา${day['day']}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Palette.bodyText,
              ),
              textAlign: TextAlign.center,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Expanded(
                      flex: 1,
                      child: Text(
                        'เวลาเปิด',
                        style: TextStyle(
                          fontSize: 14,
                          color: Palette.additionText,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: OutlinedButton(
                        onPressed: () {
                          createLocationViewModel
                              .selectTime(context, _openTime)
                              .then((String result) {
                            setState(() {
                              _openTime = result;
                            });
                          });
                        },
                        child: Text(_openTime, style: FontAssets.bodyText),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          alignment: Alignment.center,
                          side:
                              const BorderSide(color: Palette.borderInputColor),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: getProportionateScreenHeight(15),
                ),
                Row(
                  children: [
                    const Expanded(
                      flex: 1,
                      child: Text(
                        'เวลาปิด',
                        style: TextStyle(
                          fontSize: 14,
                          color: Palette.additionText,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: OutlinedButton(
                        onPressed: () {
                          createLocationViewModel
                              .selectTime(context, _closedTime)
                              .then((String result) {
                            setState(() {
                              _closedTime = result;
                            });
                          });
                        },
                        child: Text(_closedTime, style: FontAssets.bodyText),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          alignment: Alignment.center,
                          side:
                              const BorderSide(color: Palette.borderInputColor),
                        ),
                      ),
                    ),
                  ],
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
                  Navigator.pop(context, 'บันทึก');
                  createLocationViewModel.updateOpeningHour(
                      day, _openTime, _closedTime);
                },
                child: const Text(
                  'บันทึก',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                style:
                    TextButton.styleFrom(backgroundColor: Palette.primaryColor),
              ),
            ],
          ),
        ),
      );
    }

    return WillPopScope(
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          // appBar: AppBar(
          //   leading: TextButton(
          //     onPressed: () => showDialog<String>(
          //       context: context,
          //       builder: (BuildContext context) => AlertDialog(
          //         shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(16),
          //         ),
          //         title: const Text(
          //           'ต้องการยกเลิกสร้างสถานที่หรือไม่',
          //           style: TextStyle(
          //             fontWeight: FontWeight.bold,
          //             fontSize: 14,
          //             color: Palette.bodyText,
          //           ),
          //           textAlign: TextAlign.center,
          //         ),
          //         content: const Text(
          //           'หากคุณยกเลิก ข้อมูลสร้างสถานที่นี้จะไม่ถูกบันทึก',
          //           style: TextStyle(
          //             fontSize: 14,
          //             color: Palette.additionText,
          //           ),
          //         ),
          //         actions: <Widget>[
          //           TextButton(
          //             onPressed: () => Navigator.pop(context, 'ทำต่อ'),
          //             child: const Text(
          //               'ทำต่อ',
          //               style: TextStyle(
          //                 fontSize: 14,
          //               ),
          //             ),
          //           ),
          //           TextButton(
          //             onPressed: () {
          //               Navigator.pop(context, 'ทำต่อ');
          //               createLocationViewModel.goBack(context);
          //             },
          //             child: const Text(
          //               'ยกเลิกสร้างสถานที่',
          //               style: TextStyle(
          //                 fontSize: 14,
          //                 color: Colors.white,
          //               ),
          //             ),
          //             style: TextButton.styleFrom(
          //               backgroundColor: Palette.notificationColor,
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //     child: const Text("ยกเลิก"),
          //     style: TextButton.styleFrom(
          //       padding: EdgeInsets.symmetric(
          //         horizontal: getProportionateScreenWidth(15),
          //       ),
          //       alignment: Alignment.centerLeft,
          //     ),
          //   ),
          //   // leadingWidth: getProportionateScreenWidth(70),
          //   title: const Text(
          //     "สร้างสถานที่",
          //     style: FontAssets.headingText,
          //   ),
          //   centerTitle: true,
          //   backgroundColor: Colors.white,
          // ),
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
                    onPressed: () => createLocationViewModel.logout(context),
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
          body: SafeArea(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Container(
                margin: EdgeInsets.symmetric(
                    horizontal: SizeConfig.screenWidth / 4),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: getProportionateScreenHeight(25),
                      ),
                      const Text(
                        'สร้างสถานที่',
                        style: FontAssets.subtitleText,
                      ),
                      subtitle('ชื่อสถานที่ ', '*'),
                      TextFormField(
                        maxLines: 1,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'โปรดระบุ';
                          }
                          return null;
                        },
                        onChanged: (value) => createLocationViewModel
                            .updateLocationName(value.trim()),
                      ),
                      subtitle('หมวดหมู่สถานที่ ', '*'),
                      CoolDropdown(
                        dropdownList: createLocationViewModel.locationCategory,
                        placeholder: 'กรุณาเลือก',
                        dropdownHeight: 220,
                        dropdownItemGap: 0,
                        dropdownWidth: (SizeConfig.screenWidth / 2) -
                            getProportionateScreenWidth(5),
                        resultWidth: SizeConfig.screenWidth / 2,
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
                        placeholderTS: const TextStyle(
                          color: Palette.infoText,
                          fontSize: 14,
                          fontFamily: 'Sukhumvit',
                        ),
                        onChange: (selectedItem) {
                          createLocationViewModel
                              .getLocationTypeList(selectedItem['value']);
                          createLocationViewModel.updateLocationCategoryValue(
                              selectedItem['label']);
                        },
                        resultPadding: const EdgeInsets.symmetric(
                          horizontal: 15,
                        ),
                        resultHeight: getProportionateScreenHeight(60),
                        resultBD: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          border: Border(
                            top: BorderSide(
                                color: createLocationViewModel
                                        .locationCategoryValid
                                    ? Palette.borderInputColor
                                    : Colors.red),
                            bottom: BorderSide(
                                color: createLocationViewModel
                                        .locationCategoryValid
                                    ? Palette.borderInputColor
                                    : Colors.red),
                            left: BorderSide(
                                color: createLocationViewModel
                                        .locationCategoryValid
                                    ? Palette.borderInputColor
                                    : Colors.red),
                            right: BorderSide(
                                color: createLocationViewModel
                                        .locationCategoryValid
                                    ? Palette.borderInputColor
                                    : Colors.red),
                          ),
                        ),
                      ),
                      subtitle('ประเภทสถานที่ ', '*'),
                      createLocationViewModel.locationType.isNotEmpty
                          ? IgnorePointer(
                              ignoring:
                                  createLocationViewModel.locationType.isEmpty,
                              child: CoolDropdown(
                                dropdownList:
                                    createLocationViewModel.locationType,
                                placeholder: 'กรุณาเลือก',
                                dropdownHeight: createLocationViewModel
                                            .locationCategoryValue ==
                                        "ของฝาก"
                                    ? 120
                                    : 170,
                                dropdownItemGap: 0,
                                dropdownWidth: (SizeConfig.screenWidth / 2) -
                                    getProportionateScreenWidth(5),
                                resultWidth: SizeConfig.screenWidth / 2,
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
                                placeholderTS: const TextStyle(
                                  color: Palette.infoText,
                                  fontSize: 14,
                                  fontFamily: 'Sukhumvit',
                                ),
                                onChange: (selectedItem) {
                                  createLocationViewModel
                                      .updateLocationTypeValue(
                                          selectedItem['label']);
                                },
                                resultPadding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                ),
                                resultHeight: getProportionateScreenHeight(60),
                                resultBD: BoxDecoration(
                                  color: createLocationViewModel
                                          .locationType.isEmpty
                                      ? Palette.borderInputColor
                                      : Colors.white,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  border: Border(
                                    top: BorderSide(
                                        color: createLocationViewModel
                                                .locationTypeValid
                                            ? Palette.borderInputColor
                                            : Colors.red),
                                    bottom: BorderSide(
                                        color: createLocationViewModel
                                                .locationTypeValid
                                            ? Palette.borderInputColor
                                            : Colors.red),
                                    left: BorderSide(
                                        color: createLocationViewModel
                                                .locationTypeValid
                                            ? Palette.borderInputColor
                                            : Colors.red),
                                    right: BorderSide(
                                        color: createLocationViewModel
                                                .locationTypeValid
                                            ? Palette.borderInputColor
                                            : Colors.red),
                                  ),
                                ),
                              ),
                            )
                          : IgnorePointer(
                              ignoring:
                                  createLocationViewModel.locationType.isEmpty,
                              child: const TextField(
                                decoration: InputDecoration(
                                  hintText: 'กรุณาเลือก',
                                  filled: true,
                                  fillColor: Palette.borderInputColor,
                                ),
                                enabled: false,
                              ),
                            ),
                      createLocationViewModel.locationCategoryValue == 'ที่พัก'
                          ? subtitle('ช่วงราคา ', '*')
                          : const SizedBox(),
                      createLocationViewModel.locationCategoryValue == 'ที่พัก'
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    enabled: createLocationViewModel
                                            .locationCategoryValue ==
                                        "ที่พัก",
                                    maxLines: 1,
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'โปรดระบุ';
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                        hintText: "ต่ำสุด"),
                                    onChanged: (value) =>
                                        createLocationViewModel
                                            .updateMinPrice(value.trim()),
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
                                    enabled: createLocationViewModel
                                            .locationCategoryValue ==
                                        "ที่พัก",
                                    maxLines: 1,
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'โปรดระบุ';
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                        hintText: "สูงสุด"),
                                    onChanged: (value) =>
                                        createLocationViewModel
                                            .updateMaxPrice(value.trim()),
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox(),
                      subtitle('จังหวัด ', '*'),
                      CoolDropdown(
                        dropdownList: createLocationViewModel.provinceList,
                        placeholder: 'กรุณาเลือก',
                        dropdownHeight: 70,
                        dropdownItemGap: 0,
                        dropdownWidth: (SizeConfig.screenWidth / 2) -
                            getProportionateScreenWidth(5),
                        resultWidth: SizeConfig.screenWidth / 2,
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
                        placeholderTS: const TextStyle(
                          color: Palette.infoText,
                          fontSize: 14,
                          fontFamily: 'Sukhumvit',
                        ),
                        onChange: (selectedItem) {
                          createLocationViewModel
                              .updateProvinceValue(selectedItem);
                        },
                        resultPadding: const EdgeInsets.symmetric(
                          horizontal: 15,
                        ),
                        resultHeight: getProportionateScreenHeight(60),
                        resultBD: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          border: Border(
                            top: BorderSide(
                                color: createLocationViewModel.provinceValid
                                    ? Palette.borderInputColor
                                    : Colors.red),
                            bottom: BorderSide(
                                color: createLocationViewModel.provinceValid
                                    ? Palette.borderInputColor
                                    : Colors.red),
                            left: BorderSide(
                                color: createLocationViewModel.provinceValid
                                    ? Palette.borderInputColor
                                    : Colors.red),
                            right: BorderSide(
                                color: createLocationViewModel.provinceValid
                                    ? Palette.borderInputColor
                                    : Colors.red),
                          ),
                        ),
                      ),
                      subtitle('ตำแหน่งบนแผนที่ ', '*'),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: TextFormField(
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d*\.?\d{0,14}')),
                              ],
                              maxLines: 1,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'โปรดระบุ';
                                }
                                return null;
                              },
                              decoration:
                                  const InputDecoration(hintText: "latitude"),
                              onChanged: (value) => createLocationViewModel
                                  .updateLatitude(value.trim()),
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
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d*\.?\d{0,14}')),
                              ],
                              maxLines: 1,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'โปรดระบุ';
                                }
                                return null;
                              },
                              decoration:
                                  const InputDecoration(hintText: "longitude"),
                              onChanged: (value) => createLocationViewModel
                                  .updateLongitude(value.trim()),
                            ),
                          ),
                        ],
                      ),
                      subtitle('เขียนแนะนำสถานที่เบื้องต้น ', '*'),
                      SizedBox(
                        height: getProportionateScreenHeight(300),
                        child: TextFormField(
                          maxLines: 100,
                          maxLength: 300,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'โปรดระบุ';
                            }
                            return null;
                          },
                          onChanged: (value) => createLocationViewModel
                              .updateDescription(value.trim()),
                        ),
                      ),
                      subtitle('เบอร์ติดต่อ', ''),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        maxLines: 1,
                        maxLength: 10,
                        onChanged: (value) => createLocationViewModel
                            .updateContactNumber(value.trim()),
                      ),
                      subtitle('เว็บไซต์, Facebook', ''),
                      TextFormField(
                        maxLines: 1,
                        onChanged: (value) =>
                            createLocationViewModel.updateWebsite(value.trim()),
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
                        height: getProportionateScreenHeight(10),
                      ),
                      Row(
                        // mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Expanded(
                            child: Row(
                              children: [
                                Radio<bool>(
                                  value: true,
                                  groupValue:
                                      createLocationViewModel.knowOpeningHour,
                                  onChanged: (bool? value) {
                                    createLocationViewModel
                                        .setKnowOpeningHourValue(value);
                                  },
                                ),
                                const Text(
                                  'ทราบ',
                                  style: FontAssets.subtitleText,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Radio<bool>(
                                  value: false,
                                  groupValue:
                                      createLocationViewModel.knowOpeningHour,
                                  onChanged: (bool? value) {
                                    createLocationViewModel
                                        .setKnowOpeningHourValue(value);
                                  },
                                ),
                                const Text(
                                  'ไม่ทราบ',
                                  style: FontAssets.subtitleText,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: getProportionateScreenHeight(10),
                      ),
                      Visibility(
                        visible: createLocationViewModel.knowOpeningHour!,
                        child: Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Checkbox(
                                    checkColor: Colors.white,
                                    value:
                                        createLocationViewModel.openingEveryday,
                                    onChanged: (bool? value) {
                                      createLocationViewModel
                                          .setOpeningEveryday(value!);
                                    },
                                  ),
                                  const Text(
                                    'เปิดทุกวัน',
                                    style: FontAssets.subtitleText,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: getProportionateScreenHeight(15),
                      ),
                      Visibility(
                        visible: createLocationViewModel.knowOpeningHour!,
                        child: Column(
                          children: createLocationViewModel.dayOfWeek
                              .map(
                                (day) => Column(
                                  children: [
                                    SwitchListTile(
                                        title: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                day['day'],
                                                style: FontAssets.bodyText,
                                              ),
                                            ),
                                            Expanded(
                                              child: day['isOpening']
                                                  ? Row(
                                                      children: [
                                                        Text(
                                                          '${day['openTime']} - ${day['closedTime']}',
                                                          style: FontAssets
                                                              .bodyText,
                                                        ),
                                                        IconButton(
                                                          icon: const Icon(
                                                            Icons
                                                                .mode_edit_outline_outlined,
                                                            color: Palette
                                                                .primaryColor,
                                                          ),
                                                          onPressed: () {
                                                            _showTimeSetting(
                                                              context,
                                                              createLocationViewModel,
                                                              day,
                                                            );
                                                          },
                                                        ),
                                                      ],
                                                    )
                                                  : const Text(
                                                      'ปิด',
                                                      style:
                                                          FontAssets.bodyText,
                                                    ),
                                            ),
                                          ],
                                        ),
                                        tileColor: Colors.white,
                                        value: day['isOpening'],
                                        onChanged: (bool value) =>
                                            createLocationViewModel
                                                .switchIsOpening(day, value)),
                                    const Divider(),
                                  ],
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      subtitle('รูปภาพ ', '*'),
                      createLocationViewModel.fileBytes != null
                          ? InkWell(
                              onTap: () => createLocationViewModel.pickImage(),
                              // onLongPress: () => showDialog(
                              //   context: context,
                              //   builder: (_) => Dialog(
                              //     backgroundColor: Colors.transparent,
                              //     child: ClipRRect(
                              //       borderRadius: BorderRadius.circular(15),
                              //       child: Image.file(
                              //         createLocationViewModel.images!,
                              //         fit: BoxFit.cover,
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              child: Card(
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                child: Image.memory(
                                  createLocationViewModel.fileBytes!,
                                  height: getProportionateScreenHeight(350),
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                                clipBehavior: Clip.antiAlias,
                              ),
                            )
                          : SizedBox(
                              height: getProportionateScreenHeight(350),
                              width: double.infinity,
                              child: OutlinedButton(
                                onPressed: () {
                                  createLocationViewModel.pickImage();
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(
                                          getProportionateScreenHeight(5)),
                                      child: const Icon(
                                        Icons.add_photo_alternate_rounded,
                                        size: 36,
                                      ),
                                    ),
                                    const Text(
                                      ' อัปโหลดรูปภาพ',
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  primary: Palette.infoText,
                                  alignment: Alignment.center,
                                  side: const BorderSide(
                                      color: Palette.borderInputColor),
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                ),
                              ),
                            ),
                      Container(
                        margin: EdgeInsets.symmetric(
                          vertical: getProportionateScreenHeight(15),
                        ),
                        height: getProportionateScreenHeight(48),
                        width: double.infinity,
                        child: isLoading
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SpinKitFadingCircle(
                                    color: Palette.primaryColor,
                                    size: getProportionateScreenHeight(24),
                                  ),
                                  SizedBox(
                                      width: getProportionateScreenWidth(10)),
                                  const Text(
                                    'กำลังสร้างสถานที่...',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Palette.primaryColor,
                                    ),
                                  ),
                                ],
                              )
                            : ElevatedButton(
                                onPressed: () {
                                  bool dropdownValid = createLocationViewModel
                                      .validateDropdown();
                                  if (_formKey.currentState!.validate() &&
                                      dropdownValid) {
                                    bool openingHourValid =
                                        createLocationViewModel
                                            .validateOpeningHour();
                                    if (createLocationViewModel
                                            .knowOpeningHour! &&
                                        !openingHourValid) {
                                      alertDialog(
                                          context, 'กรุณาระบุวันเวลาทำการ');
                                    } else if (createLocationViewModel
                                            .fileBytes ==
                                        null) {
                                      alertDialog(
                                          context, 'กรุณาเพิ่มรูปภาพสถานที่');
                                    } else {
                                      showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          content: SizedBox(
                                            width: SizeConfig.screenWidth / 2,
                                            height: SizeConfig.screenHeight -
                                                SizeConfig.screenHeight / 3,
                                            child: SingleChildScrollView(
                                              child: Column(
                                                children: [
                                                  Card(
                                                    shape: const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10.0))),
                                                    child: Image.memory(
                                                      createLocationViewModel
                                                          .fileBytes!,
                                                      height:
                                                          getProportionateScreenHeight(
                                                              350),
                                                      width: double.infinity,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    clipBehavior:
                                                        Clip.antiAlias,
                                                  ),
                                                  SizedBox(
                                                    height:
                                                        getProportionateScreenHeight(
                                                            25),
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Expanded(
                                                        child: Text(
                                                          'ชื่อสถานที่',
                                                          style: FontAssets
                                                              .columnText,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          createLocationViewModel
                                                              .locationName,
                                                          style: FontAssets
                                                              .bodyText,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Expanded(
                                                        child: Text(
                                                          'หมวดหมู่สถานที่',
                                                          style: FontAssets
                                                              .columnText,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          createLocationViewModel
                                                              .locationCategoryValue!,
                                                          style: FontAssets
                                                              .bodyText,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Expanded(
                                                        child: Text(
                                                          'ประเภทสถานที่',
                                                          style: FontAssets
                                                              .columnText,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          createLocationViewModel
                                                              .locationTypeValue!,
                                                          style: FontAssets
                                                              .bodyText,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Expanded(
                                                        child: Text(
                                                          'จังหวัด',
                                                          style: FontAssets
                                                              .columnText,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          createLocationViewModel
                                                              .provinceValue!,
                                                          style: FontAssets
                                                              .bodyText,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Expanded(
                                                        child: Text(
                                                          'ตำแหน่งบนแผนที่',
                                                          style: FontAssets
                                                              .columnText,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          '${createLocationViewModel.latitude}, ${createLocationViewModel.longitude}',
                                                          style: FontAssets
                                                              .bodyText,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Expanded(
                                                        child: Text(
                                                          'เขียนแนะนำสถานที่เบื้องต้น',
                                                          style: FontAssets
                                                              .columnText,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          createLocationViewModel
                                                              .description,
                                                          style: FontAssets
                                                              .bodyText,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Expanded(
                                                        child: Text(
                                                          'เบอร์ติดต่อ',
                                                          style: FontAssets
                                                              .columnText,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          createLocationViewModel
                                                                      .contactNumber ==
                                                                  ''
                                                              ? '-'
                                                              : createLocationViewModel
                                                                  .contactNumber,
                                                          style: FontAssets
                                                              .bodyText,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Expanded(
                                                        child: Text(
                                                          'เว็บไซต์, Facebook',
                                                          style: FontAssets
                                                              .columnText,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          createLocationViewModel
                                                                      .website ==
                                                                  ''
                                                              ? '-'
                                                              : createLocationViewModel
                                                                  .website,
                                                          style: FontAssets
                                                              .bodyText,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Expanded(
                                                        child: Text(
                                                          'วันเวลาทำการ',
                                                          style: FontAssets
                                                              .columnText,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: createLocationViewModel
                                                                .dayOfWeek
                                                                .every((element) =>
                                                                    element[
                                                                        'isOpening'] ==
                                                                    false)
                                                            ? const Text(
                                                                '-',
                                                                style: FontAssets
                                                                    .bodyText,
                                                              )
                                                            : Column(
                                                                children: createLocationViewModel
                                                                    .dayOfWeek
                                                                    .map(
                                                                        (day) =>
                                                                            Row(
                                                                              children: [
                                                                                Expanded(
                                                                                  child: Text(
                                                                                    day['day'],
                                                                                    style: FontAssets.bodyText,
                                                                                  ),
                                                                                ),
                                                                                Expanded(
                                                                                  child: Text(
                                                                                    day['isOpening'] ? '${day['openTime']} - ${day['closedTime']}' : 'ปิด',
                                                                                    style: FontAssets.bodyText,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ))
                                                                    .toList(),
                                                              ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          actions: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.only(
                                                bottom:
                                                    getProportionateScreenHeight(
                                                        15),
                                              ),
                                              child: TextButton(
                                                onPressed: () => isLoading
                                                    ? null
                                                    : Navigator.pop(
                                                        context, 'ยกเลิก'),
                                                child: const Text(
                                                  'ยกเลิก',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  bottom:
                                                      getProportionateScreenHeight(
                                                          15),
                                                  right:
                                                      getProportionateScreenWidth(
                                                          5)),
                                              child: TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    isLoading = true;
                                                  });
                                                  createLocationViewModel
                                                      .createLocation(context)
                                                      .then((value) {
                                                    if (value == 201) {
                                                      setState(() {
                                                        isLoading = false;
                                                      });
                                                      const snackBar = SnackBar(
                                                        backgroundColor: Palette
                                                            .primaryColor,
                                                        content: Text(
                                                          'สร้างสถานที่สำเร็จ',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Sukhumvit',
                                                            fontSize: 14,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      );
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              snackBar);
                                                    }
                                                    Navigator.pop(
                                                        context, 'ยืนยัน');
                                                  });
                                                },
                                                child: const Text(
                                                  'ยืนยัน',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                style: TextButton.styleFrom(
                                                  backgroundColor: isLoading
                                                      ? Palette.infoText
                                                      : Palette.primaryColor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  } else {
                                    alertDialog(context,
                                        'กรุณาระบุข้อมูลที่จำเป็นให้ครบ');
                                  }
                                },
                                child: const Text(
                                  'สร้างสถานที่',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: Palette.primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ),
                      ),
                      SizedBox(
                        height: getProportionateScreenHeight(25),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      onWillPop: () async {
        createLocationViewModel.clear();
        return true;
      },
    );
  }
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

alertDialog(BuildContext context, String title) {
  return showDialog<String>(
    context: context,
    builder: (BuildContext _context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Palette.bodyText,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
      contentPadding: EdgeInsets.zero,
      actionsAlignment: MainAxisAlignment.center,
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(
            _context,
          ),
          child: const Text(
            'โอเค!',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}
