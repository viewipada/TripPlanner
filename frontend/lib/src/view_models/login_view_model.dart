import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:trip_planner/src/services/profile_service.dart';
import 'package:trip_planner/src/view/screens/on_boarding_page.dart';
import 'package:trip_planner/src/view/screens/pdpa_page.dart';
import 'package:trip_planner/src/view/screens/survey_page.dart';

class LoginViewModel with ChangeNotifier {
  String _userName = '';
  String _password = '';
  String _confirmPassword = '';
  bool _passwordVisible = false;
  String? _gender;
  bool _agree = false;
  DateTime? _date;
  String _startDate = ' วว/ดด/ปป';

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

  void setGenderValue(String value) {
    _gender = value;
    notifyListeners();
  }

  void setAgreeCheckbox(bool value) {
    _agree = value;
    notifyListeners();
  }

  Future pickDate(BuildContext context) async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: _date == null ? DateTime.now() : _date!,
      firstDate: DateTime(DateTime.now().year - 70),
      lastDate: DateTime.now(),
    );

    if (newDate == null) {
      notifyListeners();
      return;
    }
    _date = newDate;
    _startDate = ' ${_date!.day}/${_date!.month}/${_date!.year}';
    notifyListeners();
  }

  bool validateData() {
    if (_startDate == ' วว/ดด/ปป' || _gender == null || _agree == false)
      return false;
    return true;
  }

  Future<int?> tryToRegister(BuildContext context) async {
    var status = await ProfileService().tryToRegister(_userName, _password);
    if (status == 201) {
      goToPdpaPage(context);
    }
    return status;
  }

  Future<int?> tryToLogin(BuildContext context) async {
    var status = await ProfileService().tryToLogin(_userName, _password);
    if (status == 200) {
      goToSurveyPage(context);
    }
    return status;
  }

  void goToPdpaPage(BuildContext context) {
    Navigator.pop(context);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => PdpaPage(),
      ),
    );
  }

  void goToSurveyPage(BuildContext context) {
    Navigator.pop(context);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SurveyPage(),
      ),
    );
  }

  void goToOnboarding(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OnBoardingPage(),
      ),
    );
  }

  String get userName => _userName;
  String get password => _password;
  String get confirmPassword => _confirmPassword;
  bool get passwordVisible => _passwordVisible;
  String? get gender => _gender;
  bool get agree => _agree;
  DateTime? get date => _date;
  String get startDate => _startDate;
}
