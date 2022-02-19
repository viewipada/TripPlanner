import 'package:enhance_stepper/enhance_stepper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/assets.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/size_config.dart';
import 'package:trip_planner/src/models/trip.dart';
import 'package:trip_planner/src/repository/trips_operations.dart';
import 'package:trip_planner/src/view/widgets/loading.dart';
import 'package:trip_planner/src/view/widgets/travel_step_selection.dart';
import 'package:trip_planner/src/view/widgets/vehicle_selection.dart';
import 'package:trip_planner/src/view_models/trip_stepper_view_model.dart';

class TripStepperPage extends StatefulWidget {
  TripStepperPage({required this.tripId});
  final int tripId;

  @override
  _TripStepperPageState createState() => _TripStepperPageState(this.tripId);
}

class _TripStepperPageState extends State<TripStepperPage> {
  final int tripId;
  _TripStepperPageState(this.tripId);

  // @override
  // void initState() {
  //   Provider.of<TripStepperViewModel>(context, listen: false)
  //       .getTripById(tripId);
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "สร้างทริป",
          style: FontAssets.headingText,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: buildStepperCustom(context),
    );
  }

  Widget buildStepperCustom(BuildContext context) {
    final tripStepperViewModel = Provider.of<TripStepperViewModel>(context);
    late VoidCallback _onStepContinue;
    late VoidCallback _onStepCancel;
    TripsOperations tripsOperations = TripsOperations();

    return Stack(
      children: [
        FutureBuilder(
          future: tripsOperations.getTripById(tripId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = snapshot.data as Trip;
              return EnhanceStepper(
                stepIconSize: 30,
                type: StepperType.horizontal,
                horizontalTitlePosition: HorizontalTitlePosition.bottom,
                horizontalLinePosition: HorizontalLinePosition.top,
                currentStep: tripStepperViewModel.index,
                physics: ClampingScrollPhysics(),
                steps: tripStepperViewModel.steps
                    .map(
                      (e) => EnhanceStep(
                        icon: Icon(
                          tripStepperViewModel.index ==
                                  tripStepperViewModel.steps.indexOf(e)
                              ? e['iconActived']
                              : e['icon'],
                          color: tripStepperViewModel.index >=
                                  tripStepperViewModel.steps.indexOf(e)
                              ? Palette.PrimaryColor
                              : Palette.InfoText,
                        ),
                        // state: StepState.indexed,
                        isActive: tripStepperViewModel.index ==
                            tripStepperViewModel.steps.indexOf(e),
                        title: Text(
                          e['title'],
                          style: tripStepperViewModel.index >=
                                  tripStepperViewModel.steps.indexOf(e)
                              ? tripStepperViewModel.index ==
                                      tripStepperViewModel.steps.indexOf(e)
                                  ? TextStyle(
                                      color: Palette.PrimaryColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    )
                                  : FontAssets.bodyText
                              : FontAssets.bodyText,
                        ),
                        content: e['title'] == 'พาหนะ'
                            ? VehicleSelection(
                                tripStepperViewModel: tripStepperViewModel,
                                trip: data)
                            : e['title'] == 'ที่เที่ยว'
                                ? TravelStepSelection(
                                    tripStepperViewModel: tripStepperViewModel)
                                : Container(
                                    height: 800,
                                    color: Colors.green,
                                  ),
                      ),
                    )
                    .toList(),
                onStepCancel: () {
                  tripStepperViewModel.go(-1);
                },
                onStepContinue: () {
                  tripStepperViewModel.go(1);
                },
                onStepTapped: (index) {
                  tripStepperViewModel.setStepOnTapped(index);
                  print(index);
                },
                controlsBuilder: (BuildContext context,
                    {VoidCallback? onStepContinue,
                    VoidCallback? onStepCancel}) {
                  _onStepContinue = onStepContinue!;
                  _onStepCancel = onStepCancel!;
                  return SizedBox.shrink();
                },
              );
            } else {
              return Loading();
            }
          },
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
              onPressed: () => _onStepContinue(),
              child: Text("ถัดไป"),
            ),
            //     Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     TextButton(
            //       onPressed: () => _onStepCancel(),
            //       child: Text("Back"),
            //     ),
            //     ElevatedButton(
            //       onPressed: () => _onStepContinue(),
            //       child: Text("Next"),
            //     ),
            //   ],
            // ),
          ),
        ),
      ],
    );
  }
}
