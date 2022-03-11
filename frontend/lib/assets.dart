import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trip_planner/palette.dart';

class ImageAssets {
  static const String logo = 'assets/images/logo.png';
  static const String homeBanner = 'assets/images/home_banner.png';
  static const String noPreview = 'assets/images/no_preview.png';
  static const String myLocation = 'assets/images/my_location.png';
  static const String loginBackground = 'assets/images/login_bg.png';
  static const String pdpaBackground = 'assets/images/pdpa.jpg';
  static const String boarding_1 = 'assets/images/boarding_1.png';
  static const String boarding_2 = 'assets/images/boarding_2.png';
  static const String boarding_3 = 'assets/images/boarding_3.png';
  static const String boarding_4 = 'assets/images/boarding_4.png';
}

class IconAssets {
  static const String copyToEdit = 'assets/icons/copyToEdit.png';
  static const String baggage = 'assets/icons/luggage.png';
  static const String baggageAdd = 'assets/icons/luggage-add.png';
  static const String radiusPin = 'assets/icons/radius.png';
  static const String locationListView = 'assets/icons/location-listview.png';
  static const String travelMarker = 'assets/icons/travel_pin.png';
  static const String foodMarker = 'assets/icons/food_pin.png';
  static const String hotelMarker = 'assets/icons/hotel_pin.png';
  static const String sort = 'assets/icons/sort.png';
}

class FontAssets {
  static const TextStyle headingOnboarding = TextStyle(
      color: Palette.PrimaryColor, fontSize: 20, fontWeight: FontWeight.bold);
  static const TextStyle headingText = TextStyle(
      color: Palette.HeadingText, fontSize: 20, fontWeight: FontWeight.bold);
  static const TextStyle titleText = TextStyle(
      color: Palette.BodyText, fontSize: 18, fontWeight: FontWeight.bold);
  static const TextStyle subtitleText = TextStyle(
      color: Palette.BodyText, fontSize: 16, fontWeight: FontWeight.bold);
  static const TextStyle bodyText =
      TextStyle(color: Palette.AdditionText, fontSize: 14);
  static const TextStyle hintText =
      TextStyle(color: Palette.AdditionText, fontSize: 12);
  static const TextStyle requiredField = TextStyle(
      color: Palette.SecondaryColor, fontWeight: FontWeight.bold, fontSize: 16);
  static const TextStyle mealsRecommendText = TextStyle(
      color: Palette.LightSecondary, fontWeight: FontWeight.bold, fontSize: 12);
  static const TextStyle addRestaurantText =
      TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14);
}

class GoogleAssets {
  static const String googleAPI = "AIzaSyC3IbO2CjNOMP1g1F_Y7jamCp0aEu4asKE";
}
