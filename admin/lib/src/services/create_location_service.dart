import 'dart:convert';
import 'dart:typed_data';
import 'package:admin/src/shared_pref.dart';
import 'package:http/http.dart' as http;

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

  Future<int?> createLocation(
      String locationName,
      int category,
      String description,
      String contactNumber,
      String website,
      String locationType,
      Uint8List images,
      double latitude,
      double longitude,
      String province,
      List dayOfWeek,
      String filename,
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

      var request =
          http.MultipartRequest('POST', Uri.parse("$baseUrl/api/file/upload"));
      request.files.add(
          http.MultipartFile.fromBytes('file', images, filename: filename));
      var streamedResponse = await request.send();

      var responseString = await streamedResponse.stream.bytesToString();
      final decodedMap = json.decode(responseString);
      final imageUrl = '$baseUrl/' + decodedMap['name'].toString();

      final response = await http.post(Uri.parse("$baseUrl/api/locations/"),
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
              "latitude": latitude,
              "longitude": longitude,
              "province": province,
              "averageRating": 0.0,
              "totalReview": 0,
              "totalCheckin": 0,
              "createBy": userId,
              "locationStatus": "Approved",
              "openingHour": openingHour,
              "min_price": minPrice,
              "max_price": maxPrice
            },
          ));

      if (response.statusCode == 201) {
        // print(response.body);
        return response.statusCode;
      } else {
        throw Exception("can not create location");
      }
    }
    return null;
  }
}
