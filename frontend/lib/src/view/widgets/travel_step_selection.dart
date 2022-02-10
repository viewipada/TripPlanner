import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
        ReorderableListView(
          shrinkWrap: true,
          children: <Widget>[
            for (int index = 0;
                index < tripStepperViewModel.items.length;
                index += 1)
              ListTile(
                key: Key('$index'),
                tileColor: tripStepperViewModel.items[index].isOdd
                    ? Colors.amber
                    : Colors.green,
                title: Text('Item ${tripStepperViewModel.items[index]}'),
              ),
          ],
          onReorder: (int oldIndex, int newIndex) {
            tripStepperViewModel.onReorder(oldIndex, newIndex);
          },
        ),
      ],
    );
  }
}
