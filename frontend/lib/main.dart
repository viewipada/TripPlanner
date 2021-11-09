import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/src/view/widgets/navigation_bar.dart';
import 'package:trip_planner/src/view_models/baggage_view_model.dart';
import 'package:trip_planner/src/view_models/home_view_model.dart';
import 'package:trip_planner/src/view_models/location_detail_view_model.dart';
import 'package:trip_planner/src/view_models/navigation_bar_view_model.dart';
import 'package:trip_planner/src/view_models/review_view_model.dart';
import 'package:trip_planner/src/view_models/search_start_point_view_model.dart';
import 'package:trip_planner/src/view_models/trip_form_view_model.dart';
import 'package:trip_planner/src/view_models/search_view_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BaggageViewModel()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => NavigationBarViewModel()),
        ChangeNotifierProvider(create: (_) => LocationDetailViewModel()),
        ChangeNotifierProvider(create: (_) => ReviewViewModel()),
        ChangeNotifierProvider(create: (_) => TripFormViewModel()),
        ChangeNotifierProvider(create: (_) => SearchStartPointViewModel()),
        ChangeNotifierProvider(create: (_) => SearchViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'EZtrip',
        theme: ThemeData(
          primarySwatch: Palette.PrimarySwatchColor,
          scaffoldBackgroundColor: Palette.BackgroundColor,
          fontFamily: 'Sukhumvit',
          dividerTheme: DividerThemeData(
            color: Palette.Outline,
            space: 0,
            thickness: 1,
          ),
          unselectedWidgetColor: Palette.Outline,
          inputDecorationTheme: InputDecorationTheme(
            enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: Palette.BorderInputColor)),
            focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: Palette.PrimaryColor, width: 2)),
            border: OutlineInputBorder(),
            hintStyle: TextStyle(
              fontSize: 14,
              color: Palette.InfoText,
            ),
            contentPadding: EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 15,
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        home: NavigationBar(),
      ),
    );
  }
}
