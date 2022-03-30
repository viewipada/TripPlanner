import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:trip_planner/assets.dart';
import 'package:trip_planner/src/models/response/user_interested_response.dart';
import 'package:trip_planner/src/services/profile_service.dart';
import 'package:trip_planner/src/view/widgets/navigation_bar.dart';

class SurveyViewModel with ChangeNotifier {
  List _activities = [
    {
      "imageUrl": ImageAssets.Act1,
      "label": "บันจี้จัมป์",
      "value": "บันจี้จัมป์",
    },
    {
      "imageUrl": ImageAssets.Act2,
      "label": "เต้นรำ",
      "value": "เต้นรำ",
    },
    {
      "imageUrl": ImageAssets.Act3,
      "label": "ปีนเขา",
      "value": "ปีนเขา",
    },
    {
      "imageUrl": ImageAssets.Act4,
      "label": "พายเรือล่องแก่ง",
      "value": "พายเรือล่องแก่ง",
    },
    {
      "imageUrl": ImageAssets.Act5,
      "label": "ดูพระอาทิตย์ขึ้น-ตก",
      "value": "ดูพระอาทิตย์ขึ้น-ตก",
    },
    {
      "imageUrl": ImageAssets.Act6,
      "label": "ดูทะเลหมอก",
      "value": "ดูทะเลหมอก",
    },
    {
      "imageUrl": ImageAssets.Act7,
      "label": "ล่องเรือ",
      "value": "ล่องเรือ",
    },
    {
      "imageUrl": ImageAssets.Act8,
      "label": "ถ่ายภาพสถานที่",
      "value": "ถ่ายภาพสถานที่",
    },
    {
      "imageUrl": ImageAssets.Act9,
      "label": "ดูงานศิลปะ",
      "value": "ดูงานศิลปะ",
    },
    {
      "imageUrl": ImageAssets.Act10,
      "label": "ดูสวนดอกไม้",
      "value": "ดูสวนดอกไม้",
    },
    {
      "imageUrl": ImageAssets.Act11,
      "label": "สำรวจประวัติศาสตร์",
      "value": "สำรวจประวัติศาสตร์",
    },
    {
      "imageUrl": ImageAssets.Act12,
      "label": "เที่ยวเมืองจำลอง",
      "value": "สถานที่ท่องเที่ยวบรรยากาศต่างประเทศ",
    },
  ];

  List<String> _restaurant = [
    "อาหารเส้น",
    "ร้านอาหาร/ภัตตาคาร",
    "สตรีทฟู้ด",
    "ปิ้งย่าง/บุฟเฟ่ต์",
    "เบเกอรี่",
    "คาเฟ่"
  ];
  List<String> _hotel = [
    "รีสอร์ท",
    "แคมป์",
    "โรงแรม",
    "บังกะโล/บ้านพัก",
    "โฮมสเตย์/เกสเฮาส์"
  ];
  List<String> _selectedActivities = [];
  List<String> _selectedRestaurant = [];
  List<String> _selectedHotel = [];
  int? _minPrice;
  int? _maxPrice;
  UserInterestedResponse? _userInterested;

  void selectActivity(String activity) {
    _selectedActivities.contains(activity)
        ? _selectedActivities.remove(activity)
        : _selectedActivities.add(activity);
    notifyListeners();
  }

  void selectRestaurant(String restaurant) {
    _selectedRestaurant.contains(restaurant)
        ? _selectedRestaurant.remove(restaurant)
        : _selectedRestaurant.add(restaurant);
    notifyListeners();
  }

  void selectHotel(String hotel) {
    _selectedHotel.contains(hotel)
        ? _selectedHotel.remove(hotel)
        : _selectedHotel.add(hotel);
    notifyListeners();
  }

  void updateMinPrice(String minPrice) {
    _minPrice = minPrice == '' ? null : int.parse(minPrice);
    notifyListeners();
  }

  void updateMaxPrice(String maxPrice) {
    _maxPrice = maxPrice == '' ? null : int.parse(maxPrice);
    notifyListeners();
  }

  Future<UserInterestedResponse?> getUserInterested() async {
    _userInterested = await ProfileService().getUserInterested();
    if (_userInterested != null) {
      if (_userInterested!.firstActivity != null)
        _selectedActivities.add(_userInterested!.firstActivity!);
      if (_userInterested!.secondActivity != null)
        _selectedActivities.add(_userInterested!.secondActivity!);
      if (_userInterested!.thirdActivity != null)
        _selectedActivities.add(_userInterested!.thirdActivity!);

      if (_userInterested!.firstFood != null)
        _selectedRestaurant.add(_userInterested!.firstFood!);
      if (_userInterested!.secondFood != null)
        _selectedRestaurant.add(_userInterested!.secondFood!);
      if (_userInterested!.thirdFood != null)
        _selectedRestaurant.add(_userInterested!.thirdFood!);

      if (_userInterested!.firstHotel != null)
        _selectedHotel.add(_userInterested!.firstHotel!);
      if (_userInterested!.secondHotel != null)
        _selectedHotel.add(_userInterested!.secondHotel!);
      if (_userInterested!.thirdHotel != null)
        _selectedHotel.add(_userInterested!.thirdHotel!);

      _minPrice = _userInterested!.minPrice;
      _maxPrice = _userInterested!.maxPrice;
    }
    notifyListeners();
    return _userInterested;
  }

  void goToHomePage(BuildContext context) {
    Navigator.pop(context);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => NavigationBar(),
      ),
    );
  }

  Future<int?> updateUserInterested(BuildContext context) async {
    final res = await ProfileService().updateUserInterested(_selectedActivities,
        _selectedRestaurant, _selectedHotel, _minPrice, _maxPrice);
    if (res == 200) {
      Navigator.pop(context);
      return res;
    }
  }

  Future<int?> createUserInterested(BuildContext context) async {
    final res = await ProfileService().createUserInterested(_selectedActivities,
        _selectedRestaurant, _selectedHotel, _minPrice, _maxPrice);
    if (res == 201) {
      goToHomePage(context);
    }
  }

  List get activities => _activities;
  List<String> get hotel => _hotel;
  List<String> get restaurant => _restaurant;
  List<String> get selectedActivities => _selectedActivities;
  List<String> get selectedRestaurant => _selectedRestaurant;
  int? get minPrice => _minPrice;
  int? get maxPrice => _maxPrice;
  List<String> get selectedHotel => _selectedHotel;
  UserInterestedResponse? get userInterested => _userInterested;
}
