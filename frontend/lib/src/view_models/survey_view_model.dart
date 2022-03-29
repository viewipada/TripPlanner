import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class SurveyViewModel with ChangeNotifier {
  List<File> _images = [];
  String _caption = '';
  double _rating = 0;

  void updateCaption(String caption) {
    _caption = caption;
    notifyListeners();
  }

  void updateRating(double rating) {
    _rating = rating;
    notifyListeners();
  }

  List<File> get images => _images;
  String get caption => _caption;
  double get rating => _rating;
}
