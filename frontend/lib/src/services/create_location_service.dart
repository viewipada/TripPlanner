import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:trip_planner/src/models/response/location_request_detail_response.dart';
import 'package:trip_planner/src/repository/shared_pref.dart';

class CreateLocationService {
  final String baseUrl = 'https://eztrip-backend.herokuapp.com';

  Future<List> getLocationTypeList(int category) async {
    final response = await http
        .get(Uri.parse('$baseUrl/api/locations/category/type/$category'));
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
    final response =
        await http.get(Uri.parse('${baseUrl}/api/locations/${locationId}'));
    if (response.statusCode == 200) {
      var data =
          LocationRequestDetailResponse.fromJson(json.decode(response.body));
      return data;
    } else {
      throw Exception("can not fetch LocationRequestDetailResponse");
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
      List dayOfWeek,
      int? minPrice,
      int? maxPrice) async {
    final userId = await SharedPref().getUserId();
    if (userId != null) {
      List<String> openingHourList = [];
      await Future.forEach(
          dayOfWeek,
          (dynamic day) => openingHourList.add(day['isOpening']
              ? '${day['openTime']} - ${day['closedTime']}'
              : "ปิด"));
      var openingHour = {
        "mon": openingHourList[0],
        "tue": openingHourList[1],
        "wed": openingHourList[2],
        "thu": openingHourList[3],
        "fri": openingHourList[4],
        "sat": openingHourList[5],
        "sun": openingHourList[6]
      };
      var formData = FormData();
      formData.files.add(MapEntry(
        "file",
        await MultipartFile.fromFile(images.path),
      ));
      var res = await Dio().post("${baseUrl}/api/file/upload", data: formData);
      final imageUrl = await '${baseUrl}/' + res.data['name'].toString();

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
              // "duration": 1, //รอ api default duration
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
              "openingHour": openingHour,
              "min_price": minPrice,
              "max_price": maxPrice
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
    return null;
  }

  Future<int?> updateLocation(
      int locationId,
      String locationName,
      int category,
      String description,
      String contactNumber,
      String website,
      String locationType,
      File images,
      LatLng locationPin,
      String province,
      List dayOfWeek,
      int? minPrice,
      int? maxPrice) async {
    final userId = await SharedPref().getUserId();
    if (userId != null) {
      List<String> openingHourList = [];
      await Future.forEach(
          dayOfWeek,
          (dynamic day) => openingHourList.add(day['isOpening']
              ? '${day['openTime']} - ${day['closedTime']}'
              : "ปิด"));
      var openingHour = {
        "mon": openingHourList[0],
        "tue": openingHourList[1],
        "wed": openingHourList[2],
        "thu": openingHourList[3],
        "fri": openingHourList[4],
        "sat": openingHourList[5],
        "sun": openingHourList[6]
      };
      var formData = FormData();
      formData.files.add(MapEntry(
        "file",
        await MultipartFile.fromFile(images.path),
      ));
      var res = await Dio().post("${baseUrl}/api/file/upload", data: formData);
      final imageUrl = await '${baseUrl}/' + res.data['name'].toString();

      final response =
          await http.put(Uri.parse("${baseUrl}/api/locations/${locationId}"),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(
                <String, dynamic>{
                  "locationId": locationId,
                  "locationName": locationName,
                  "category": category,
                  "description": description,
                  "contactNumber": contactNumber == '' ? '-' : contactNumber,
                  "website": website == '' ? '-' : website,
                  // "duration": 1, //รอ api default duration
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
                  "openingHour": openingHour,
                  "min_price": minPrice,
                  "max_price": maxPrice,
                  "remark": "-"
                },
              ));

      if (response.statusCode == 200) {
        print(response.body);
        return response.statusCode;
      } else {
        throw Exception("can not create location");
      }
    } else
      print('null userId');
    return null;
  }
}
