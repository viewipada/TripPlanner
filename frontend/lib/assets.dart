import 'package:flutter/cupertino.dart';
import 'package:trip_planner/palette.dart';

class ImageAssets {
  static const String logo = 'assets/images/logo.png';
  static const String homeBanner = 'assets/images/home_banner.png';
  static const String noPreview = 'assets/images/no_preview.png';
  static const String myLocation = 'assets/images/my_location.png';
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
}

class FontAssets {
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
}
