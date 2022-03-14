import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:trip_planner/assets.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/size_config.dart';
import 'package:trip_planner/src/models/trip.dart';
import 'package:trip_planner/src/models/trip_item.dart';
import 'package:trip_planner/src/view/widgets/loading.dart';
import 'package:trip_planner/src/view_models/trip_stepper_view_model.dart';

class TravelStepSelection extends StatefulWidget {
  TravelStepSelection({
    required this.tripStepperViewModel,
    required this.trip,
    required this.days,
  });

  final TripStepperViewModel tripStepperViewModel;
  final Trip trip;
  final List<int> days;

  @override
  _TravelStepSelectionState createState() => _TravelStepSelectionState(
      this.tripStepperViewModel, this.trip, this.days);
}

class _TravelStepSelectionState extends State<TravelStepSelection> {
  final SlidableController slidableController = SlidableController();
  final TripStepperViewModel tripStepperViewModel;
  List<TripItem> tripItems = [];
  final Trip trip;
  List<int> days;

  _TravelStepSelectionState(this.tripStepperViewModel, this.trip, this.days);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Column(
      children: [
        Stack(
          children: [
            Center(
              child: OutlinedButton(
                onPressed: () => tripStepperViewModel.goToRouteOnMapPage(
                    context, trip.tripId!, days),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: getProportionateScreenHeight(10)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.map_outlined),
                      Text(
                        ' ดูทริปของคุณบนแผนที่',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  primary: Palette.SecondaryColor,
                  alignment: Alignment.center,
                  side: BorderSide(color: Palette.SecondaryColor),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: CircleAvatar(
                backgroundColor: Palette.SecondaryColor,
                foregroundColor: Colors.white,
                child: IconButton(
                  icon: ImageIcon(
                    AssetImage(IconAssets.sort),
                  ),
                  onPressed: () => print('press'),
                ),
              ),
            ),
          ],
        ),
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(top: getProportionateScreenHeight(5)),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: days
                      .map((day) => buildDayButton(day, tripStepperViewModel))
                      .toList(),
                ),
                IconButton(
                  onPressed: () => tripStepperViewModel.addDay(days, trip),
                  icon: Icon(
                    Icons.add_circle,
                    color: Palette.LightSecondary,
                    size: 30,
                  ),
                )
              ],
            ),
          ),
        ),
        Divider(),
        Padding(
          padding: EdgeInsets.only(
            top: getProportionateScreenHeight(10),
            bottom: getProportionateScreenHeight(15),
          ),
          child: FutureBuilder(
            future: tripStepperViewModel
                .getAllTripItemsByTripIdAndDay(trip.tripId!),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var _tripItems = snapshot.data as List<TripItem>;
                tripItems = _tripItems;

                tripStepperViewModel.getAllTripItemsByTripId(trip.tripId!).then(
                    (value) =>
                        tripStepperViewModel.isStartTimeValid(value, days));

                return ReorderableListView(
                  clipBehavior: Clip.antiAlias,
                  shrinkWrap: true,
                  scrollController: ScrollController(),
                  children: tripItems
                      .asMap()
                      .map((index, item) => MapEntry(
                          index,
                          buildTripItem(index, tripStepperViewModel, context,
                              item, tripItems, trip, slidableController)))
                      .values
                      .toList(),
                  proxyDecorator:
                      (Widget child, int index, Animation<double> animation) {
                    return Material(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Palette.BackgroundColor,
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 0,
                              blurRadius: 3,
                              offset: Offset(2, 4),
                            ),
                          ],
                        ),
                        child: child,
                      ),
                    );
                  },
                  onReorder: (int oldIndex, int newIndex) {
                    tripStepperViewModel.onReorder(
                        oldIndex, newIndex, tripItems, trip);
                  },
                );
              } else {
                return Loading();
              }
            },
          ),
        ),
        ListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          trailing: Icon(
            Icons.add_circle,
            color: Palette.PrimaryColor,
          ),
          title: Text(
            "   เพิ่มจากกระเป๋าเดินทาง",
            style: TextStyle(
                color: Palette.PrimaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 14),
          ),
          onTap: () => tripStepperViewModel.goToAddFromBaggagePage(
              context, tripItems, tripItems.length, trip),
        ),
        ListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          trailing: Icon(
            Icons.add_circle,
            color: Palette.PrimaryColor,
          ),
          title: Text(
            "   เพิ่มจากสถานที่แนะนำในเส้นทาง",
            style: TextStyle(
                color: Palette.PrimaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 14),
          ),
          onTap: () => tripStepperViewModel.goToLocationRecommendPage(
              context,
              tripItems,
              tripItems.length,
              trip,
              tripStepperViewModel.index == 1
                  ? "ที่เที่ยว"
                  : tripStepperViewModel.index == 2
                      ? "ที่กิน"
                      : "ที่พัก"),
        ),
        trip.totalDay > 1 ? Divider() : SizedBox(),
        trip.totalDay > 1
            ? TextButton(
                child: Text(
                  "   ลบวันที่ ${tripStepperViewModel.day}",
                  style: TextStyle(
                      color: Palette.DeleteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
                style: TextButton.styleFrom(primary: Palette.DeleteColor),
                onPressed: () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    title: Text(
                      'ต้องการลบวันที่ ${tripStepperViewModel.day} หรือไม่',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Palette.BodyText,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    content: const Text(
                      'หากคุณยืนยัน ข้อมูลทริปในวันดังกล่าวจะถูกลบ',
                      style: TextStyle(
                        fontSize: 14,
                        color: Palette.AdditionText,
                      ),
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
                          tripStepperViewModel.deleteDay(days, trip);
                        },
                        child: const Text(
                          'ยืนยัน',
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
              )
            : SizedBox(),
        SizedBox(
          height: getProportionateScreenHeight(55),
        ),
      ],
    );
  }
}

Widget buildTripItem(
    int index,
    TripStepperViewModel tripStepperViewModel,
    BuildContext context,
    TripItem item,
    List<TripItem> tripItems,
    Trip trip,
    SlidableController slidableController) {
  _showDurationSelectionAlert(
          BuildContext context,
          TripStepperViewModel tripStepperViewModel,
          int index,
          List<TripItem> tripItems) =>
      showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            contentPadding: EdgeInsets.zero,
            content: Stack(
              alignment: Alignment.center,
              children: [
                NumberPicker(
                    value: tripItems[index].duration,
                    minValue: 30,
                    maxValue: 180,
                    step: 30,
                    haptics: true,
                    itemHeight: getProportionateScreenHeight(40),
                    textStyle: FontAssets.hintText,
                    selectedTextStyle: TextStyle(
                      fontSize: 16,
                      color: Palette.PrimaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                    onChanged: (value) {
                      setState(() {
                        tripItems[index].duration = value;
                      });
                      tripStepperViewModel.updateDurationOfTripItem(
                          tripItems, index, value);
                    }),
                SizedBox(
                  height: getProportionateScreenHeight(118),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(
                          right: getProportionateScreenWidth(60)),
                      child: Text(
                        'min.',
                        textAlign: TextAlign.center,
                        style: FontAssets.bodyText,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  return Slidable(
    key: UniqueKey(),
    controller: slidableController,
    actionPane: SlidableDrawerActionPane(),
    actionExtentRatio: 0.25,
    movementDuration: Duration(milliseconds: 500),
    enabled: tripItems.length > 1 ? true : false,
    secondaryActions: [
      InkWell(
        onTap: () {
          tripStepperViewModel.deleteTripItem(trip, tripItems, item);
          Slidable.of(context)?.close();
        },
        child: Align(
          alignment: Alignment.bottomRight,
          child: Container(
            height: getProportionateScreenHeight(87),
            width: getProportionateScreenHeight(87),
            margin: EdgeInsets.only(
                bottom: getProportionateScreenHeight(5),
                left: getProportionateScreenWidth(5)),
            decoration: BoxDecoration(
              color: Palette.DeleteColor,
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 0,
                  blurRadius: 1,
                  offset: Offset(2, 4), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.delete, color: Colors.white),
                Text(
                  'นำออก',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        item.drivingDuration == 0
            ? SizedBox()
            : Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: getProportionateScreenHeight(5),
                      horizontal: getProportionateScreenWidth(10),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          tripStepperViewModel.vehiclesSelected,
                          color: Palette.InfoText,
                          size: 18,
                        ),
                        Text(
                          '  ${item.drivingDuration} min',
                          style: FontAssets.hintText,
                        ),
                      ],
                    ),
                  ),
                  // FutureBuilder(
                  //   future: tripStepperViewModel.recommendMeal(tripItems),
                  //   builder: (context, snapshot) {
                  //     if (snapshot.hasData) {
                  //       var mealsIndex = snapshot.data as List<int>;
                  //       return mealsIndex.isNotEmpty && mealsIndex[2] == index
                  //           ? recommendMeals(
                  //               'มื้อเย็น',
                  //               Icon(
                  //                 Icons.nights_stay_rounded,
                  //                 color: Palette.LightSecondary,
                  //                 size: 18,
                  //               ),
                  //             )
                  //           : mealsIndex.isNotEmpty && mealsIndex[1] == index
                  //               ? recommendMeals(
                  //                   'มื้อเที่ยง',
                  //                   Icon(
                  //                     Icons.wb_sunny_rounded,
                  //                     color: Palette.LightSecondary,
                  //                     size: 20,
                  //                   ),
                  //                 )
                  //               : mealsIndex.isNotEmpty &&
                  //                       mealsIndex[0] == index
                  //                   ? recommendMeals(
                  //                       'มื้อเช้า',
                  //                       Icon(
                  //                         Icons.wb_twilight_rounded,
                  //                         color: Palette.LightSecondary,
                  //                         size: 18,
                  //                       ),
                  //                     )
                  //                   : SizedBox();
                  //     } else {
                  //       return Container(color: Colors.green, height: 10);
                  //     }
                  //   },
                  // ),
                  if (tripStepperViewModel.recommendMeal(tripItems).isNotEmpty)
                    tripStepperViewModel.recommendMeal(tripItems)[2] == index
                        ? recommendMeals(
                            'มื้อเย็น',
                            Icon(
                              Icons.nights_stay_rounded,
                              color: Palette.LightSecondary,
                              size: 18,
                            ),
                          )
                        : tripStepperViewModel.recommendMeal(tripItems)[1] ==
                                index
                            ? recommendMeals(
                                'มื้อเที่ยง',
                                Icon(
                                  Icons.wb_sunny_rounded,
                                  color: Palette.LightSecondary,
                                  size: 20,
                                ),
                              )
                            : tripStepperViewModel
                                        .recommendMeal(tripItems)[0] ==
                                    index
                                ? recommendMeals(
                                    'มื้อเช้า',
                                    Icon(
                                      Icons.wb_twilight_rounded,
                                      color: Palette.LightSecondary,
                                      size: 18,
                                    ),
                                  )
                                : SizedBox()
                ],
              ),
        Container(
          // height: getProportionateScreenHeight(90),
          margin:
              EdgeInsets.symmetric(vertical: getProportionateScreenHeight(5)),
          decoration: BoxDecoration(
            color: item.locationCategory == 'ที่กิน'
                ? Palette.BaseMeal
                : Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 0,
                blurRadius: 1,
                offset: Offset(2, 4), // changes position of shadow
              ),
            ],
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => item.imageUrl == ""
                    ? null
                    : tripStepperViewModel.goToLocationDetail(
                        context, item.locationId),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    bottomLeft: Radius.circular(10.0),
                  )),
                  child: item.imageUrl == ""
                      ? Image.asset(
                          ImageAssets.noPreview,
                          fit: BoxFit.cover,
                          height: getProportionateScreenHeight(80),
                          width: getProportionateScreenHeight(80),
                        )
                      : Image.network(
                          item.imageUrl,
                          fit: BoxFit.cover,
                          height: getProportionateScreenHeight(80),
                          width: getProportionateScreenHeight(80),
                        ),
                  clipBehavior: Clip.antiAlias,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    getProportionateScreenWidth(10),
                    getProportionateScreenHeight(10),
                    0,
                    0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${item.no + 1}. ${item.locationName}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          color: Palette.AdditionText,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            right: getProportionateScreenWidth(15)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton.icon(
                              icon: Icon(
                                Icons.access_time_rounded,
                                color: Palette.LightSecondary,
                                size: 18,
                              ),
                              label: Text(
                                item.startTime == null
                                    ? 'ยังไม่ได้ตั้ง'
                                    : DateFormat("HH:mm")
                                        .format(DateTime.parse(item.startTime!))
                                        .toString(),
                                style: FontAssets.hintText,
                              ),
                              style: ButtonStyle(
                                overlayColor: MaterialStateProperty.all(
                                    Colors.transparent),
                                padding:
                                    MaterialStateProperty.all(EdgeInsets.zero),
                                alignment: Alignment.bottomLeft,
                              ),
                              onPressed: () => item.distance == null
                                  ? showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        content: Stack(
                                          children: [
                                            hourMinute24H(tripStepperViewModel,
                                                tripItems, index),
                                            SizedBox(
                                              height:
                                                  getProportionateScreenHeight(
                                                      118),
                                              child: Center(
                                                child: Text(
                                                  ':',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Palette.PrimaryColor,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical:
                                                getProportionateScreenHeight(
                                                    5)),
                                      ),
                                    )
                                  : null,
                            ),
                            TextButton.icon(
                              icon: Icon(
                                Icons.place_outlined,
                                color: Palette.PrimaryColor,
                                size: 18,
                              ),
                              label: Text(
                                item.distance == null
                                    ? 'จุดเริ่มต้น'
                                    : '${item.distance} m',
                                style: FontAssets.hintText,
                              ),
                              style: ButtonStyle(
                                overlayColor: MaterialStateProperty.all(
                                    Colors.transparent),
                                padding:
                                    MaterialStateProperty.all(EdgeInsets.zero),
                                alignment: Alignment.bottomLeft,
                              ),
                              onPressed: () => null,
                            ),
                            TextButton.icon(
                              icon: Icon(
                                Icons.hourglass_empty_rounded,
                                color: Palette.SecondaryColor,
                                size: 18,
                              ),
                              label: Text(
                                '${item.duration} min',
                                style: FontAssets.hintText,
                              ),
                              style: ButtonStyle(
                                overlayColor: MaterialStateProperty.all(
                                    Colors.transparent),
                                padding:
                                    MaterialStateProperty.all(EdgeInsets.zero),
                                alignment: Alignment.bottomLeft,
                              ),
                              onPressed: () => item.duration < 30
                                  ? null
                                  : _showDurationSelectionAlert(context,
                                      tripStepperViewModel, item.no, tripItems),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        if (tripStepperViewModel.recommendToStop(tripItems) != -1)
          tripStepperViewModel.recommendToStop(tripItems) == index
              ? recommendToStop()
              : SizedBox()
      ],
    ),
  );
}

Widget buildDayButton(int day, TripStepperViewModel tripStepperViewModel) {
  return Column(
    children: [
      SizedBox(
        width: getProportionateScreenWidth(70),
        child: TextButton(
          onPressed: () => tripStepperViewModel.onDayTapped(day),
          child: Text(
            'วันที่ ${day}',
            style: TextStyle(
              color: Palette.AdditionText,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          style: TextButton.styleFrom(
            primary: Palette.LightOrangeColor,
          ),
        ),
      ),
      Visibility(
        visible: tripStepperViewModel.day == day,
        child: Container(
          height: 3,
          width: getProportionateScreenWidth(70),
          color: Palette.SecondaryColor,
        ),
      ),
    ],
  );
}

Widget recommendMeals(String meal, Icon icon) {
  return Container(
    padding: EdgeInsets.symmetric(
      vertical: getProportionateScreenHeight(10),
      horizontal: getProportionateScreenWidth(10),
    ),
    margin: EdgeInsets.only(
      bottom: getProportionateScreenHeight(5),
    ),
    decoration: BoxDecoration(
      color: Palette.BaseMeal,
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
      border: Border.all(color: Palette.LightSecondary),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        icon,
        Text(
          ' อย่าลืมเผื่อเวลาสำหรับ ${meal} ของคุณ',
          style: FontAssets.mealsRecommendText,
        ),
      ],
    ),
  );
}

Widget recommendToStop() {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.symmetric(
      vertical: getProportionateScreenHeight(10),
      horizontal: getProportionateScreenWidth(10),
    ),
    margin: EdgeInsets.only(
      top: getProportionateScreenHeight(5),
    ),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border(top: BorderSide(color: Palette.PrimaryColor, width: 2)),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 0,
          blurRadius: 3,
          offset: Offset(2, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'เที่ยวหนัก พักหน่อย',
          style: TextStyle(
              color: Palette.AdditionText,
              fontSize: 14,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(height: getProportionateScreenHeight(5)),
        Text(
          'เก็บที่เที่ยวเอาไว้เพิ่มวันถัดไปดีกว่า',
          style: TextStyle(color: Palette.AdditionText, fontSize: 12),
        ),
      ],
    ),
  );
}

Widget hourMinute24H(TripStepperViewModel tripStepperViewModel,
    List<TripItem> tripItems, int index) {
  // DateTime _dateTime = DateTime.now();
  return new TimePickerSpinner(
    time: tripItems[index].startTime == null
        ? DateTime(2022, 1, 1, 8, 0)
        : DateTime.parse(tripItems[index].startTime!),
    isForce2Digits: true,
    normalTextStyle: FontAssets.hintText,
    highlightedTextStyle: TextStyle(
      fontSize: 16,
      color: Palette.PrimaryColor,
      fontWeight: FontWeight.bold,
    ),
    // spacing: 50,
    itemHeight: getProportionateScreenHeight(40),
    alignment: Alignment.center,
    onTimeChange: (time) =>
        tripStepperViewModel.setUpStartTime(time, tripItems, index),
  );
}
