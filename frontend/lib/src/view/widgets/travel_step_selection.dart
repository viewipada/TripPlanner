import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
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
                buildTripItem(index, tripStepperViewModel),
            proxyDecorator:
                (Widget child, int index, Animation<double> animation) {
              return Material(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 0,
                        blurRadius: 1,
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

Widget buildTripItem(int index, TripStepperViewModel tripStepperViewModel) {
  return Container(
    // height: getProportionateScreenHeight(90),
    key: Key('$index'),
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
                        '${tripStepperViewModel.items[index]['startTime']}',
                        style: FontAssets.hintText,
                      ),
                      style: ButtonStyle(
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent),
                        padding: MaterialStateProperty.all(EdgeInsets.zero),
                        alignment: Alignment.bottomLeft,
                      ),
                      onPressed: () => print('time'),
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
  );
}
