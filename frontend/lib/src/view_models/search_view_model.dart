import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:trip_planner/src/view/screens/my_location_page.dart';

class SearchViewModel with ChangeNotifier {
  void goToMyLocationPage(BuildContext context, String catagory) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyLocationPage(),
      ),
    );
  }
}
