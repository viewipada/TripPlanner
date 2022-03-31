import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/assets.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/size_config.dart';
import 'package:trip_planner/src/models/response/other_trip_response.dart';
import 'package:trip_planner/src/view/widgets/loading.dart';
import 'package:trip_planner/src/view_models/home_view_model.dart';
import 'package:trip_planner/src/view_models/trip_stepper_view_model.dart';

class OtherTripPage extends StatefulWidget {
  OtherTripPage({required this.tripId});
  final int tripId;

  @override
  _OtherTripPageState createState() => _OtherTripPageState(this.tripId);
}

class _OtherTripPageState extends State<OtherTripPage> {
  final int tripId;
  OtherTripResponse? _tripDetail;
  _OtherTripPageState(this.tripId);

  List<int> days = [];

  @override
  void initState() {
    super.initState();
    Provider.of<TripStepperViewModel>(context, listen: false)
        .getOtherTripDetail(tripId)
        .then((value) {
      setState(() {
        _tripDetail = value;
        days =
            List<int>.generate(_tripDetail!.totalDay, (int index) => index + 1);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final tripStepperViewModel = Provider.of<TripStepperViewModel>(context);
    final homeViewModel = Provider.of<HomeViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          color: Palette.BackIconColor,
          onPressed: () {
            tripStepperViewModel.goBack(context);
          },
        ),
        title: Text(
          'แผนการเดินทาง',
          style: FontAssets.headingText,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: _tripDetail == null
            ? Loading()
            : Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: getProportionateScreenHeight(5),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: getProportionateScreenHeight(10),
                            horizontal: getProportionateScreenWidth(15),
                          ),
                          child: Stack(
                            children: [
                              Center(
                                child: OutlinedButton(
                                  onPressed: () => tripStepperViewModel
                                      .goToOtherRouteOnMapPage(
                                          context, days, _tripDetail!.tripId),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical:
                                            getProportionateScreenHeight(10)),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                    side: BorderSide(
                                        color: Palette.SecondaryColor),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            vertical: getProportionateScreenHeight(5),
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
                              SizedBox(
                                height: getProportionateScreenHeight(10),
                              ),
                              Text(
                                _tripDetail!.tripName,
                                // 'อ่างทองไม่เหงา มีเรา 2 3 4 5 คน',
                                style: FontAssets.titleText,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'มี ${_tripDetail!.tripItems.length} สถานที่ในทริปนี้',
                                    style: FontAssets.bodyText,
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          right:
                                              getProportionateScreenWidth(10),
                                          // vertical: getProportionateScreenHeight(10),
                                        ),
                                        child: Icon(
                                          Icons.people_alt_outlined,
                                          color: Palette.InfoText,
                                        ),
                                      ),
                                      Text(
                                        '${_tripDetail!.totalPeople} คน',
                                        style: FontAssets.bodyText,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          right:
                                              getProportionateScreenWidth(10),
                                          // vertical: getProportionateScreenHeight(10),
                                        ),
                                        child: Icon(
                                          Icons.calendar_today_rounded,
                                          size: 22,
                                          color: Palette.InfoText,
                                        ),
                                      ),
                                      Text(
                                        DateFormat("dd/MM/yyyy")
                                            .format(DateTime.parse(
                                                _tripDetail!.startDate!))
                                            .toString(),
                                        style: FontAssets.bodyText,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      homeViewModel.copyTrip(_tripDetail!);
                                      final snackBar = SnackBar(
                                        backgroundColor: Palette.SecondaryColor,
                                        content: Text(
                                          'คัดลอกทริปแล้ว',
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
                                    },
                                    child: Text(
                                      'คัดลอกทริป',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Divider(),
                        Container(
                          color: Colors.white,
                          width: double.infinity,
                          margin: EdgeInsets.only(
                              top: getProportionateScreenHeight(8)),
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
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: getProportionateScreenWidth(15)),
                            child: Column(
                              children: _tripDetail!.tripItems
                                  .map((item) => item.day ==
                                          tripStepperViewModel.day
                                      ? buildTripItem(
                                          context, item, tripStepperViewModel)
                                      : SizedBox())
                                  .toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
      //   ],
      // ),
    );
  }
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

Widget instruction(String text) {
  return Container(
    padding: EdgeInsets.symmetric(
      vertical: getProportionateScreenHeight(10),
      horizontal: getProportionateScreenWidth(10),
    ),
    margin: EdgeInsets.only(
      bottom: getProportionateScreenHeight(5),
    ),
    decoration: BoxDecoration(
      color: Color(0xffFEFFE1),
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
      border: Border.all(color: Palette.LightOrangeColor),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.lightbulb_outline_rounded,
          color: Palette.LightOrangeColor,
          size: 20,
        ),
        Text(
          text,
          style: TextStyle(
              color: Palette.LightOrangeColor,
              fontWeight: FontWeight.bold,
              fontSize: 12),
        ),
      ],
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

Widget buildTripItem(BuildContext context, OtherTripItemResponse item,
    TripStepperViewModel tripStepperViewModel) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      item.drivingDuration == null
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
      InkWell(
        onTap: () =>
            tripStepperViewModel.goToLocationDetail(context, item.locationId),
        child: Container(
          // height: getProportionateScreenHeight(90),
          margin:
              EdgeInsets.symmetric(vertical: getProportionateScreenHeight(5)),
          decoration: BoxDecoration(
            color: item.locationCategory == 2 ? Palette.BaseMeal : Colors.white,
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
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${item.no + 1}. ${item.locationName}',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                color: Palette.AdditionText,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
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
                                DateFormat("HH:mm")
                                    .format(DateTime.parse(item.startTime))
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
                              onPressed: () => null,
                            ),
                            Expanded(
                              child: TextButton.icon(
                                icon: Icon(
                                  Icons.place_outlined,
                                  color: Palette.PrimaryColor,
                                  size: 18,
                                ),
                                label: Text(
                                  item.distance == null
                                      ? 'จุดเริ่มต้น'
                                      : '${item.distance} km',
                                  style: FontAssets.hintText,
                                ),
                                style: ButtonStyle(
                                  overlayColor: MaterialStateProperty.all(
                                      Colors.transparent),
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.zero),
                                  alignment: Alignment.bottomCenter,
                                ),
                                onPressed: () => null,
                              ),
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
      ),
    ],
  );
}
