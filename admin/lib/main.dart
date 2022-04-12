import 'package:admin/src/palette.dart';
import 'package:admin/src/view/create_location_page.dart';
import 'package:admin/src/view/dashboard_page.dart';
import 'package:admin/src/view/location_detail_page.dart';
import 'package:admin/src/view/login_page.dart';
import 'package:admin/src/view_models/create_location_view_model.dart';
import 'package:admin/src/view_models/dashboard_view_model.dart';
import 'package:admin/src/view_models/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => DashBoardViewModel()),
        ChangeNotifierProvider(create: (_) => CreateLocationViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'EZtrip Admin',
        theme: ThemeData(
          canvasColor: Colors.white,
          primarySwatch: Palette.primarySwatchColor,
          scaffoldBackgroundColor: Palette.backgroundColor,
          fontFamily: 'Sukhumvit',
          dividerTheme: const DividerThemeData(
            color: Palette.outline,
            space: 0,
            thickness: 1,
          ),
          unselectedWidgetColor: Palette.outline,
          inputDecorationTheme: const InputDecorationTheme(
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: Palette.borderInputColor)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: Palette.webBackground, width: 2)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: Palette.borderInputColor)),
            hintStyle: TextStyle(
              fontSize: 14,
              color: Palette.infoText,
            ),
            contentPadding: EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 15,
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginPage(),
          '/dashboard': (context) => const DashboardPage(),
          '/create': (context) => const CreateLocationPage(),
          LocationDetailPage.route: (context) => const LocationDetailPage(),
        },
      ),
    );
  }
}
