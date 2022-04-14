import 'dart:typed_data';

import 'package:admin/src/services/create_location_service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:intl/intl.dart';
import 'dart:html' as html;

import 'package:mime_type/mime_type.dart';
import 'package:path/path.dart' as path;

class CreateLocationViewModel with ChangeNotifier {
  bool? _knowOpeningHour = true;
  final List _locationCategory = [
    {'label': 'ที่เที่ยว', 'value': 1},
    {'label': 'ที่กิน', 'value': 2},
    {'label': 'ที่พัก', 'value': 3},
    {'label': 'ของฝาก', 'value': 4},
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
  final List _provinceList = [
    {'label': 'อ่างทอง', 'value': const LatLng(14.589605, 100.455055)}
  ];
  LatLng? _provinceLatLng;
  bool _openingEveryday = false;
  String? _locationCategoryValue;
  String? _locationTypeValue;
  String? _provinceValue;
  bool _locationCategoryValid = true;
  bool _locationTypeValid = true;
  bool _provinceValid = true;
  double? _latitude;
  double? _longitude;
  String _locationName = '';
  String _description = '';
  String _contactNumber = '';
  String _website = '';
  dynamic _defaultCategotyValue;
  dynamic _defaultLocationTypeValue;
  int? _minPrice;
  int? _maxPrice;

  Uint8List? _fileBytes;
  String? _fileName;

  // Future pickImageFromSource(ImageSource source) async {
  //   try {
  //     final image = await ImagePicker().pickImage(source: source);
  //     if (image == null) {
  //       notifyListeners();
  //       return;
  //     }
  //     _images = File(image.path);
  //     _imageUrl = null;
  //     notifyListeners();
  //   } on PlatformException catch (e) {
  //     print('Failed to pick image $e form ${source}');
  //   }
  // }

  Future<void> pickImage() async {
    var mediaData = await ImagePickerWeb.getImageInfo;
    var mimeType = mime(path.basename(mediaData!.fileName!));
    var mediaFile =
        html.File(mediaData.data!, mediaData.fileName!, {'type': mimeType});

    if (mediaFile != null) {
      _fileBytes = mediaData.data;
      _fileName = mediaData.fileName;
      notifyListeners();
    }
  }

  void setKnowOpeningHourValue(bool? value) {
    _knowOpeningHour = value;
    if (!_knowOpeningHour!) {
      _openingEveryday = false;
      for (var element in _dayOfWeek) {
        element['isOpening'] = false;
        element['openTime'] = '9:00';
        element['closedTime'] = '16:00';
      }
    }
    notifyListeners();
  }

  void switchIsOpening(day, bool value) {
    day['isOpening'] = value;
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
    for (var element in _dayOfWeek) {
      element['isOpening'] = value;
      if (!value) {
        element['openTime'] = '9:00';
        element['closedTime'] = '16:00';
      }
    }
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

  void updateLatitude(String value) {
    _latitude = double.parse(value);
    notifyListeners();
  }

  void updateLongitude(String value) {
    _longitude = double.parse(value);
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

  Future<int?> createLocation(BuildContext context) async {
    int _category;
    if (_locationCategoryValue == "ที่เที่ยว") {
      _category = 1;
    } else if (_locationCategoryValue == "ที่กิน") {
      _category = 2;
    } else if (_locationCategoryValue == "ที่พัก") {
      _category = 3;
    } else {
      _category = 4;
    }
    final statusCode = await CreateLocationService().createLocation(
        _locationName,
        _category,
        _description,
        _contactNumber,
        _website,
        _locationTypeValue!,
        _fileBytes!,
        _latitude!,
        _longitude!,
        _provinceValue!,
        _dayOfWeek,
        _fileName!,
        _minPrice,
        _maxPrice);
    if (statusCode == 201) {
      goBack(context);
    }
    return statusCode;
    // return null;
  }

//   Future<File> urlToFile(String imageUrl) async {
// // generate random number.
//     var rng = new Random();
// // get temporary directory of device.
//     Directory tempDir = await getTemporaryDirectory();
// // get temporary path from temporary directory.
//     String tempPath = tempDir.path;
// // create a new file in temporary path with random file name.
//     File file = new File('$tempPath' + (rng.nextInt(100)).toString() + '.png');
// // call http.get method and pass imageUrl into it to get response.
//     http.Response response = await http.get(Uri.parse(imageUrl));
// // write bodyBytes received in response to file.
//     await file.writeAsBytes(response.bodyBytes);
// // now return the file which is created with random name in
// // temporary directory and image bytes from response is written to // that file.
//     return file;
//   }

  void goBack(BuildContext context) {
    _fileBytes = null;
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
    _latitude = null;
    _longitude = null;
    Navigator.pop(context, 'refresh');
  }

  void logout(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

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
  List get provinceList => _provinceList;
  LatLng? get provinceLatLng => _provinceLatLng;
  String get locationName => _locationName;
  String get description => _description;
  String get contactNumber => _contactNumber;
  String get website => _website;
  dynamic get defaultCategotyValue => _defaultCategotyValue;
  dynamic get defaultLocationTypeValue => _defaultLocationTypeValue;
  int? get minPrice => _minPrice;
  int? get maxPrice => _maxPrice;
  double? get latitude => _latitude;
  double? get longitude => _longitude;

  Uint8List? get fileBytes => _fileBytes;
}
