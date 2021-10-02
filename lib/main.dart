import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/src/notifiers/baggage_notifier.dart';
import 'package:trip_planner/src/view/screens/baggage.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BaggageNotifire()),
      ],
      child: MyApp(),
    ),
  );
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
