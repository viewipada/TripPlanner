import 'package:flutter/material.dart';
import 'package:trip_planner/src/screens/baggage.dart';
import 'package:trip_planner/src/screens/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EZtrip',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Baggage(),
    );
  }
}
