import 'dart:convert';
import 'dart:typed_data';
import 'package:admin/src/shared_pref.dart';
import 'package:http/http.dart' as http;

class CreateLocationService {
  final String baseUrl = 'http://localhost:8080';

  Future<List> getLocationTypeList(int category) async {
    final response = await http.get(Uri.parse(category == 1
        ? 'https://run.mocky.io/v3/642a8640-04a2-4150-b1e5-35e2063d6780'
        : category == 2
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
      List<String> openingHour = [];
      await Future.forEach(
          dayOfWeek,
          (dynamic day) => openingHour.add(day['isOpening']
              ? '${day['openTime']} - ${day['closedTime']}'
              : "ปิด"));

      var request =
          http.MultipartRequest('POST', Uri.parse("$baseUrl/api/file/upload"));
      request.files.add(
          http.MultipartFile.fromBytes('file', images, filename: filename));
      var streamedResponse = await request.send();

      var responseString = await streamedResponse.stream.bytesToString();
      final decodedMap = json.decode(responseString);
      final imageUrl = decodedMap['name'];

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
              "duration": 1, //รอ api default duration
              "type": locationType,
              "imageUrl": imageUrl,
              "latitude": latitude,
              "longitude": longitude,
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
        // print(response.body);
        return response.statusCode;
      } else {
        throw Exception("can not create location");
      }
    }
    return null;
  }

  // Future<int?> updateLocation(
  //     String locationName,
  //     int category,
  //     String description,
  //     String contactNumber,
  //     String website,
  //     String locationType,
  //     File images,
  //     LatLng locationPin,
  //     String province,
  //     List dayOfWeek) async {
  //   final userId = await SharedPref().getUserId();
  //   if (userId != null) {
  //     List<String> openingHour = [];
  //     await Future.forEach(
  //         dayOfWeek,
  //         (dynamic day) => openingHour.add(day['isOpening']
  //             ? '${day['openTime']} - ${day['closedTime']}'
  //             : "ปิด"));
  //     var formData = FormData();
  //     formData.files.add(MapEntry(
  //       "file",
  //       await MultipartFile.fromFile(images.path),
  //     ));
  //     var res = await Dio().post("${baseUrl}/api/file/upload", data: formData);
  //     final imageUrl = await res.data['name'].toString();

  //     final response = await http.put(Uri.parse("${baseUrl}/api/locations/"),
  //         headers: <String, String>{
  //           'Content-Type': 'application/json; charset=UTF-8',
  //         },
  //         body: jsonEncode(
  //           <String, dynamic>{
  //             "locationId": null,
  //             "locationName": locationName,
  //             "category": category,
  //             "description": description,
  //             "contactNumber": contactNumber == '' ? '-' : contactNumber,
  //             "website": website == '' ? '-' : website,
  //             "duration": 1, //รอ api default duration
  //             "type": locationType,
  //             "imageUrl": imageUrl,
  //             "latitude": locationPin.latitude,
  //             "longitude": locationPin.longitude,
  //             "province": province,
  //             "averageRating": 0.0,
  //             "totalReview": 0,
  //             "totalCheckin": 0,
  //             "createBy": userId,
  //             "locationStatus": "In progress",
  //             "openingHour": openingHour
  //           },
  //         ));

  //     if (response.statusCode == 201) {
  //       print(response.body);
  //       return response.statusCode;
  //     } else {
  //       throw Exception("can not create location");
  //     }
  //   } else
  //     print('null userId');
  //   return null;
  // }
}
