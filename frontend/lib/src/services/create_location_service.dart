import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:trip_planner/src/models/response/location_request_detail_response.dart';
import 'package:trip_planner/src/repository/shared_pref.dart';

class CreateLocationService {
  final String baseUrl = 'http://10.0.2.2:8080';

  Future<List> getLocationTypeList(String category) async {
    final response = await http.get(Uri.parse(category == 'travel'
        ? 'https://run.mocky.io/v3/642a8640-04a2-4150-b1e5-35e2063d6780'
        : category == 'food'
            ? 'https://run.mocky.io/v3/b802aedf-338e-47ca-b1b3-cfc20267b352'
            : 'https://run.mocky.io/v3/bc962922-d2aa-4db4-9d36-a0e643fae811'));
    List locationTypeList = [];
    if (response.statusCode == 200) {
      var data = json.decode(response.body) as List<dynamic>;
      data.map((item) => locationTypeList.add(item)).toList();
      return locationTypeList;
    } else {
      throw Exception("can not fetch data hot location");
    }
  }

  Future<LocationRequestDetailResponse> getLocationRequestById(
      int locationId) async {
    final response = await http.get(
        Uri.parse("https://run.mocky.io/v3/dc592e7e-90a1-436c-9169-a8ad75083be9"
            // 'http://10.0.2.2:8080/api/locations/${locationId}'
            ));
    // print(response.body);
    if (response.statusCode == 200) {
      var data =
          LocationRequestDetailResponse.fromJson(json.decode(response.body));
      // print(data);
      return data;
    } else {
      throw Exception("can not fetch data hot location");
    }
  }

  Future<int?> createLocation(
      String locationName,
      int category,
      String description,
      String contactNumber,
      String website,
      String locationType,
      File images,
      LatLng locationPin,
      String province,
      List dayOfWeek) async {
    final userId = await SharedPref().getUserId();
    if (userId != null) {
      List<String> openingHour = [];
      await Future.forEach(
          dayOfWeek,
          (dynamic day) => openingHour.add(day['isOpening']
              ? '${day['openTime']} - ${day['closedTime']}'
              : "ปิด"));
      var formData = FormData();
      formData.files.add(MapEntry(
        "file",
        await MultipartFile.fromFile(images.path),
      ));
      var res = await Dio().post("${baseUrl}/api/file/upload", data: formData);
      final imageUrl = await res.data['downloadUrl'].toString();

      final response = await http.post(Uri.parse("${baseUrl}/api/locations/"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(
            <String, dynamic>{
              "locationId": null,
              "locationName": locationName,
              "category": category,
              "description": description,
              "contactNumber": contactNumber == '' ? '-' : contactNumber,
              "website": website == '' ? '-' : website,
              "duration": 1, //รอ api default duration
              "type": locationType,
              "imageUrl": imageUrl,
              "latitude": locationPin.latitude,
              "longitude": locationPin.longitude,
              "province": province,
              "averageRating": 0.0,
              "totalReview": 0,
              "totalCheckin": 0,
              "createBy": userId,
              "locationStatus": "In progress",
              "openingHour": openingHour
            },
          ));

      if (response.statusCode == 201) {
        print(response.body);
        return response.statusCode;
      } else {
        throw Exception("can not create location");
      }
    } else
      print('null userId');
  }
}
