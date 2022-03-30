import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:trip_planner/src/models/response/review_response.dart';
import 'package:trip_planner/src/services/review_service.dart';

class ReviewViewModel with ChangeNotifier {
  List<File> _images = [];
  ReviewResponse? _reviewResponse;
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
    _caption = '';
    _rating = 0;
    Navigator.pop(context);
  }

  Future<int?> updateReview(BuildContext context, int locationId) async {
    var statusCode = await ReviewService()
        .updateReview(locationId, _rating.toInt(), _caption, _images);

    if (statusCode == 200) {
      Navigator.pop(context);
      _images = [];
      _caption = '';
      _rating = 0;
      return statusCode;
    }
  }

  Future<int?> createReview(BuildContext context, int locationId) async {
    var statusCode = await ReviewService()
        .createReview(locationId, _rating.toInt(), _caption, _images);

    if (statusCode == 200) {
      Navigator.pop(context);
      _images = [];
      _caption = '';
      _rating = 0;
      return statusCode;
    }
  }

  Future<ReviewResponse?> getReviewByUserIdAndLocationId(int locationId) async {
    _reviewResponse =
        await ReviewService().getReviewByUserIdAndLocationId(locationId);
    print(_reviewResponse);
    if (_reviewResponse != null) {
      _caption = _reviewResponse!.caption;
      _rating = _reviewResponse!.rating.toDouble();
      await Future.forEach(_reviewResponse!.images, (String imageUrl) async {
        if (imageUrl != '') {
          var img = await urlToFile(imageUrl);
          _images.add(img);
        }
      });
    }
    // notifyListeners();
    return _reviewResponse;
  }

  Future<File> urlToFile(String imageUrl) async {
// generate random number.
    var rng = new Random();
// get temporary directory of device.
    Directory tempDir = await getTemporaryDirectory();
// get temporary path from temporary directory.
    String tempPath = tempDir.path;
// create a new file in temporary path with random file name.
    File file = new File('$tempPath' + (rng.nextInt(100)).toString() + '.png');
// call http.get method and pass imageUrl into it to get response.
    http.Response response = await http.get(Uri.parse(imageUrl));
// write bodyBytes received in response to file.
    await file.writeAsBytes(response.bodyBytes);
// now return the file which is created with random name in
// temporary directory and image bytes from response is written to // that file.
    return file;
  }

  List<File> get images => _images;
  ReviewResponse? get reviewResponse => _reviewResponse;
  String get caption => _caption;
  double get rating => _rating;
}
