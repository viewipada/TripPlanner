import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:trip_planner/src/services/create_location_service.dart';

class CreateLocationViewModel with ChangeNotifier {
  File? _images;
  bool? _knowOpeningHour = true;
  List _locationCategory = [
    {'label': 'ที่เที่ยว', 'value': 'travel'},
    {'label': 'ที่กิน', 'value': 'food'},
    {'label': 'ที่พัก', 'value': 'hotel'},
  ];
  List _locationType = [];
  List _dayOfWeek = [
    {
      'day': 'วันจันทร์',
      'isOpening': false,
      'openTime': '9:00',
      'closedTime': '16:00'
    },
    {
      'day': 'วันอังคาร',
      'isOpening': false,
      'openTime': '9:00',
      'closedTime': '16:00'
    },
    {
      'day': 'วันพุธ',
      'isOpening': false,
      'openTime': '9:00',
      'closedTime': '16:00'
    },
    {
      'day': 'วันพฤหัสบดี',
      'isOpening': false,
      'openTime': '9:00',
      'closedTime': '16:00'
    },
    {
      'day': 'วันศุกร์',
      'isOpening': false,
      'openTime': '9:00',
      'closedTime': '16:00'
    },
    {
      'day': 'วันเสาร์',
      'isOpening': false,
      'openTime': '9:00',
      'closedTime': '16:00'
    },
    {
      'day': 'วันอาทิตย์',
      'isOpening': false,
      'openTime': '9:00',
      'closedTime': '16:00'
    },
  ];
  bool _openingEveryday = false;
  String? _locationCategoryValue;
  String? _locationTypeValue;
  String? _provinceValue;
  bool _locationCategoryValid = true;
  bool _locationTypeValid = true;
  bool _provinceValid = true;
  // bool _isSameHour = false;
  // TimeOfDay _openTime = TimeOfDay(hour: 14, minute: 0);

  Future pickImageFromSource(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) {
        notifyListeners();
        return;
      }
      _images = File(image.path);
      notifyListeners();
    } on PlatformException catch (e) {
      print('Failed to pick image $e form ${source}');
    }
  }

  void setKnowOpeningHourValue(bool? value) {
    _knowOpeningHour = value;
    if (!_knowOpeningHour!) {
      _openingEveryday = false;
      _dayOfWeek.forEach((element) {
        element['isOpening'] = false;
        element['openTime'] = '9:00';
        element['closedTime'] = '16:00';
      });
    }
    notifyListeners();
  }

  void switchIsOpening(day, bool value) async {
    day['isOpening'] = await value;
    if (!day['isOpening']) {
      _openingEveryday = false;
      day['openTime'] = '9:00';
      day['closedTime'] = '16:00';
    } else {
      _openingEveryday = _dayOfWeek.every((element) => element['isOpening']);
    }
    notifyListeners();
  }

  void setOpeningEveryday(bool value) {
    _openingEveryday = value;
    _dayOfWeek.forEach((element) {
      element['isOpening'] = value;
      if (!value) {
        element['openTime'] = '9:00';
        element['closedTime'] = '16:00';
      }
    });
    notifyListeners();
  }

  // void setIsSameHour(bool value) {
  //   _isSameHour = value;
  //   notifyListeners();
  // }

  Future<String> selectTime(BuildContext context, time) async {
    TimeOfDay _initialTime = TimeOfDay(
        hour: int.parse(time.split(":")[0]),
        minute: int.parse(time.split(":")[1]));
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _initialTime,
      // builder: (context, child) => MediaQuery(
      //     data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
      //     child: child!),
    );
    if (newTime != null) {
      _initialTime = newTime;
      DateTime datetime =
          DateFormat.jm().parse(_initialTime.format(context).toString());

      return DateFormat("HH:mm").format(datetime).toString();
    }
    return time;
  }

  void updateOpeningHour(day, String openTime, String closedTime) {
    day['openTime'] = openTime;
    day['closedTime'] = closedTime;
    notifyListeners();
  }

  Future<void> getLocationTypeList(String category) async {
    _locationType = await CreateLocationService().getLocationTypeList(category);
    notifyListeners();
  }

  void updateLocationCategoryValue(String category) {
    _locationCategoryValue = category;
    notifyListeners();
  }

  void updateLocationTypeValue(String type) {
    _locationTypeValue = type;
    notifyListeners();
  }

  void updateProvinceValue(String province) {
    _provinceValue = province;
    notifyListeners();
  }

  bool validateDropdown() {
    _locationCategoryValid = _locationCategoryValue != null;
    _locationTypeValid = _locationTypeValue != null;
    _provinceValid = _provinceValue != null;
    print(_locationCategoryValid);
    print(_locationTypeValid);
    print(_provinceValid);
    notifyListeners();

    if (_locationCategoryValue == null ||
        _locationTypeValue == null ||
        _provinceValue == null) {
      return false;
    }

    return true;
  }
  // void deleteImage(File image) {
  //   _images.remove(image);
  //   notifyListeners();
  // }

  // void goBack(BuildContext context) {
  //   _images = [];
  //   Navigator.pop(context);
  // }

  File? get images => _images;
  bool? get knowOpeningHour => _knowOpeningHour;
  List get dayOfWeek => _dayOfWeek;
  bool get openingEveryday => _openingEveryday;
  List get locationCategory => _locationCategory;
  List get locationType => _locationType;
  String? get locationCategoryValue => _locationCategoryValue;
  String? get locationTypeValue => _locationTypeValue;
  String? get provinceValue => _provinceValue;
  bool get locationCategoryValid => _locationCategoryValid;
  bool get locationTypeValid => _locationTypeValid;
  bool get provinceValid => _provinceValid;
  // bool get isSameHour => _isSameHour;
}
