import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trip_planner/assets.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/size_config.dart';
import 'package:trip_planner/src/view_models/trip_stepper_view_model.dart';

class VehicleSelection extends StatelessWidget {
  VehicleSelection({required this.tripStepperViewModel});

  final TripStepperViewModel tripStepperViewModel;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'เลือกยานพาหนะ',
          style: FontAssets.subtitleText,
        ),
        SizedBox(
          height: getProportionateScreenHeight(15),
        ),
        Column(
          children: tripStepperViewModel.vehicles
              .map((e) => Column(
                    children: [
                      ListTile(
                        tileColor: Colors.white,
                        leading: e['icon'],
                        title: Text(
                          e['title'],
                          style: e['isSelected']
                              ? TextStyle(
                                  color: Palette.AdditionText,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14)
                              : FontAssets.bodyText,
                        ),
                        trailing: e['isSelected']
                            ? Icon(
                                Icons.check_circle_outline_rounded,
                                color: Palette.PrimaryColor,
                              )
                            : null,
                        onTap: () => tripStepperViewModel.selectedVehicle(e),
                      ),
                      Divider(),
                    ],
                  ))
              .toList(),
        ),
      ],
    );
  }
}
