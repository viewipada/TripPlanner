import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trip_planner/src/services/review_service.dart';

class ReviewViewModel with ChangeNotifier {
  List<File> _images = [];

  Future pickImageFromSource(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) {
        notifyListeners();
        return;
      }
      _images.add(File(image.path));
      notifyListeners();
    } on PlatformException catch (e) {
      print('Failed to pick image $e form ${source}');
    }
  }

  void deleteImage(File image) {
    _images.remove(image);
    notifyListeners();
  }

  void goBack(BuildContext context) {
    _images = [];
    Navigator.pop(context);
  }

  Future<int?> createReview(
      BuildContext context, int locationId, int rating, String caption) async {
    var statusCode = await ReviewService()
        .createReview(locationId, rating, caption, _images);

    if (statusCode == 200) {
      Navigator.pop(context);
      _images = [];
      return statusCode;
    }
  }

  List<File> get images => _images;
}
