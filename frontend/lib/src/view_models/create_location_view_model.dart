import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:trip_planner/src/models/response/location_request_detail_response.dart';
import 'package:trip_planner/src/services/create_location_service.dart';
import 'package:trip_planner/src/view/screens/location_picker_page.dart';

class CreateLocationViewModel with ChangeNotifier {
  File? _images;
  bool? _knowOpeningHour = true;
  List _locationCategory = [
    {'label': 'ที่เที่ยว', 'value': 'travel'}, //1
    {'label': 'ที่กิน', 'value': 'food'}, //2
    {'label': 'ที่พัก', 'value': 'hotel'}, //3
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
  List _provinceList = [
    {'label': 'อ่างทอง', 'value': LatLng(14.589605, 100.455055)}
  ];
  LatLng? _provinceLatLng;
  bool _openingEveryday = false;
  String? _locationCategoryValue;
  String? _locationTypeValue;
  String? _provinceValue;
  bool _locationCategoryValid = true;
  bool _locationTypeValid = true;
  bool _provinceValid = true;
  LatLng? _locationPin;
  bool _locationPinValid = true;
  // bool _isSameHour = false;
  // TimeOfDay _openTime = TimeOfDay(hour: 14, minute: 0);
  LocationRequestDetailResponse? _locationRequest;
  String _locationName = '';
  String _description = '';
  String _contactNumber = '';
  String _website = '';
  String? _imageUrl;
  dynamic _defaultCategotyValue;
  dynamic _defaultLocationTypeValue;

  Future<void> getLocationRequestById(int locationId) async {
    _locationRequest =
        await CreateLocationService().getLocationRequestById(locationId);

    if (_locationRequest != null) {
      _locationName = await _locationRequest!.locationName;
      _imageUrl = await _locationRequest!.imageUrl;
      _contactNumber = await _locationRequest!.contactNumber;
      _website = await _locationRequest!.website;
      _description = await _locationRequest!.description;
      _locationPin =
          await LatLng(_locationRequest!.latitude, _locationRequest!.longitude);
      // _locationTypeValue = _locationRequest!.locationType; //รอ api จริง
      _locationTypeValue = "1";
      _provinceValue = await _locationRequest!.province;
      _openingEveryday = await !_locationRequest!.openingHour.contains("ปิด");
      _locationCategoryValue = await _locationRequest!.category == 1
          ? "ที่เที่ยว"
          : _locationRequest!.category == 2
              ? "ที่กิน"
              : "ที่พัก";

      for (int i = 0; i < _dayOfWeek.length; i++) {
        if (_locationRequest!.openingHour[i] != "ปิด") {
          _dayOfWeek[i]['isOpening'] = true;
          final timeSplit = await _locationRequest!.openingHour[i]
              .split('-'); // รอดู api จริงว่ามีเว้นวรรคก่อนหลัง - ไหม
          _dayOfWeek[i]['openTime'] = await timeSplit.first;
          _dayOfWeek[i]['closedTime'] = await timeSplit.last;
        }
      }
      _provinceLatLng =
          await LatLng(_locationRequest!.latitude, _locationRequest!.longitude);

      _locationCategoryValid = await _locationCategoryValue != null;
      _locationTypeValid = await _locationTypeValue != null;
      _provinceValid = await _provinceValue != null;

      if (_locationCategoryValue != null)
        await getLocationTypeList(_locationCategoryValue! == "ที่เที่ยว"
            ? "travel"
            : _locationCategoryValue! == "ที่กิน"
                ? "food"
                : "hotel");

      _locationCategory.forEach((element) {
        if (element['label'] == _locationCategoryValue)
          _defaultCategotyValue = element;
      });

      _locationType.forEach((element) {
        if (element['value'] == _locationTypeValue)
          _defaultLocationTypeValue = element;
      });
    }
    notifyListeners();
  }

  Future pickImageFromSource(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) {
        notifyListeners();
        return;
      }
      _images = File(image.path);
      _imageUrl = null;
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

  void updateLocationName(String locationName) {
    _locationName = locationName;
    notifyListeners();
  }

  void updateDescription(String description) {
    _description = description;
    notifyListeners();
  }

  void updateContactNumber(String contactNumber) {
    _contactNumber = contactNumber;
    notifyListeners();
  }

  void updateWebsite(String website) {
    _website = website;
    notifyListeners();
  }

  void updateOpeningHour(day, String openTime, String closedTime) {
    day['openTime'] = openTime;
    day['closedTime'] = closedTime;
    notifyListeners();
  }

  Future<void> getLocationTypeList(String category) async {
    _locationType = [];
    _locationType = await CreateLocationService().getLocationTypeList(category);
    notifyListeners();
  }

  void updateLocationCategoryValue(String category) {
    _locationCategoryValue = category;
    _locationTypeValue = null;
    _defaultLocationTypeValue = null;
    notifyListeners();
  }

  void updateLocationTypeValue(String type) {
    _locationTypeValue = type;
    notifyListeners();
  }

  void updateProvinceValue(province) {
    _provinceValue = province['label'];
    _provinceLatLng = province['value'];
    notifyListeners();
  }

  bool validateDropdown() {
    _locationCategoryValid = _locationCategoryValue != null;
    _locationTypeValid = _locationTypeValue != null;
    _provinceValid = _provinceValue != null;
    // print(_locationCategoryValid);
    // print(_locationTypeValid);
    // print(_provinceValid);
    notifyListeners();

    if (_locationCategoryValue == null ||
        _locationTypeValue == null ||
        _provinceValue == null) {
      return false;
    }

    return true;
  }

  bool validateOpeningHour() {
    bool _isValid = false;
    _dayOfWeek.forEach((element) {
      if (element['isOpening'] == true) {
        _isValid = true;
        return;
      }
    });
    return _isValid;
  }

  bool validateLocationPin() {
    if (_locationPin == null)
      _locationPinValid = false;
    else
      _locationPinValid = true;

    return _locationPinValid;
  }

  void goToLocationPickerPage(
      BuildContext context, LatLng initialLatLng) async {
    LatLng result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              LocationPickerPage(initialLatLng: initialLatLng),
        ));
    _locationPin = result;
    notifyListeners();
  }

  void selectedLocationPin(BuildContext context, LatLng locationPin) {
    Navigator.pop(context, locationPin);
  }

  Future goToNewLocationPinWithSearch(
      _controller, LatLng searchLocation) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLng(searchLocation));
  }

  void goBack(BuildContext context) {
    _images = null;
    _knowOpeningHour = true;
    _locationType = [];
    _dayOfWeek = [
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
    _provinceLatLng = null;
    _openingEveryday = false;
    _locationCategoryValue = null;
    _locationTypeValue = null;
    _provinceValue = null;
    _locationCategoryValid = true;
    _locationTypeValid = true;
    _provinceValid = true;
    _locationPin = null;
    _locationPinValid = true;
    Navigator.pop(context);
  }

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
  bool get locationPinValid => _locationPinValid;
  List get provinceList => _provinceList;
  LatLng? get provinceLatLng => _provinceLatLng;
  LatLng? get locationPin => _locationPin;
  // bool get isSameHour => _isSameHour;
  LocationRequestDetailResponse? get locationRequest => _locationRequest;
  String get locationName => _locationName;
  String get description => _description;
  String get contactNumber => _contactNumber;
  String get website => _website;
  String? get imageUrl => _imageUrl;
  dynamic get defaultCategotyValue => _defaultCategotyValue;
  dynamic get defaultLocationTypeValue => _defaultLocationTypeValue;
}
