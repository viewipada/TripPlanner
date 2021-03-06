import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/assets.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/size_config.dart';
import 'package:trip_planner/src/models/trip.dart';
import 'package:trip_planner/src/models/trip_item.dart';
import 'package:trip_planner/src/view_models/trip_stepper_view_model.dart';

class FoodStepSelection extends StatefulWidget {
  FoodStepSelection({
    required this.tripStepperViewModel,
    required this.tripItems,
    required this.trip,
    required this.days,
  });

  final TripStepperViewModel tripStepperViewModel;
  final List<TripItem> tripItems;
  final Trip trip;
  final List<int> days;

  @override
  _FoodStepSelectionState createState() => _FoodStepSelectionState(
      this.tripStepperViewModel, this.tripItems, this.trip, this.days);
}

class _FoodStepSelectionState extends State<FoodStepSelection> {
  final SlidableController slidableController = SlidableController();
  final TripStepperViewModel tripStepperViewModel;
  List<TripItem> tripItems = [];
  final Trip trip;
  List<int> days;

  _FoodStepSelectionState(
      this.tripStepperViewModel, this.tripItems, this.trip, this.days);

  @override
  void initState() {
    if (tripItems.isNotEmpty)
      Provider.of<TripStepperViewModel>(context, listen: false)
          .getMeals(tripItems, trip.tripId!, trip.totalDay)
          .then((value) {
        setState(() {
          tripItems = value;
        });
      }).then((value) => Future.delayed(Duration(seconds: 1)));

    super.initState();
  }

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
                        ' ????????????????????????????????????????????????????????????',
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
                  onPressed: () {
                    tripStepperViewModel
                        .sortTripItems(trip, tripItems)
                        .then((value) {
                      final snackBar = SnackBar(
                        backgroundColor: Palette.SecondaryColor,
                        content: Text(
                          '??????????????????????????????????????????????????????????????????????????????????????????',
                          style: TextStyle(
                            fontFamily: 'Sukhumvit',
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    });
                  },
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
                // IconButton(
                //   onPressed: () => tripStepperViewModel.addDay(days, trip),
                //   icon: Icon(
                //     Icons.add_circle,
                //     color: Palette.LightSecondary,
                //     size: 30,
                //   ),
                // )
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
          child: ReorderableListView(
            clipBehavior: Clip.antiAlias,
            shrinkWrap: true,
            scrollController: ScrollController(),
            children: tripItems
                .asMap()
                .map(
                  (index, item) => MapEntry(
                    index,
                    item.locationName == "" &&
                            item.day == tripStepperViewModel.day
                        ? addMeal(context, tripStepperViewModel, index,
                            tripItems, trip)
                        : item.day == tripStepperViewModel.day
                            ? buildTripItem(
                                index,
                                tripStepperViewModel,
                                context,
                                item,
                                tripItems,
                                trip,
                                slidableController,
                                days,
                              )
                            : SizedBox(
                                key: UniqueKey(),
                              ),
                  ),
                )
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
        ListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          trailing: Icon(
            Icons.add_circle,
            color: Palette.PrimaryColor,
          ),
          title: Text(
            "   ???????????????????????????????????????????????????????????????????????????????????????",
            style: TextStyle(
                color: Palette.PrimaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 14),
          ),
          onTap: () => tripStepperViewModel.goToLocationRecommendPage(
              context,
              tripItems,
              tripItems.lastIndexWhere((element) =>
                      element.day == tripStepperViewModel.day &&
                      element.no >= 0) +
                  1,
              trip,
              "??????????????????"),
        ),
        ListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          trailing: Icon(
            Icons.add_circle,
            color: Palette.PrimaryColor,
          ),
          title: Text(
            "   ??????????????????????????????????????????????????????????????????",
            style: TextStyle(
                color: Palette.PrimaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 14),
          ),
          onTap: () => tripStepperViewModel.goToAddFromBaggagePage(
              context, tripItems, tripItems.length, trip),
        ),
        trip.totalDay > 1 ? Divider() : SizedBox(),
        trip.totalDay > 1
            ? TextButton(
                child: Text(
                  "   ???????????????????????? ${tripStepperViewModel.day}",
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
                      '????????????????????????????????????????????? ${tripStepperViewModel.day} ?????????????????????',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Palette.BodyText,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    content: const Text(
                      '???????????????????????????????????? ??????????????????????????????????????????????????????????????????????????????????????????',
                      style: TextStyle(
                        fontSize: 14,
                        color: Palette.AdditionText,
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, '??????????????????'),
                        child: const Text(
                          '??????????????????',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, '??????????????????');
                          tripStepperViewModel.deleteDay(days, trip);
                        },
                        child: const Text(
                          '??????????????????',
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
  SlidableController slidableController,
  List<int> days,
) {
  _showMoveToModal(
          BuildContext context,
          TripStepperViewModel tripStepperViewModel,
          Trip trip,
          List<int> days,
          TripItem item) =>
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            '???????????? ${item.locationName} ???????????????',
            style: TextStyle(
                color: Palette.BodyText,
                fontSize: 14,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          titlePadding:
              EdgeInsets.symmetric(vertical: getProportionateScreenHeight(20)),
          contentPadding: EdgeInsets.zero,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: days
                .map(
                  (day) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Divider(),
                      ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: day == days[days.length - 1]
                              ? BorderRadius.only(
                                  topLeft: Radius.zero,
                                  bottomLeft: Radius.circular(16),
                                  topRight: Radius.zero,
                                  bottomRight: Radius.circular(16),
                                )
                              : BorderRadius.zero,
                        ),
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        selected: day == tripStepperViewModel.day,
                        selectedTileColor: Palette.SelectedListTileColor,
                        onTap: () {
                          if (day != tripStepperViewModel.day) {
                            tripStepperViewModel.moveTripItemTo(
                                day, trip, item, tripItems);
                            Navigator.pop(context);
                          }
                        },
                        title: Text(
                          '?????????????????? ${day}',
                          style: TextStyle(
                            fontSize: 14,
                            color: day == tripStepperViewModel.day
                                ? Palette.PrimaryColor
                                : Palette.BodyText,
                            fontWeight: day == tripStepperViewModel.day
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      );

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
    enabled: tripItems
                    .where((element) =>
                        element.day == tripStepperViewModel.day &&
                        element.no >= 0)
                    .toList()
                    .length >
                1 &&
            item.no >= 0
        ? true
        : false,
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
                bottom: getProportionateScreenHeight(
                    tripStepperViewModel.recommendToStop(tripItems) == index
                        ? 80
                        : 5),
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
                  '???????????????',
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
        item.drivingDuration == null
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
                ],
              ),
        Container(
          // height: getProportionateScreenHeight(90),
          margin:
              EdgeInsets.symmetric(vertical: getProportionateScreenHeight(5)),
          decoration: BoxDecoration(
            color: item.locationCategory == '??????????????????'
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
                    getProportionateScreenWidth(5),
                    getProportionateScreenHeight(10),
                    0,
                    0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          days.length > 1
                              ? Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          getProportionateScreenWidth(10)),
                                  child: tripItems
                                                  .where((element) =>
                                                      element.day ==
                                                          tripStepperViewModel
                                                              .day &&
                                                      element.no >= 0)
                                                  .toList()
                                                  .length >
                                              1 &&
                                          item.no >= 0
                                      ? IconButton(
                                          onPressed: () => _showMoveToModal(
                                              context,
                                              tripStepperViewModel,
                                              trip,
                                              days,
                                              item),
                                          icon: Icon(
                                            Icons.swap_horiz_rounded,
                                            color: Palette.InfoText,
                                          ),
                                          padding: EdgeInsets.zero,
                                          constraints: BoxConstraints(),
                                        )
                                      : SizedBox(),
                                )
                              : SizedBox(),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            right: getProportionateScreenWidth(10)),
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
                                    ? '?????????????????????'
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
                            Expanded(
                              child: TextButton.icon(
                                icon: Icon(
                                  Icons.place_outlined,
                                  color: Palette.PrimaryColor,
                                  size: 18,
                                ),
                                label: Text(
                                  item.distance == null
                                      ? '?????????????????????????????????'
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
                              onPressed: () => item.duration < 30
                                  ? null
                                  : _showDurationSelectionAlert(context,
                                      tripStepperViewModel, index, tripItems),
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
            '?????????????????? ${day}',
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

Widget addMeal(BuildContext context, TripStepperViewModel tripStepperViewModel,
    int index, List<TripItem> tripItems, Trip trip) {
  return Padding(
    key: UniqueKey(),
    padding: EdgeInsets.only(top: getProportionateScreenHeight(5)),
    child: Row(
      children: [
        Expanded(
          // flex: 2,
          child: ElevatedButton.icon(
            onPressed: () => tripStepperViewModel.goToLocationRecommendPage(
                context, tripItems, index, trip, "??????????????????"),
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            label: Text(
              '??????????????????????????????????????????',
              style: FontAssets.addRestaurantText,
            ),
            style: ElevatedButton.styleFrom(
              primary: Palette.LightSecondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ),
        SizedBox(
          width: getProportionateScreenWidth(5),
        ),
        TextButton.icon(
          onPressed: () =>
              tripStepperViewModel.deleteAddMealButton(index, tripItems),
          icon: Icon(
            Icons.cancel_outlined,
            color: Palette.Outline,
          ),
          label: Text(
            '??????????????????????????????',
            style: FontAssets.bodyText,
          ),
          style: TextButton.styleFrom(
            primary: Palette.BackgroundColor,
          ),
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
          '?????????????????????????????? ????????????????????????',
          style: TextStyle(
              color: Palette.AdditionText,
              fontSize: 14,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(height: getProportionateScreenHeight(5)),
        Text(
          '??????????????????????????????????????????????????????????????????????????????????????????????????????????????????',
          style: TextStyle(color: Palette.AdditionText, fontSize: 12),
        ),
      ],
    ),
  );
}

Widget hourMinute24H(TripStepperViewModel tripStepperViewModel,
    List<TripItem> tripItems, int index) {
  print(index);
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
