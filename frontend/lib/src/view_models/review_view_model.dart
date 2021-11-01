import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

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

  Future deleteImage(File image) async {
    _images.remove(image);
    notifyListeners();
  }

  List<File> get images => _images;
}
