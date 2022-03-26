import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/assets.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/size_config.dart';
import 'package:trip_planner/src/repository/shared_pref.dart';
import 'package:trip_planner/src/view/screens/login_page.dart';
import 'package:trip_planner/src/view/widgets/navigation_bar.dart';
import 'package:trip_planner/src/view_models/baggage_view_model.dart';
import 'package:trip_planner/src/view_models/create_location_view_model.dart';
import 'package:trip_planner/src/view_models/home_view_model.dart';
import 'package:trip_planner/src/view_models/location_detail_view_model.dart';
import 'package:trip_planner/src/view_models/login_view_model.dart';
import 'package:trip_planner/src/view_models/navigation_bar_view_model.dart';
import 'package:trip_planner/src/view_models/profile_view_model.dart';
import 'package:trip_planner/src/view_models/review_view_model.dart';
import 'package:trip_planner/src/view_models/search_start_point_view_model.dart';
import 'package:trip_planner/src/view_models/trip_form_view_model.dart';
import 'package:trip_planner/src/view_models/search_view_model.dart';
import 'package:trip_planner/src/view_models/trip_stepper_view_model.dart';

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
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => CreateLocationViewModel()),
        ChangeNotifierProvider(create: (_) => TripStepperViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'EZtrip',
        theme: ThemeData(
          canvasColor: Colors.white,
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
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: Palette.BorderInputColor)),
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
        home: LogoPage(),
      ),
    );
  }
}

class LogoPage extends StatefulWidget {
  @override
  _LogoPageState createState() => _LogoPageState();
}

class _LogoPageState extends State<LogoPage> {
  var userId;
  @override
  void initState() {
    super.initState();
    setState(() {
      userId = -1;
    });
    Future.delayed(Duration(seconds: 2)).then((value) {
      SharedPref().getUserId().then((value) {
        setState(() {
          userId = value;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    if (userId == -1)
      return Scaffold(
        body: SafeArea(
          child: Container(
            color: Colors.white,
            child: Center(
              child: Image.asset(
                ImageAssets.logo,
                height: getProportionateScreenHeight(150),
                width: getProportionateScreenHeight(150),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      );
    else
      return userId == null ? LoginPage() : NavigationBar();
  }
}
