import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LocationDetailViewModel with ChangeNotifier {
  bool _readMore = false;

  void toggleReadmoreButton() {
    _readMore = !_readMore;
    notifyListeners();
  }

  void goBack(BuildContext context) {
    Navigator.pop(context);
  }

  bool get readMore => _readMore;
}
