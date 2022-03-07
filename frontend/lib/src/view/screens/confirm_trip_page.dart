import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/assets.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/size_config.dart';
import 'package:trip_planner/src/models/trip.dart';
import 'package:trip_planner/src/models/trip_item.dart';
import 'package:trip_planner/src/view/widgets/loading.dart';
import 'package:trip_planner/src/view_models/trip_stepper_view_model.dart';

class ConfirmTripPage extends StatefulWidget {
  ConfirmTripPage({required this.trip});
  final Trip trip;

  @override
  _ConfirmTripPageState createState() => _ConfirmTripPageState(this.trip);
}

class _ConfirmTripPageState extends State<ConfirmTripPage> {
  final Trip trip;
  _ConfirmTripPageState(this.trip);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final tripStepperViewModel = Provider.of<TripStepperViewModel>(context);
    List<int> days =
        List<int>.generate(trip.totalDay, (int index) => index + 1);

    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_rounded),
            color: Palette.BackIconColor,
            onPressed: () => tripStepperViewModel.clearConfirmPage(context),
          ),
          title: Text(
            "ยืนยันการสร้างทริป",
            style: FontAssets.headingText,
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: getProportionateScreenHeight(10),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: getProportionateScreenHeight(5),
                      horizontal: getProportionateScreenWidth(15),
                    ),
                    child: Text(
                      'เลือกภาพปกทริปของคุณ',
                      style: FontAssets.bodyText,
                    ),
                  ),
                  buildTrumbnailSelection(tripStepperViewModel, trip),
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
                  SizedBox(
                    height: getProportionateScreenHeight(8),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: getProportionateScreenHeight(15),
                      horizontal: getProportionateScreenWidth(15),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        top: BorderSide(
                          color: Palette.PrimaryColor,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          trip.tripName,
                          // 'อ่างทองไม่เหงา มีเรา 2 3 4 5 คน',
                          style: FontAssets.subtitleText,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'มี ${trip.totalTripItem} สถานที่ในทริปนี้',
                              style: FontAssets.bodyText,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  trip.startDate != null
                                      ? '${trip.startDate}'
                                      : 'วันเริ่มต้นทริป',
                                  style: FontAssets.bodyText,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: getProportionateScreenWidth(15),
                                    // vertical: getProportionateScreenHeight(10),
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      tripStepperViewModel.pickDate(
                                          context, trip);
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
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  Container(
                    color: Colors.white,
                    width: double.infinity,
                    margin:
                        EdgeInsets.only(top: getProportionateScreenHeight(8)),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: days
                            .map((day) =>
                                buildDayButton(day, tripStepperViewModel))
                            .toList(),
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
                          .getAllTripItemsByTripId(trip.tripId!),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var _tripItems = snapshot.data as List<TripItem>;

                          return Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: getProportionateScreenWidth(15)),
                            child: Column(
                              children: _tripItems
                                  .map((item) =>
                                      item.day == tripStepperViewModel.day
                                          ? buildTripItem(
                                              item, tripStepperViewModel)
                                          : SizedBox())
                                  .toList(),
                            ),
                          );
                        } else {
                          return Loading();
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(60),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(15),
                  vertical: getProportionateScreenHeight(15),
                ),
                width: double.infinity,
                height: getProportionateScreenHeight(48),
                child: ElevatedButton(
                  onPressed: () => tripStepperViewModel.trumbnail == null
                      ? alertDialog(context, 'กรุณาเลือกภาพปกทริปของคุณ')
                      : trip.startDate == null
                          ? alertDialog(context, 'กรุณาระบุวันเริ่มเดินทาง')
                          : tripStepperViewModel.confirmTrip(trip, context),
                  child: Text(
                    "ยืนยันสร้างทริป",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      onWillPop: () async {
        tripStepperViewModel.clearConfirmPage(context);
        return true;
      },
    );
  }
}

Widget buildTrumbnailSelection(
    TripStepperViewModel tripStepperViewModel, Trip trip) {
  return Container(
    margin: EdgeInsets.only(bottom: getProportionateScreenHeight(10)),
    width: double.infinity,
    child: SingleChildScrollView(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(11)),
      scrollDirection: Axis.horizontal,
      child: FutureBuilder(
        future: tripStepperViewModel.getAllTripItemsByTripId(trip.tripId!),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var _tripItems = snapshot.data as List<TripItem>;

            return Row(
              children: _tripItems
                  .map(
                    (item) => item.imageUrl == ""
                        ? SizedBox()
                        : Stack(
                            children: [
                              InkWell(
                                onTap: () => tripStepperViewModel
                                    .selectTrumbnail(item.imageUrl),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                  child: Image.network(
                                    item.imageUrl,
                                    fit: BoxFit.cover,
                                    height: getProportionateScreenHeight(80),
                                    width: getProportionateScreenHeight(80),
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                ),
                              ),
                              Visibility(
                                visible: item.imageUrl ==
                                    tripStepperViewModel.trumbnail,
                                child: Card(
                                  color: Color.fromRGBO(0, 0, 0, 0.4),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                  child: Container(
                                    width: getProportionateScreenHeight(80),
                                    height: getProportionateScreenHeight(80),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Palette.PrimaryColor,
                                        ),
                                        child: Center(
                                            child: Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 18,
                                        )),
                                      ),
                                    ),
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                ),
                              ),
                            ],
                          ),
                  )
                  .toList(),
            );
          } else {
            return Loading();
          }
        },
      ),
    ),
  );
}

Widget buildDayButton(int day, TripStepperViewModel tripStepperViewModel) {
  return Column(
    children: [
      SizedBox(
        width: getProportionateScreenWidth(100),
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
          width: getProportionateScreenWidth(100),
          color: Palette.SecondaryColor,
        ),
      ),
    ],
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

Widget buildTripItem(TripItem item, TripStepperViewModel tripStepperViewModel) {
  return Column(
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
                            onPressed: () => null,
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
                            onPressed: () => null,
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
