import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:trip_planner/src/models/response/profile_response.dart';
import 'package:trip_planner/src/services/profile_service.dart';

class ProfileViewModel with ChangeNotifier {
  late ProfileResponse _profileResponse;

  Future<ProfileResponse> getMyProfile() async {
    _profileResponse = await ProfileService().getMyProfile();
    // notifyListeners();
    return _profileResponse;
  }

  String showTravelingDay(int travelingDay) {
    if (travelingDay == 1) {
      return '$travelingDay วัน';
    }
    return '$travelingDay วัน ${travelingDay - 1} คืน';
  }

  ProfileResponse get profileResponse => _profileResponse;
}
