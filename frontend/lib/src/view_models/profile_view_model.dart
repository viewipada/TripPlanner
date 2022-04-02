import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trip_planner/src/models/response/location_created_response.dart';
import 'package:trip_planner/src/models/response/profile_details_response.dart';
import 'package:trip_planner/src/models/response/profile_response.dart';
import 'package:trip_planner/src/models/trip.dart';
import 'package:trip_planner/src/repository/shared_pref.dart';
import 'package:trip_planner/src/repository/trips_operations.dart';
import 'package:trip_planner/src/services/profile_service.dart';
import 'package:trip_planner/src/view/screens/create_location_page.dart';
import 'package:trip_planner/src/view/screens/edit_location_request_page.dart';
import 'package:trip_planner/src/view/screens/edit_profile_page.dart';
import 'package:trip_planner/src/view/screens/location_detail_page.dart';
import 'package:trip_planner/src/view/screens/login_page.dart';
import 'package:trip_planner/src/view/screens/review_page.dart';
import 'package:trip_planner/src/view/screens/survey_page.dart';
import 'package:trip_planner/src/view/screens/trip_detail_page.dart';

class ProfileViewModel with ChangeNotifier {
  late ProfileResponse _profileResponse;
  ProfileDetailsResponse? _profileDetailsResponse;
  TripsOperations _tripsOperations = TripsOperations();
  String? _gender;
  String _username = '';
  String _birthdate = '';
  File? _profileImage;

  Future<ProfileResponse> getMyProfile() async {
    _profileResponse = await ProfileService().getMyProfile();
    // notifyListeners();
    return _profileResponse;
  }

  Future<void> getProfileDetails() async {
    _profileDetailsResponse = await ProfileService().getProfileDetails();
    _gender = _profileDetailsResponse!.gender;
    _username = profileDetailsResponse!.username;
    _birthdate = profileDetailsResponse!.birthdate;
    notifyListeners();
  }

  Future<List<LocationCreatedResponse>> getLocationRequest() async {
    return await ProfileService().getLocationRequest();
  }

  String showTravelingDay(int travelingDay) {
    if (travelingDay == 1) {
      return '$travelingDay วัน';
    }
    return '$travelingDay วัน ${travelingDay - 1} คืน';
  }

  void goToCreateLocationPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateLocationPage(),
      ),
    );
  }

  void goToLocationDetail(BuildContext context, int locationId) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => LocationDetailPage(locationId: locationId)),
    );
  }

  void goToEditLocationRequestDetail(BuildContext context, int locationId) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              EditLocationRequestPage(locationId: locationId)),
    );
  }

  void goToReviewPage(
      BuildContext context, int locationId, String locationName) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              ReviewPage(locationName: locationName, locationId: locationId)),
    );
  }

  Future<int?> deleteReview(int locationId) async {
    final status = await ProfileService().deleteReview(locationId);
    if (status != null) notifyListeners();
    return status;
  }

  Future<void> deleteLocation(int locationId) async {
    await ProfileService().deleteLocation(locationId);
    notifyListeners();
  }

  void goBack(BuildContext context) {
    Navigator.pop(context);
  }

  void setGenderValue(String value) {
    _gender = value;
    notifyListeners();
  }

  void updateUsername(String editUsername) {
    _username = editUsername;
    notifyListeners();
  }

  Future pickDate(BuildContext context) async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: DateTime.parse(_birthdate),
      firstDate: DateTime(DateTime.now().year - 70),
      lastDate: DateTime.now(),
    );

    if (newDate == null) {
      notifyListeners();
      return;
    }
    _birthdate = newDate.toIso8601String();
    notifyListeners();
  }

  Future pickImageFromSource(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) {
        notifyListeners();
        return;
      }
      _profileImage = File(image.path);
      notifyListeners();
    } on PlatformException catch (e) {
      print('Failed to pick image $e form ${source}');
    }
  }

  void goToEditProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfilePage(),
      ),
    );
  }

  void goToSurveyPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SurveyPage(),
      ),
    );
  }

  void goToTripDetailPage(BuildContext context, Trip trip) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TripDetailPage(trip: trip)),
    );
  }

  Future<void> deleteTrip(Trip trip) async {
    await _tripsOperations.deleteTrip(trip);
    notifyListeners();
  }

  Future<void> logout(BuildContext context) async {
    await SharedPref().removeUserId();
    Navigator.pop(context);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  ProfileResponse get profileResponse => _profileResponse;
  ProfileDetailsResponse? get profileDetailsResponse => _profileDetailsResponse;
  String? get gender => _gender;
  String get username => _username;
  String get birthdate => _birthdate;
  File? get profileImage => _profileImage;
}
