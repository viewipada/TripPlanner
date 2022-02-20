import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/assets.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/size_config.dart';
import 'package:trip_planner/src/models/trip.dart';
import 'package:trip_planner/src/view/widgets/loading.dart';
import 'package:trip_planner/src/view_models/trip_stepper_view_model.dart';

class VehicleSelection extends StatefulWidget {
  VehicleSelection({required this.tripStepperViewModel, required this.trip});

  final TripStepperViewModel tripStepperViewModel;
  final Trip trip;

  @override
  _VehicleSelectionState createState() =>
      _VehicleSelectionState(this.tripStepperViewModel, this.trip);
}

class _VehicleSelectionState extends State<VehicleSelection> {
  final TripStepperViewModel tripStepperViewModel;
  final Trip trip;
  _VehicleSelectionState(this.tripStepperViewModel, this.trip);

  // @override
  // void initState() {
  //   Provider.of<TripStepperViewModel>(context, listen: false)
  //       .getVehicleSelection(trip);
  //   super.initState();
  // }

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
        FutureBuilder(
          future: tripStepperViewModel.getVehicleSelection(trip),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = snapshot.data as List;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: data
                    .map(
                      (e) => Container(
                        child: Column(
                          children: [
                            ListTile(
                              leading:
                                  e['icon'] == Icons.directions_bike_outlined
                                      ? Icon(
                                          e['icon'],
                                          size: 22,
                                        )
                                      : Icon(e['icon']),
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
                              onTap: () =>
                                  tripStepperViewModel.selectedVehicle(e, trip),
                            ),
                            Divider(),
                          ],
                        ),
                        color: Colors.white,
                      ),
                    )
                    .toList(),
              );
            } else {
              return Loading();
            }
          },
        ),
      ],
    );
  }
}
