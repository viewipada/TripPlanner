import 'package:enhance_stepper/enhance_stepper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/assets.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/size_config.dart';
import 'package:trip_planner/src/view_models/trip_stepper_view_model.dart';

class TripStepperPage extends StatefulWidget {
  // TripStepperPage({Key? key, required this.title}) : super(key: key);

  // final String title;

  @override
  _TripStepperPageState createState() => _TripStepperPageState();
}

class _TripStepperPageState extends State<TripStepperPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "สร้างทริป",
          style: FontAssets.headingText,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        // actions: [
        //   TextButton(
        //       onPressed: () {
        //         print("change");
        //         setState(() {
        //           _type = _type == StepperType.vertical
        //               ? StepperType.horizontal
        //               : StepperType.vertical;
        //         });
        //       },
        //       child: Icon(
        //         Icons.change_circle_outlined,
        //         color: Colors.blue,
        //       )),
        // ],
      ),
      body: buildStepperCustom(context),
    );
  }

  Widget buildStepperCustom(BuildContext context) {
    SizeConfig().init(context);
    final tripStepperViewModel = Provider.of<TripStepperViewModel>(context);

    return Container(
      // color: Colors.amber,
      child: EnhanceStepper(
        // stepIconSize: 30,
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
                content: Container(
                  height: 500,
                  child: Text(
                      "Content for Step ${tripStepperViewModel.steps.indexOf(e)}"),
                  // color: Colors.green,
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
            {VoidCallback? onStepContinue, VoidCallback? onStepCancel}) {
          return Row(
            children: [
              SizedBox(
                height: 30,
              ),
              TextButton(
                onPressed: onStepCancel,
                child: Text("Back"),
              ),
              SizedBox(
                width: 8,
              ),
              ElevatedButton(
                onPressed: onStepContinue,
                child: Text("Next"),
              ),
            ],
          );
        },
      ),
    );
  }
}
