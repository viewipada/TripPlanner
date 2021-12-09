import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/assets.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/size_config.dart';
import 'package:trip_planner/src/models/response/baggage_response.dart';
import 'package:trip_planner/src/view/widgets/start_point_card.dart';
import 'package:trip_planner/src/view_models/trip_form_view_model.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';

class TripFormPage extends StatefulWidget {
  final List<BaggageResponse> startPointList;
  final int pointIndex;
  final Map<String, String>? startPointFormGoogleMap;

  TripFormPage({
    required this.startPointList,
    required this.pointIndex,
    this.startPointFormGoogleMap,
  });

  @override
  _TripFormPageState createState() => _TripFormPageState(
      this.startPointList, this.pointIndex, this.startPointFormGoogleMap);
}

class _TripFormPageState extends State<TripFormPage> {
  final List<BaggageResponse> startPointList;
  final int pointIndex;
  final Map<String, String>? startPointFormGoogleMap;
  _TripFormPageState(
      this.startPointList, this.pointIndex, this.startPointFormGoogleMap);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final tripFormViewModel = Provider.of<TripFormViewModel>(context);

    _showCancelTripModal(
            BuildContext context, TripFormViewModel tripFormViewModel) =>
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text(
              'ต้องการยกเลิกทริปหรือไม่',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Palette.BodyText,
              ),
              textAlign: TextAlign.center,
            ),
            content: const Text(
              'ทริปที่คุณสร้างไว้ยังไม่สำเร็จ หากคุณยกเลิกทริปจะไม่สามารถนำกลับมาทำต่อได้',
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
                  Navigator.pop(context, 'ยกเลิกทริป');
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => NavigationBar(),
                  //   ),
                  // );
                },
                child: const Text(
                  'ยกเลิกทริป',
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
        );

    return WillPopScope(
      onWillPop: () async {
        await _showCancelTripModal(context, tripFormViewModel);
        return false;
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
            leading: TextButton(
              onPressed: () => _showCancelTripModal(context, tripFormViewModel),
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
              "สร้างทริป",
              style: FontAssets.headingText,
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.bottomLeft,
                          margin: EdgeInsets.symmetric(
                            horizontal: getProportionateScreenWidth(15),
                          ),
                          padding: EdgeInsets.only(
                              top: getProportionateScreenHeight(15)),
                          child: Text(
                            'ชื่อทริป',
                            style: FontAssets.titleText,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: getProportionateScreenWidth(15),
                            vertical: getProportionateScreenHeight(10),
                          ),
                          child: TextField(
                            maxLength: 30,
                            decoration: InputDecoration(
                              hintText: 'เช่น ลำโพงมันดัง ลำปางมันดี',
                            ),
                            onChanged: (value) =>
                                tripFormViewModel.updateTripNameValue(value),
                            // style: TextStyle(
                            //   fontSize: 14,
                            //   color: Palette.AdditionText,
                            // ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: getProportionateScreenWidth(15),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          bottom:
                                              getProportionateScreenHeight(10)),
                                      child: Text(
                                        'จำนวนคน',
                                        style: FontAssets.titleText,
                                      ),
                                    ),
                                    SpinBox(
                                      min: 1,
                                      max: 25,
                                      value: 1,
                                      direction: Axis.horizontal,
                                      textStyle: TextStyle(
                                          fontSize: 14,
                                          color: Palette.BodyText),
                                      incrementIcon: Icon(
                                        Icons.add,
                                        size: 20,
                                        color: Palette.PrimaryColor,
                                      ),
                                      decrementIcon: Icon(
                                        Icons.remove,
                                        size: 20,
                                        color: Palette.PrimaryColor,
                                      ),
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                            color: const Color(0xffEBECED),
                                          ),
                                        ),
                                        contentPadding: EdgeInsets.zero,
                                        filled: true,
                                        fillColor: Colors.white,
                                      ),
                                      onChanged: (value) => tripFormViewModel
                                          .updateNumberOfPeopleValue(
                                              value.toInt()),
                                    ),
                                  ],
                                ),
                              ),
                              Spacer(
                                flex: 1,
                              ),
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          bottom:
                                              getProportionateScreenHeight(10)),
                                      child: Text(
                                        'จำนวนวัน',
                                        style: FontAssets.titleText,
                                      ),
                                    ),
                                    SpinBox(
                                      min: 1,
                                      max: 15,
                                      value: 1,
                                      direction: Axis.horizontal,
                                      textStyle: TextStyle(
                                          fontSize: 14,
                                          color: Palette.BodyText),
                                      incrementIcon: Icon(
                                        Icons.add,
                                        size: 20,
                                        color: Palette.PrimaryColor,
                                      ),
                                      decrementIcon: Icon(
                                        Icons.remove,
                                        size: 20,
                                        color: Palette.PrimaryColor,
                                      ),
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                            color: const Color(0xffEBECED),
                                          ),
                                        ),
                                        contentPadding: EdgeInsets.zero,
                                        filled: true,
                                        fillColor: Colors.white,
                                      ),
                                      onChanged: (value) => tripFormViewModel
                                          .updateNumberOfTravelingDayValue(
                                              value.toInt()),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Spacer(
                              flex: 4,
                            ),
                            Expanded(
                              flex: 3,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    tripFormViewModel.startDate,
                                    style: FontAssets.bodyText,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal:
                                          getProportionateScreenWidth(15),
                                      vertical:
                                          getProportionateScreenHeight(30),
                                    ),
                                    child: IconButton(
                                      onPressed: () {
                                        tripFormViewModel.pickDate(context);
                                      },
                                      padding: EdgeInsets.zero,
                                      constraints: BoxConstraints(),
                                      icon: Icon(
                                        Icons.calendar_today_rounded,
                                        color: Palette.PrimaryColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: getProportionateScreenWidth(15),
                          ),
                          margin: EdgeInsets.only(
                              bottom: getProportionateScreenHeight(15)),
                          alignment: Alignment.bottomLeft,
                          child: Row(
                            children: [
                              Text(
                                'จุดเริ่มต้นการท่องเที่ยว',
                                style: FontAssets.titleText,
                              ),
                              Visibility(
                                visible: startPointList.isNotEmpty ||
                                    startPointFormGoogleMap != null,
                                child: IconButton(
                                  constraints: BoxConstraints(),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: getProportionateScreenWidth(5),
                                    vertical: 0,
                                  ),
                                  onPressed: () {
                                    tripFormViewModel.goToSearchStartPoint(
                                        context, startPointList);
                                  },
                                  icon: Icon(
                                    Icons.edit_location_alt_outlined,
                                    color: Palette.AdditionText,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        startPointFormGoogleMap == null
                            ? startPointList.isEmpty
                                ? Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal:
                                          getProportionateScreenWidth(15),
                                    ),
                                    child: OutlinedButton(
                                      onPressed: () {
                                        tripFormViewModel.goToSearchStartPoint(
                                            context, startPointList);
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.location_on_outlined,
                                          ),
                                          Text(
                                            ' เลือกจุดเริ่มต้น',
                                            style: TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        padding: EdgeInsets.all(12),
                                        primary: Palette.AdditionText,
                                        alignment: Alignment.center,
                                        side:
                                            BorderSide(color: Palette.Outline),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  )
                                : StartPointCard(
                                    imageUrl: startPointList
                                        .elementAt(this.pointIndex)
                                        .imageUrl,
                                    locationName: startPointList
                                        .elementAt(this.pointIndex)
                                        .locationName,
                                    description: startPointList
                                        .elementAt(this.pointIndex)
                                        .description,
                                    category: startPointList
                                        .elementAt(this.pointIndex)
                                        .category,
                                  )
                            : StartPointCard(
                                imageUrl: '',
                                locationName:
                                    startPointFormGoogleMap!['locationName']!,
                                description:
                                    startPointFormGoogleMap!['description']!,
                                category: '',
                              ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: getProportionateScreenHeight(48),
                  margin: EdgeInsets.symmetric(
                    vertical: getProportionateScreenHeight(15),
                    horizontal: getProportionateScreenWidth(15),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      if (tripFormViewModel.tripName == '') {
                        alertDialog(context, 'กรุณาตั้งชื่อทริป');
                      } else if (startPointList.isEmpty) {
                        alertDialog(context, 'กรุณาเลือกจุดเริ่มต้น');
                      } else {
                        tripFormViewModel.goToCreateTrip(
                            context,
                            startPointList,
                            startPointList.elementAt(this.pointIndex));
                      }
                    },
                    child: Text(
                      'เริ่มสร้างทริป',
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

alertDialog(BuildContext context, String title) {
  return showDialog<String>(
    context: context,
    builder: (BuildContext _context) => AlertDialog(
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
