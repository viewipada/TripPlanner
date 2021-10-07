import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/src/view/screens/baggage_page.dart';
import 'package:trip_planner/src/view/screens/home_page.dart';
import 'package:trip_planner/src/view_models/baggage_view_model.dart';

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
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'EZtrip',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Roboto',
          dividerTheme: DividerThemeData(
            color: Palette.Outline,
            space: 0,
          ),
          unselectedWidgetColor: Palette.Outline,
        ),
        home: HomePage(),
      ),
    );
  }
}
