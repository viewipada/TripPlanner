import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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
  });

  final TripStepperViewModel tripStepperViewModel;
  final Trip trip;

  @override
  _ShoppingStepSelectionState createState() =>
      _ShoppingStepSelectionState(this.tripStepperViewModel, this.trip);
}

class _ShoppingStepSelectionState extends State<ShoppingStepSelection> {
  final TripStepperViewModel tripStepperViewModel;
  List<TripItem> tripItems = [];
  final Trip trip;

  _ShoppingStepSelectionState(this.tripStepperViewModel, this.trip);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
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
        // instruction(),
        FutureBuilder(
          future: tripStepperViewModel.getAllShop(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print(tripStepperViewModel.shop);
              var dataList = snapshot.data as List<ShopResponse>;
              return Column(
                children: dataList
                    .map((item) => buildShopCard(tripStepperViewModel, item))
                    .toList(),
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

Widget buildShopCard(
    TripStepperViewModel tripStepperViewModel, ShopResponse item) {
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
