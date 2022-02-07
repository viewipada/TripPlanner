import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/assets.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/size_config.dart';
import 'package:trip_planner/src/view_models/create_location_view_model.dart';

class CreateLocationPage extends StatefulWidget {
  @override
  _CreateLocationPageState createState() => _CreateLocationPageState();
}

class _CreateLocationPageState extends State<CreateLocationPage> {
  final _formKey = GlobalKey<FormState>();

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
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Palette.BodyText,
              ),
              textAlign: TextAlign.center,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        'เวลาเปิด',
                        style: TextStyle(
                          fontSize: 14,
                          color: Palette.AdditionText,
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
                          side: BorderSide(color: Palette.BorderInputColor),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        'เวลาปิด',
                        style: TextStyle(
                          fontSize: 14,
                          color: Palette.AdditionText,
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
                          side: BorderSide(color: Palette.BorderInputColor),
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
        appBar: AppBar(
          leading: TextButton(
            onPressed: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                title: const Text(
                  'ต้องการยกเลิกสร้างสถานที่หรือไม่',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Palette.BodyText,
                  ),
                  textAlign: TextAlign.center,
                ),
                content: const Text(
                  'หากคุณยกเลิก ข้อมูลสร้างสถานที่นี้จะไม่ถูกบันทึก',
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
                      Navigator.pop(context, 'ทำต่อ');
                      createLocationViewModel.goBack(context);
                    },
                    child: const Text(
                      'ยกเลิกสร้างสถานที่',
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
            "สร้างสถานที่",
            style: FontAssets.headingText,
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            // keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Container(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Subtitle('ชื่อสถานที่ ', '*'),
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(15),
                      ),
                      child: TextFormField(
                        maxLines: 1,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'โปรดระบุ';
                          }
                          return null;
                        },
                        // onChanged: (value) => _caption = value.trim(),
                      ),
                    ),
                    Subtitle('หมวดหมู่สถานที่ ', '*'),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenWidth(15)),
                      child: CoolDropdown(
                        dropdownList: createLocationViewModel.locationCategory,
                        placeholder: 'กรุณาเลือก',
                        dropdownHeight: 170,
                        dropdownItemGap: 0,
                        dropdownWidth: SizeConfig.screenWidth -
                            getProportionateScreenWidth(50),
                        resultWidth: SizeConfig.screenWidth,
                        triangleHeight: 0,
                        gap: getProportionateScreenHeight(5),
                        resultTS: TextStyle(
                          color: Palette.AdditionText,
                          fontSize: 14,
                          fontFamily: 'Sukhumvit',
                        ),
                        selectedItemTS: TextStyle(
                          color: Palette.PrimaryColor,
                          fontSize: 14,
                          fontFamily: 'Sukhumvit',
                        ),
                        unselectedItemTS: TextStyle(
                          color: Palette.BodyText,
                          fontSize: 14,
                          fontFamily: 'Sukhumvit',
                        ),
                        placeholderTS: TextStyle(
                          color: Palette.InfoText,
                          fontSize: 14,
                          fontFamily: 'Sukhumvit',
                        ),
                        onChange: (selectedItem) {
                          createLocationViewModel
                              .getLocationTypeList(selectedItem['value']);
                          createLocationViewModel.updateLocationCategoryValue(
                              selectedItem['label']);
                        },
                        resultBD: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border(
                            top: BorderSide(
                                color: createLocationViewModel
                                        .locationCategoryValid
                                    ? Palette.BorderInputColor
                                    : Colors.red),
                            bottom: BorderSide(
                                color: createLocationViewModel
                                        .locationCategoryValid
                                    ? Palette.BorderInputColor
                                    : Colors.red),
                            left: BorderSide(
                                color: createLocationViewModel
                                        .locationCategoryValid
                                    ? Palette.BorderInputColor
                                    : Colors.red),
                            right: BorderSide(
                                color: createLocationViewModel
                                        .locationCategoryValid
                                    ? Palette.BorderInputColor
                                    : Colors.red),
                          ),
                        ),
                      ),
                    ),
                    Subtitle('ประเภทสถานที่ ', '*'),
                    IgnorePointer(
                      ignoring: createLocationViewModel.locationType.isEmpty,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: getProportionateScreenWidth(15)),
                        child: CoolDropdown(
                          dropdownList: createLocationViewModel.locationType,
                          placeholder: 'กรุณาเลือก',
                          dropdownHeight: 170,
                          dropdownItemGap: 0,
                          dropdownWidth: SizeConfig.screenWidth -
                              getProportionateScreenWidth(50),
                          resultWidth: SizeConfig.screenWidth,
                          triangleHeight: 0,
                          gap: getProportionateScreenHeight(5),
                          resultTS: TextStyle(
                            color: Palette.AdditionText,
                            fontSize: 14,
                            fontFamily: 'Sukhumvit',
                          ),
                          selectedItemTS: TextStyle(
                            color: Palette.PrimaryColor,
                            fontSize: 14,
                            fontFamily: 'Sukhumvit',
                          ),
                          unselectedItemTS: TextStyle(
                            color: Palette.BodyText,
                            fontSize: 14,
                            fontFamily: 'Sukhumvit',
                          ),
                          placeholderTS: TextStyle(
                            color: Palette.InfoText,
                            fontSize: 14,
                            fontFamily: 'Sukhumvit',
                          ),
                          onChange: (selectedItem) {
                            createLocationViewModel
                                .updateLocationTypeValue(selectedItem['label']);
                          },
                          resultBD: BoxDecoration(
                            color: createLocationViewModel.locationType.isEmpty
                                ? Palette.BorderInputColor
                                : Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            border: Border(
                              top: BorderSide(
                                  color:
                                      createLocationViewModel.locationTypeValid
                                          ? Palette.BorderInputColor
                                          : Colors.red),
                              bottom: BorderSide(
                                  color:
                                      createLocationViewModel.locationTypeValid
                                          ? Palette.BorderInputColor
                                          : Colors.red),
                              left: BorderSide(
                                  color:
                                      createLocationViewModel.locationTypeValid
                                          ? Palette.BorderInputColor
                                          : Colors.red),
                              right: BorderSide(
                                  color:
                                      createLocationViewModel.locationTypeValid
                                          ? Palette.BorderInputColor
                                          : Colors.red),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Subtitle('จังหวัด ', '*'),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenWidth(15)),
                      child: CoolDropdown(
                        dropdownList: createLocationViewModel.provinceList,
                        placeholder: 'กรุณาเลือก',
                        dropdownHeight: 70,
                        dropdownItemGap: 0,
                        dropdownWidth: SizeConfig.screenWidth -
                            getProportionateScreenWidth(50),
                        resultWidth: SizeConfig.screenWidth,
                        triangleHeight: 0,
                        gap: getProportionateScreenHeight(5),
                        resultTS: TextStyle(
                          color: Palette.AdditionText,
                          fontSize: 14,
                          fontFamily: 'Sukhumvit',
                        ),
                        selectedItemTS: TextStyle(
                          color: Palette.PrimaryColor,
                          fontSize: 14,
                          fontFamily: 'Sukhumvit',
                        ),
                        unselectedItemTS: TextStyle(
                          color: Palette.BodyText,
                          fontSize: 14,
                          fontFamily: 'Sukhumvit',
                        ),
                        placeholderTS: TextStyle(
                          color: Palette.InfoText,
                          fontSize: 14,
                          fontFamily: 'Sukhumvit',
                        ),
                        onChange: (selectedItem) {
                          createLocationViewModel
                              .updateProvinceValue(selectedItem);
                        },
                        resultBD: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border(
                            top: BorderSide(
                                color: createLocationViewModel.provinceValid
                                    ? Palette.BorderInputColor
                                    : Colors.red),
                            bottom: BorderSide(
                                color: createLocationViewModel.provinceValid
                                    ? Palette.BorderInputColor
                                    : Colors.red),
                            left: BorderSide(
                                color: createLocationViewModel.provinceValid
                                    ? Palette.BorderInputColor
                                    : Colors.red),
                            right: BorderSide(
                                color: createLocationViewModel.provinceValid
                                    ? Palette.BorderInputColor
                                    : Colors.red),
                          ),
                        ),
                      ),
                    ),
                    Subtitle('ตำแหน่งบนแผนที่ ', '*'),
                    IgnorePointer(
                      ignoring: createLocationViewModel.provinceLatLng == null,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenWidth(15),
                          // vertical: getProportionateScreenHeight(10),
                        ),
                        child: TextButton.icon(
                          style: TextButton.styleFrom(
                            primary: Palette.SecondaryColor,
                            padding: EdgeInsets.symmetric(
                                vertical: getProportionateScreenHeight(12)),
                            backgroundColor:
                                createLocationViewModel.provinceLatLng == null
                                    ? Palette.BorderInputColor
                                    : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(
                                  color:
                                      createLocationViewModel.locationPinValid
                                          ? Palette.BorderInputColor
                                          : Colors.red),
                            ),
                          ),
                          onPressed: () => createLocationViewModel
                                      .locationPin ==
                                  null
                              ? createLocationViewModel.goToLocationPickerPage(
                                  context,
                                  createLocationViewModel.provinceLatLng!)
                              : createLocationViewModel.goToLocationPickerPage(
                                  context,
                                  createLocationViewModel.locationPin!),
                          icon: Icon(
                            createLocationViewModel.locationPin == null
                                ? Icons.not_listed_location_outlined
                                : Icons.location_on_rounded,
                            color: createLocationViewModel.locationPin == null
                                ? Palette.InfoText
                                : Palette.SecondaryColor,
                            size: 30,
                          ),
                          label: Text(
                            createLocationViewModel.locationPin == null
                                ? 'แตะเพื่อกำหนดตำแหน่งสถานที่'
                                : 'กำหนดตำแหน่งสถานที่แล้ว',
                            style: TextStyle(
                              fontSize: 14,
                              color: createLocationViewModel.locationPin == null
                                  ? Palette.InfoText
                                  : Palette.SecondaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Subtitle('เขียนแนะนำสถานที่เบื้องต้น ', '*'),
                    Container(
                      height: getProportionateScreenHeight(150),
                      margin: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(15),
                      ),
                      child: TextFormField(
                        maxLines: 100,
                        maxLength: 360,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'โปรดระบุ';
                          }
                          return null;
                        },
                        // onChanged: (value) => _caption = value.trim(),
                      ),
                    ),
                    Subtitle('เบอร์ติดต่อ', ''),
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(15),
                      ),
                      child: TextFormField(
                        maxLines: 1,
                        // onChanged: (value) => _caption = value.trim(),
                      ),
                    ),
                    Subtitle('เว็บไซต์, Facebook', ''),
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(15),
                      ),
                      child: TextFormField(
                        maxLines: 1,
                        // onChanged: (value) => _caption = value.trim(),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomLeft,
                      padding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenWidth(15)),
                      margin: EdgeInsets.only(
                          top: getProportionateScreenHeight(15)),
                      child: Text(
                        'วันเวลาทำการ',
                        style: FontAssets.subtitleText,
                      ),
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
                              Text(
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
                              Text(
                                'ไม่ทราบ',
                                style: FontAssets.subtitleText,
                              ),
                            ],
                          ),
                        ),
                      ],
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
                                Text(
                                  'เปิดทุกวัน',
                                  style: FontAssets.subtitleText,
                                ),
                              ],
                            ),
                          ),
                          // Expanded(
                          //   child: Row(
                          //     children: [
                          //       Checkbox(
                          //         checkColor: Colors.white,
                          //         value: createLocationViewModel.isSameHour,
                          //         onChanged: (bool? value) {
                          //           createLocationViewModel
                          //               .setIsSameHour(value!);
                          //         },
                          //       ),
                          //       Text(
                          //         'เปิดเวลาเดียวกัน',
                          //         style: FontAssets.subtitleText,
                          //       ),
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
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
                                                        style:
                                                            FontAssets.bodyText,
                                                      ),
                                                      IconButton(
                                                        icon: Icon(
                                                          Icons
                                                              .mode_edit_outline_outlined,
                                                          color: Palette
                                                              .PrimaryColor,
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
                                                : Text(
                                                    'ปิด',
                                                    style: FontAssets.bodyText,
                                                  ),
                                          ),
                                        ],
                                      ),
                                      tileColor: Colors.white,
                                      value: day['isOpening'],
                                      onChanged: (bool value) =>
                                          createLocationViewModel
                                              .switchIsOpening(day, value)),
                                  Divider(),
                                ],
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    Subtitle('รูปภาพ', ''),
                    createLocationViewModel.images != null
                        ? InkWell(
                            onTap: () => createLocationViewModel
                                .pickImageFromSource(ImageSource.gallery),
                            onLongPress: () => showDialog(
                              context: context,
                              builder: (_) => Dialog(
                                backgroundColor: Colors.transparent,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.file(
                                    createLocationViewModel.images!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: getProportionateScreenWidth(15),
                              ),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                child: Image.file(
                                  createLocationViewModel.images!,
                                  height: getProportionateScreenHeight(250),
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                                clipBehavior: Clip.antiAlias,
                              ),
                            ),
                          )
                        : Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: getProportionateScreenWidth(15),
                            ),
                            height: getProportionateScreenHeight(250),
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () {
                                createLocationViewModel
                                    .pickImageFromSource(ImageSource.gallery);
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(
                                        getProportionateScreenHeight(5)),
                                    child: Icon(
                                      Icons.add_photo_alternate_rounded,
                                      size: 36,
                                    ),
                                  ),
                                  Text(
                                    ' แตะเพื่อเลือกรูปภาพ',
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.white,
                                primary: Palette.InfoText,
                                alignment: Alignment.center,
                                side:
                                    BorderSide(color: Palette.BorderInputColor),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                              ),
                            ),
                          ),
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(15),
                        vertical: getProportionateScreenHeight(15),
                      ),
                      height: getProportionateScreenHeight(48),
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          bool dropdownValid =
                              createLocationViewModel.validateDropdown();
                          bool locationPinValid =
                              createLocationViewModel.validateLocationPin();
                          if (_formKey.currentState!.validate() &&
                              dropdownValid &&
                              locationPinValid) {
                            bool openingHourValid =
                                createLocationViewModel.validateOpeningHour();
                            if (createLocationViewModel.knowOpeningHour! &&
                                !openingHourValid) {
                              alertDialog(context, 'กรุณาระบุวันเวลาทำการ');
                            } else {
                              // If the form is valid, display a snackbar. In the real world,
                              // you'd often call a server or save the information in a database.
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Processing Data')),
                              );
                            }
                          } else {
                            alertDialog(
                                context, 'กรุณาระบุข้อมูลที่จำเป็นให้ครบ');
                          }
                        },
                        child: Text(
                          'สร้างสถานที่',
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
        ),
      ),
    );
  }
}

Widget Subtitle(String text, String symbol) {
  return Container(
    alignment: Alignment.bottomLeft,
    padding: EdgeInsets.symmetric(
      horizontal: getProportionateScreenWidth(15),
      vertical: getProportionateScreenHeight(15),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          text,
          style: FontAssets.subtitleText,
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
        style: TextStyle(
          color: Palette.BodyText,
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
