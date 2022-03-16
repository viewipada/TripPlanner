import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/assets.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/size_config.dart';
import 'package:trip_planner/src/models/trip.dart';
import 'package:trip_planner/src/models/trip_item.dart';
import 'package:trip_planner/src/view/widgets/loading.dart';
import 'package:trip_planner/src/view_models/trip_stepper_view_model.dart';

class TripDetailPage extends StatefulWidget {
  TripDetailPage({required this.trip});
  final Trip trip;

  @override
  _TripDetailPageState createState() => _TripDetailPageState(this.trip);
}

class _TripDetailPageState extends State<TripDetailPage> {
  final Trip trip;
  _TripDetailPageState(this.trip);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final tripStepperViewModel = Provider.of<TripStepperViewModel>(context);
    List<int> days =
        List<int>.generate(trip.totalDay, (int index) => index + 1);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: getProportionateScreenHeight(170),
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                ImageAssets.tripBanner,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_rounded),
              color: Palette.BackIconColor,
              onPressed: () {
                tripStepperViewModel.goBack(context);
              },
            ),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          ),
          SliverToBoxAdapter(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
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
                              .goToRouteOnMapPage(context, trip.tripId!, days),
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
                      // Align(
                      //   alignment: Alignment.centerRight,
                      //   child: CircleAvatar(
                      //     backgroundColor: Palette.SecondaryColor,
                      //     foregroundColor: Colors.white,
                      //     radius: 22,
                      //     child: IconButton(
                      //       icon: Icon(Icons.edit),
                      //       onPressed: () => tripStepperViewModel
                      //           .goToTripStepperPage(context, trip.tripId!),
                      //     ),
                      //   ),
                      // ),
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
                        trip.tripName,
                        // 'อ่างทองไม่เหงา มีเรา 2 3 4 5 คน',
                        style: FontAssets.titleText,
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
                              Padding(
                                padding: EdgeInsets.only(
                                  right: getProportionateScreenWidth(10),
                                  // vertical: getProportionateScreenHeight(10),
                                ),
                                child: Icon(
                                  Icons.people_alt_outlined,
                                  color: Palette.InfoText,
                                ),
                              ),
                              Text(
                                '${trip.totalPeople} คน',
                                style: FontAssets.bodyText,
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  right: getProportionateScreenWidth(10),
                                  // vertical: getProportionateScreenHeight(10),
                                ),
                                child: Icon(
                                  Icons.calendar_today_rounded,
                                  size: 22,
                                  color: Palette.InfoText,
                                ),
                              ),
                              Text(
                                trip.startDate != null
                                    ? '${trip.startDate}'
                                    : 'ยังไม่ระบุ',
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
                            onPressed: () => tripStepperViewModel
                                .goToTripStepperPage(context, trip.tripId!),
                            child: Text(
                              'แก้ไขข้อมูลทริป',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            style:
                                TextButton.styleFrom(padding: EdgeInsets.zero),
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
                  margin: EdgeInsets.only(top: getProportionateScreenHeight(8)),
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
                                .map((item) => item.day ==
                                        tripStepperViewModel.day
                                    ? buildTripItem(item, tripStepperViewModel)
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
                // Padding(
                //   padding: EdgeInsets.symmetric(
                //       horizontal: getProportionateScreenWidth(15)),
                //   child: instruction(
                //       ' ต้องการเปลี่ยนแผนการเดินทาง กดปุ่มดินสอเลย'),
                // ),
                // SizedBox(
                //   height: getProportionateScreenHeight(15),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Widget instruction(String text) {
//   return Container(
//     padding: EdgeInsets.symmetric(
//       vertical: getProportionateScreenHeight(10),
//       horizontal: getProportionateScreenWidth(10),
//     ),
//     margin: EdgeInsets.only(
//       bottom: getProportionateScreenHeight(5),
//     ),
//     decoration: BoxDecoration(
//       color: Color(0xffFEFFE1),
//       borderRadius: BorderRadius.all(Radius.circular(5.0)),
//       border: Border.all(color: Palette.LightOrangeColor),
//     ),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Icon(
//           Icons.lightbulb_outline_rounded,
//           color: Palette.LightOrangeColor,
//           size: 20,
//         ),
//         Text(
//           text,
//           style: TextStyle(
//               color: Palette.LightOrangeColor,
//               fontWeight: FontWeight.bold,
//               fontSize: 12),
//         ),
//       ],
//     ),
//   );
// }

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
                                padding:
                                    MaterialStateProperty.all(EdgeInsets.zero),
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
