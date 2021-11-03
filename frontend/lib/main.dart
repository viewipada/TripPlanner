import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/src/view/widgets/navigation_bar.dart';
import 'package:trip_planner/src/view_models/baggage_view_model.dart';
import 'package:trip_planner/src/view_models/home_view_model.dart';
import 'package:trip_planner/src/view_models/location_detail_view_model.dart';
import 'package:trip_planner/src/view_models/navigation_bar_view_model.dart';
import 'package:trip_planner/src/view_models/review_view_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BaggageViewModel()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => NavigationBarViewModel()),
        ChangeNotifierProvider(create: (_) => LocationDetailViewModel()),
        ChangeNotifierProvider(create: (_) => ReviewViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'EZtrip',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Palette.BackgroundColor,
          fontFamily: 'Sukhumvit',
          dividerTheme: DividerThemeData(
            color: Palette.Outline,
            space: 0,
            thickness: 1,
          ),
          unselectedWidgetColor: Palette.Outline,
        ),
        home: NavigationBar(),
      ),
    );
  }
}
