import 'package:admin/src/palette.dart';
import 'package:flutter/material.dart';

class ImageAssets {
  static const String logo = 'assets/images/logo.png';
  static const String noPreview = 'assets/images/no_preview.png';
  static const String loginBackground = 'assets/images/login_bg.png';
}

class IconAssets {}

class FontAssets {
  static const TextStyle headingText = TextStyle(
      color: Palette.webText, fontSize: 20, fontWeight: FontWeight.bold);
  static const TextStyle titleText = TextStyle(
      color: Palette.webText, fontSize: 18, fontWeight: FontWeight.bold);
  static const TextStyle subtitleText = TextStyle(
      color: Palette.webText, fontSize: 16, fontWeight: FontWeight.bold);
  static const TextStyle bodyText =
      TextStyle(color: Palette.additionText, fontSize: 14);
  static const TextStyle hintText =
      TextStyle(color: Palette.additionText, fontSize: 12);
  static const TextStyle requiredField = TextStyle(
      color: Palette.secondaryColor, fontWeight: FontWeight.bold, fontSize: 16);
}

class GoogleAssets {
  static const String googleAPI = "AIzaSyC3IbO2CjNOMP1g1F_Y7jamCp0aEu4asKE";
}
