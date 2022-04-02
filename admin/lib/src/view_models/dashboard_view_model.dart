import 'package:flutter/material.dart';

class DashBoardViewModel with ChangeNotifier {
  void goToDashBoard(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
        context, '/dashboard', ModalRoute.withName('/dashboard'));
  }
}
