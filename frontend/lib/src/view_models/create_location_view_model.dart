import 'dart:io';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:trip_planner/src/models/response/location_request_detail_response.dart';
import 'package:trip_planner/src/services/create_location_service.dart';
import 'package:trip_planner/src/view/screens/location_picker_page.dart';

class CreateLocationViewModel with ChangeNotifier {
  File? _images;
  bool? _knowOpeningHour = true;
  List _locationCategory = [
    {'label': 'ที่เที่ยว', 'value': 1},
    {'label': 'ที่กิน', 'value': 2},
    {'label': 'ที่พัก', 'value': 3},
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
  int? _minPrice;
  int? _maxPrice;
  List<String> _openingHour = [];

  Future<void> getLocationRequestById(int locationId) async {
    _locationRequest =
        await CreateLocationService().getLocationRequestById(locationId);

    if (_locationRequest != null) {
      _openingHour.add(_locationRequest!.openingHour.mon);
      _openingHour.add(_locationRequest!.openingHour.tue);
      _openingHour.add(_locationRequest!.openingHour.wed);
      _openingHour.add(_locationRequest!.openingHour.thu);
      _openingHour.add(_locationRequest!.openingHour.fri);
      _openingHour.add(_locationRequest!.openingHour.sat);
      _openingHour.add(_locationRequest!.openingHour.sun);
      _locationName = await _locationRequest!.locationName;
      _imageUrl = await _locationRequest!.imageUrl;
      _contactNumber = await _locationRequest!.contactNumber == "-"
          ? ""
          : _locationRequest!.contactNumber;
      _website = await _locationRequest!.website == "-"
          ? ""
          : _locationRequest!.website;
      _description = await _locationRequest!.description;
      _locationPin =
          await LatLng(_locationRequest!.latitude, _locationRequest!.longitude);
      _locationTypeValue = await _locationRequest!.locationType;
      _provinceValue = await _locationRequest!.province;
      _openingEveryday = await !_openingHour.contains("ปิด");
      _locationCategoryValue = await _locationRequest!.category == 1
          ? "ที่เที่ยว"
          : _locationRequest!.category == 2
              ? "ที่กิน"
              : "ที่พัก";

      for (int i = 0; i < _dayOfWeek.length; i++) {
        if (_openingHour[i] != "ปิด") {
          _dayOfWeek[i]['isOpening'] = true;
          final timeSplit = await _openingHour[i].split(' - ');
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
            ? 1
            : _locationCategoryValue! == "ที่กิน"
                ? 2
                : 3);

      await Future.forEach(_locationCategory, (dynamic element) {
        if (element['label'] == _locationCategoryValue)
          _defaultCategotyValue = element;
      });
      await Future.forEach(_locationType, (dynamic element) {
        if (element['label'] == _locationTypeValue)
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

  void updateMaxPrice(String value) {
    _maxPrice = int.parse(value);
    notifyListeners();
  }

  void updateMinPrice(String value) {
    _minPrice = int.parse(value);
    notifyListeners();
  }

  Future<void> getLocationTypeList(int category) async {
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

  Future<int?> createLocation(BuildContext context) async {
    int _category;
    if (_locationCategoryValue == "ที่เที่ยว")
      _category = 1;
    else if (_locationCategoryValue == "ที่กิน")
      _category = 2;
    else if (_locationCategoryValue == "ที่พัก")
      _category = 3;
    else
      _category = 0;
    final statusCode = await CreateLocationService().createLocation(
        _locationName,
        _category,
        _description,
        _contactNumber,
        _website,
        _locationTypeValue!,
        _images!,
        _locationPin!,
        _provinceValue!,
        _dayOfWeek,
        _minPrice,
        _maxPrice);
    if (statusCode == 201) {
      goBack(context);
    }
    return statusCode;
  }

  Future<int?> updateLocation(BuildContext context, int locationId) async {
    int _category;
    if (_locationCategoryValue == "ที่เที่ยว")
      _category = 1;
    else if (_locationCategoryValue == "ที่กิน")
      _category = 2;
    else if (_locationCategoryValue == "ที่พัก")
      _category = 3;
    else
      _category = 0;

    if (imageUrl != null) _images = await urlToFile(imageUrl!);
    final statusCode = await CreateLocationService().updateLocation(
        locationId,
        _locationName,
        _category,
        _description,
        _contactNumber,
        _website,
        _locationTypeValue!,
        _images!,
        _locationPin!,
        _provinceValue!,
        _dayOfWeek,
        _minPrice,
        _maxPrice);
    if (statusCode == 200) {
      goBack(context);
    }
    return statusCode;
  }

  Future<File> urlToFile(String imageUrl) async {
// generate random number.
    var rng = new Random();
// get temporary directory of device.
    Directory tempDir = await getTemporaryDirectory();
// get temporary path from temporary directory.
    String tempPath = tempDir.path;
// create a new file in temporary path with random file name.
    File file = new File('$tempPath' + (rng.nextInt(100)).toString() + '.png');
// call http.get method and pass imageUrl into it to get response.
    http.Response response = await http.get(Uri.parse(imageUrl));
// write bodyBytes received in response to file.
    await file.writeAsBytes(response.bodyBytes);
// now return the file which is created with random name in
// temporary directory and image bytes from response is written to // that file.
    return file;
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
  int? get minPrice => _minPrice;
  int? get maxPrice => _maxPrice;
}
