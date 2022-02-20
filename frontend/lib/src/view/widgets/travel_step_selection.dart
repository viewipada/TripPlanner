import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:trip_planner/assets.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/size_config.dart';
import 'package:trip_planner/src/models/trip.dart';
import 'package:trip_planner/src/models/trip_item.dart';
import 'package:trip_planner/src/view_models/trip_stepper_view_model.dart';

class TravelStepSelection extends StatefulWidget {
  TravelStepSelection({
    required this.tripStepperViewModel,
    required this.tripItems,
    required this.trip,
  });

  final TripStepperViewModel tripStepperViewModel;
  final List<TripItem> tripItems;
  final Trip trip;

  @override
  _TravelStepSelectionState createState() => _TravelStepSelectionState(
      this.tripStepperViewModel, this.tripItems, this.trip);
}

class _TravelStepSelectionState extends State<TravelStepSelection> {
  final TripStepperViewModel tripStepperViewModel;
  final List<TripItem> tripItems;
  final Trip trip;

  _TravelStepSelectionState(
      this.tripStepperViewModel, this.tripItems, this.trip);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Column(
      children: [
        Stack(
          children: [
            Center(
              child: OutlinedButton(
                onPressed: () {},
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
        Padding(
          padding: EdgeInsets.only(
            top: getProportionateScreenHeight(10),
            bottom: getProportionateScreenHeight(55),
          ),
          child: ReorderableListView.builder(
            clipBehavior: Clip.antiAlias,
            shrinkWrap: true,
            scrollController: ScrollController(),
            itemCount: tripItems.length,
            itemBuilder: (context, index) => buildTripItem(index,
                tripStepperViewModel, context, tripItems[index], tripItems),
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
                        offset: Offset(2, 4), // changes position of shadow
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
          ),
        ),
      ],
    );
  }
}

Widget buildTripItem(int index, TripStepperViewModel tripStepperViewModel,
    BuildContext context, TripItem item, List<TripItem> tripItems) {
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
                        tripStepperViewModel.updateDurationOfTripItem(
                            tripItems, index, value);
                      });
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

  return Column(
    key: UniqueKey(),
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      item.drivingDuration == 0
          ? SizedBox()
          : Padding(
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
      Container(
        // height: getProportionateScreenHeight(90),
        margin: EdgeInsets.symmetric(vertical: getProportionateScreenHeight(5)),
        decoration: BoxDecoration(
          color: Colors.white,
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
            Card(
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
                              overlayColor:
                                  MaterialStateProperty.all(Colors.transparent),
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
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      content: Stack(
                                        children: [
                                          hourMinute24H(
                                              tripStepperViewModel, tripItems),
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
                                              getProportionateScreenHeight(5)),
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
                                  : '${item.distance}',
                              style: FontAssets.hintText,
                            ),
                            style: ButtonStyle(
                              overlayColor:
                                  MaterialStateProperty.all(Colors.transparent),
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
                              overlayColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.zero),
                              alignment: Alignment.bottomLeft,
                            ),
                            onPressed: () => _showDurationSelectionAlert(
                                context,
                                tripStepperViewModel,
                                item.no,
                                tripItems),
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
    ],
  );
}

Widget hourMinute24H(
    TripStepperViewModel tripStepperViewModel, List<TripItem> tripItems) {
  // DateTime _dateTime = DateTime.now();
  return new TimePickerSpinner(
    time: tripItems[0].startTime == null
        ? DateTime(2022, 1, 1, 9, 0)
        : DateTime.parse(tripItems[0].startTime!),
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
        tripStepperViewModel.setUpStartTime(time, tripItems),
  );
}
