import 'package:admin/src/assets.dart';
import 'package:admin/src/palette.dart';
import 'package:admin/src/size_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    // final loginViewModel = Provider.of<LoginViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Text(
              "EZtrip",
              style: FontAssets.headingText,
            ),
            Text(
              " Admin",
              style: TextStyle(
                fontSize: 20,
                color: Palette.webText,
              ),
            )
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(children: const [Text('รอตรวจสอบ')]),
    );
  }
}
