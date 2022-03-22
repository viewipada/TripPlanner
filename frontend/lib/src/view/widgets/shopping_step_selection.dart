import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/assets.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/size_config.dart';
import 'package:trip_planner/src/models/response/shop_response.dart';
import 'package:trip_planner/src/models/trip.dart';
import 'package:trip_planner/src/models/trip_item.dart';
import 'package:trip_planner/src/view/widgets/loading.dart';
import 'package:trip_planner/src/view_models/trip_stepper_view_model.dart';

class ShoppingStepSelection extends StatefulWidget {
  ShoppingStepSelection({
    required this.tripStepperViewModel,
    required this.trip,
    required this.tripItems,
  });

  final TripStepperViewModel tripStepperViewModel;
  final Trip trip;
  final List<TripItem> tripItems;

  @override
  _ShoppingStepSelectionState createState() => _ShoppingStepSelectionState(
      this.tripStepperViewModel, this.trip, this.tripItems);
}

class _ShoppingStepSelectionState extends State<ShoppingStepSelection> {
  final TripStepperViewModel tripStepperViewModel;
  final List<TripItem> tripItems;
  final Trip trip;

  _ShoppingStepSelectionState(
      this.tripStepperViewModel, this.trip, this.tripItems);

  @override
  void initState() {
    Provider.of<TripStepperViewModel>(context, listen: false)
        .getDaySelected(trip.totalDay);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    List<int> days =
        List<int>.generate(trip.totalDay, (int index) => index + 1);

    _showDayChangeModal(BuildContext context,
            TripStepperViewModel tripStepperViewModel, List<int> days) =>
        showDialog(
          context: context,
          builder: (context) => StatefulBuilder(
            builder: (context, setState) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
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
                              borderRadius: days.length == 1
                                  ? BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      bottomLeft: Radius.circular(16),
                                      topRight: Radius.circular(16),
                                      bottomRight: Radius.circular(16),
                                    )
                                  : day == days[days.length - 1]
                                      ? BorderRadius.only(
                                          topLeft: Radius.zero,
                                          bottomLeft: Radius.circular(16),
                                          topRight: Radius.zero,
                                          bottomRight: Radius.circular(16),
                                        )
                                      : day == days[0]
                                          ? BorderRadius.only(
                                              bottomLeft: Radius.zero,
                                              topLeft: Radius.circular(16),
                                              bottomRight: Radius.zero,
                                              topRight: Radius.circular(16),
                                            )
                                          : BorderRadius.zero,
                            ),
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                            selected: day == tripStepperViewModel.daySelected,
                            selectedTileColor: Palette.SelectedListTileColor,
                            onTap: () {
                              tripStepperViewModel.changeDay(day);
                              Navigator.pop(context);
                            },
                            title: Text(
                              'วันที่ ${day}',
                              style: TextStyle(
                                fontSize: 14,
                                color: day == tripStepperViewModel.daySelected
                                    ? Palette.PrimaryColor
                                    : Palette.BodyText,
                                fontWeight:
                                    day == tripStepperViewModel.daySelected
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
          ),
        );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ต้องการซื้อของฝากหรือไม่',
          style: FontAssets.subtitleText,
        ),
        SizedBox(
          height: getProportionateScreenHeight(5),
        ),
        Text(
          'หากไม่ต้องการ กด "ถัดไป" เพื่อไปยังหน้ายืนยันสร้างทริป',
          style: FontAssets.bodyText,
        ),
        SizedBox(
          height: getProportionateScreenHeight(15),
        ),
        FutureBuilder(
          future: tripStepperViewModel.getAllShop(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print(tripStepperViewModel.shop);
              var dataList = snapshot.data as List<ShopResponse>;
              // shopList = dataList;
              return Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(
                      bottom: getProportionateScreenHeight(5),
                    ),
                    child: OutlinedButton(
                      onPressed: () =>
                          tripStepperViewModel.goToShopLocationOnRoutePage(
                              context, tripItems, dataList, days),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: getProportionateScreenHeight(10)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.map_outlined),
                            Text(
                              ' ดูตำแหน่งบนแผนที่',
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'กดปุ่ม + เพื่อเพิ่มร้านของฝากไปยัง',
                        style: FontAssets.bodyText,
                      ),
                      TextButton(
                        onPressed: () => _showDayChangeModal(
                            context, tripStepperViewModel, days),
                        child: Text(
                          'วันที่ ${tripStepperViewModel.daySelected}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: dataList
                        .map((item) =>
                            buildShopCard(tripStepperViewModel, item, context))
                        .toList(),
                  )
                ],
              );
            } else {
              return Loading();
            }
          },
        ),
        SizedBox(
          height: getProportionateScreenHeight(55),
        ),
      ],
    );
  }
}

Widget buildShopCard(TripStepperViewModel tripStepperViewModel,
    ShopResponse item, BuildContext context) {
  return Container(
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
          offset: Offset(2, 4),
        ),
      ],
    ),
    child: Stack(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      item.locationName,
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
                        children: [
                          Text(
                            '${item.rating} ',
                            style: FontAssets.hintText,
                          ),
                          RatingBarIndicator(
                            unratedColor: Palette.Outline,
                            rating: item.rating,
                            itemBuilder: (context, index) => Icon(
                              Icons.star_rounded,
                              color: Palette.CautionColor,
                            ),
                            itemCount: 5,
                            itemSize: 16,
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
        Positioned(
          bottom: getProportionateScreenHeight(10),
          right: 0,
          child: ElevatedButton(
            onPressed: () => tripStepperViewModel.selectShop(item),
            child: Icon(
                tripStepperViewModel.shop == null
                    ? Icons.add
                    : tripStepperViewModel.shop!.locationId == item.locationId
                        ? Icons.remove
                        : Icons.add,
                color: Colors.white),
            style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                primary: tripStepperViewModel.shop == null
                    ? Palette.PrimaryColor
                    : tripStepperViewModel.shop!.locationId == item.locationId
                        ? Palette.SecondaryColor
                        : Palette.PrimaryColor),
          ),
        ),
      ],
    ),
  );
}

Widget instruction() {
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
          ' เลือก ร้านขายของฝาก สักร้านสิ',
          style: TextStyle(
              color: Palette.LightOrangeColor,
              fontWeight: FontWeight.bold,
              fontSize: 12),
        ),
      ],
    ),
  );
}
