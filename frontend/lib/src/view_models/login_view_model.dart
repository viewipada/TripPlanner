import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LoginViewModel with ChangeNotifier {
  String _userName = '';
  String _password = '';
  String _confirmPassword = '';
  bool _passwordVisible = false;

  void userNameChanged(String value) {
    _userName = value;
    notifyListeners();
  }

  void passwordChanged(String value) {
    _password = value;
    notifyListeners();
  }

  void confirmPasswordChanged(String value) {
    _confirmPassword = value;
    notifyListeners();
  }

  String get userName => _userName;
  String get password => _password;
  String get confirmPassword => _confirmPassword;
  bool get passwordVisible => _passwordVisible;
}
