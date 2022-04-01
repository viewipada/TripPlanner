import 'package:admin/src/services/login_service.dart';
import 'package:flutter/material.dart';

class LoginViewModel with ChangeNotifier {
  String _userName = '';
  String _password = '';

  void userNameChanged(String value) {
    _userName = value;
    notifyListeners();
  }

  void passwordChanged(String value) {
    _password = value;
    notifyListeners();
  }

  Future<int?> tryToLogin(BuildContext context) async {
    var status = await LoginService().tryToLogin(_userName, _password);
    // if (status == 200) {
    //   goToHomePage(context);
    // }
    return status;
  }

  // void goToHomePage(BuildContext context) {
  //   Navigator.pop(context);
  //   Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => NavigationBarPage(),
  //     ),
  //   );
  // }

  String get userName => _userName;
  String get password => _password;
}
