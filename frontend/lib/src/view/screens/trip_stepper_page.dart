import 'package:enhance_stepper/enhance_stepper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/assets.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/size_config.dart';
import 'package:trip_planner/src/models/trip.dart';
import 'package:trip_planner/src/models/trip_item.dart';
import 'package:trip_planner/src/repository/trips_operations.dart';
import 'package:trip_planner/src/view/widgets/food_step_selection.dart';
import 'package:trip_planner/src/view/widgets/hotel_step_selection.dart';
import 'package:trip_planner/src/view/widgets/loading.dart';
import 'package:trip_planner/src/view/widgets/shopping_step_selection.dart';
import 'package:trip_planner/src/view/widgets/travel_step_selection.dart';
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

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final tripStepperViewModel = Provider.of<TripStepperViewModel>(context);

    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          leading: TextButton(
            onPressed: () => tripStepperViewModel.goBack(context),
            child: Text("บันทึก"),
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(15),
              ),
              alignment: Alignment.centerLeft,
            ),
          ),
          leadingWidth: getProportionateScreenWidth(70),
          title: Text(
            "สร้างทริป",
            style: FontAssets.headingText,
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: buildStepperCustom(context, tripStepperViewModel),
      ),
      onWillPop: () async {
        // tripStepperViewModel.goBack(context);
        return false;
      },
    );
  }

  Widget buildStepperCustom(
      BuildContext context, TripStepperViewModel tripStepperViewModel) {
    late VoidCallback _onStepContinue;
    TripsOperations tripsOperations = TripsOperations();
    Trip trip;

    return Stack(
      children: [
        FutureBuilder(
          future: tripsOperations.getTripById(tripId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = snapshot.data as Trip;
              trip = data;
              List<int> days =
                  List<int>.generate(data.totalDay, (int index) => index + 1);
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
                        content: tripStepperViewModel.index == 0
                            ? TravelStepSelection(
                                tripStepperViewModel: tripStepperViewModel,
                                trip: data,
                                days: days,
                              )
                            : tripStepperViewModel.index == 1
                                ? FutureBuilder(
                                    future: tripStepperViewModel
                                        .getAllTripItemsByTripId(tripId),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        var dataList =
                                            snapshot.data as List<TripItem>;
                                        tripStepperViewModel
                                            .getAllTripItemsByTripId(
                                                trip.tripId!)
                                            .then((value) =>
                                                tripStepperViewModel
                                                    .isStartTimeValid(
                                                        value, days));
                                        return FoodStepSelection(
                                          tripStepperViewModel:
                                              tripStepperViewModel,
                                          tripItems: dataList,
                                          trip: data,
                                          days: days,
                                        );
                                      } else {
                                        return Loading();
                                      }
                                    },
                                  )
                                : tripStepperViewModel.index == 2
                                    ? HotelStepSelection(
                                        tripStepperViewModel:
                                            tripStepperViewModel,
                                        trip: data,
                                        days: days,
                                      )
                                    : FutureBuilder(
                                        future: tripStepperViewModel
                                            .getAllTripItemsByTripId(tripId),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            var dataList =
                                                snapshot.data as List<TripItem>;
                                            return ShoppingStepSelection(
                                              tripStepperViewModel:
                                                  tripStepperViewModel,
                                              trip: data,
                                              tripItems: dataList,
                                            );
                                          } else {
                                            return Loading();
                                          }
                                        },
                                      ),
                      ),
                    )
                    .toList(),
                onStepCancel: () {
                  tripStepperViewModel.go(-1, context, trip);
                },
                onStepContinue: () {
                  tripStepperViewModel.startTimeIsValid
                      ? tripStepperViewModel.go(1, context, trip)
                      : tripStepperViewModel.startPointIsValid
                          ? alertDialog(context,
                              'ตั้งเวลา ณ จุดเริ่มต้น\nเราจะช่วยให้คุณจัดสรรเวลาได้ง่ายขึ้น')
                          : alertDialog(context,
                              'กรุณาเพิ่มที่เที่ยวในแต่ละวัน\nอย่างน้อย 1 ที่เที่ยว');
                },
                onStepTapped: (index) {
                  tripStepperViewModel.setStepOnTapped(index);
                  // print(index);
                },
                controlsBuilder:
                    (BuildContext context, ControlsDetails details) {
                  _onStepContinue = details.onStepContinue!;
                  return SizedBox();
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
              child: Text(
                "ถัดไป",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
      ],
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
