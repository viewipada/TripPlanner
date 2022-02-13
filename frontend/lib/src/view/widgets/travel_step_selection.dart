import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:intl/intl.dart';
import 'package:trip_planner/assets.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/size_config.dart';
import 'package:trip_planner/src/view_models/trip_stepper_view_model.dart';

class TravelStepSelection extends StatelessWidget {
  TravelStepSelection({required this.tripStepperViewModel});

  final TripStepperViewModel tripStepperViewModel;

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
            itemCount: tripStepperViewModel.items.length,
            itemBuilder: (context, index) =>
                buildTripItem(index, tripStepperViewModel, context),
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
              tripStepperViewModel.onReorder(oldIndex, newIndex);
            },
          ),
        ),
      ],
    );
  }
}

Widget buildTripItem(int index, TripStepperViewModel tripStepperViewModel,
    BuildContext context) {
  return Column(
    key: Key('$index'),
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      tripStepperViewModel.items[index]['drivingDuration'] == 0
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
                    '  ${tripStepperViewModel.items[index]['drivingDuration']} min',
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
              child: Image.network(
                tripStepperViewModel.items[index]['imageUrl'],
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
                      '${tripStepperViewModel.items.indexOf(tripStepperViewModel.items[index]) + 1}. ${tripStepperViewModel.items[index]['locationName']}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        color: Palette.AdditionText,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
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
                            tripStepperViewModel.items[index]['startTime'] ==
                                    null
                                ? 'ยังไม่ได้ตั้ง'
                                : DateFormat("HH:mm")
                                    .format(tripStepperViewModel.items[index]
                                        ['startTime'])
                                    .toString(),
                            style: FontAssets.hintText,
                          ),
                          style: ButtonStyle(
                            overlayColor:
                                MaterialStateProperty.all(Colors.transparent),
                            padding: MaterialStateProperty.all(EdgeInsets.zero),
                            alignment: Alignment.bottomLeft,
                          ),
                          onPressed: () => tripStepperViewModel.items[index]
                                      ['distance'] ==
                                  'จุดเริ่มต้น'
                              ? showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    content: Stack(
                                      children: [
                                        hourMinute24H(tripStepperViewModel,
                                            tripStepperViewModel.items[index]),
                                        SizedBox(
                                          height:
                                              getProportionateScreenHeight(118),
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
                            '${tripStepperViewModel.items[index]['distance']}',
                            style: FontAssets.hintText,
                          ),
                          style: ButtonStyle(
                            overlayColor:
                                MaterialStateProperty.all(Colors.transparent),
                            padding: MaterialStateProperty.all(EdgeInsets.zero),
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
                            '${tripStepperViewModel.items[index]['duration']}',
                            style: FontAssets.hintText,
                          ),
                          style: ButtonStyle(
                            overlayColor:
                                MaterialStateProperty.all(Colors.transparent),
                            padding: MaterialStateProperty.all(EdgeInsets.zero),
                            alignment: Alignment.bottomLeft,
                          ),
                          onPressed: () => null,
                        ),
                      ],
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

Widget hourMinute24H(TripStepperViewModel tripStepperViewModel, tripItem) {
  // DateTime _dateTime = DateTime.now();
  return new TimePickerSpinner(
    time: DateTime(2022, 1, 1, 9, 0),
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
    onTimeChange: (time) => tripStepperViewModel.setUpStartTime(time, tripItem),
  );
}
