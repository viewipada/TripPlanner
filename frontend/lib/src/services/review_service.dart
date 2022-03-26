import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:trip_planner/src/repository/shared_pref.dart';

class ReviewService {
  final String baseUrl = 'http://10.0.2.2:8080';

  // Future<List<BaggageResponse>> getBaggageList() async {
  //   List<BaggageResponse> baggageList = [];
  //   final userId = await SharedPref().getUserId();
  //   if (userId != null) {
  //     final response =
  //         await http.get(Uri.parse('${baseUrl}/api/baggage/${userId}'));

  //     if (response.statusCode == 200) {
  //       var data = json.decode(response.body) as List<dynamic>;
  //       data
  //           .map((item) => baggageList.add(BaggageResponse.fromJson(item)))
  //           .toList();
  //       return baggageList;
  //     } else {
  //       throw Exception("can not fetch data");
  //     }
  //   } else
  //     return [];
  // }

  Future<int?> createReview(
      int locationId, int rating, String caption, List<File> images) async {
    final userId = await SharedPref().getUserId();
    if (userId != null) {
      var _images = [];

      await Future.forEach(images, (element) async {
        var formData = FormData();
        formData.files.add(MapEntry(
          "file",
          await MultipartFile.fromFile(images[0].path),
        ));
        var res =
            await Dio().post("${baseUrl}/api/file/upload", data: formData);
        _images.add(await res.data['downloadUrl'].toString());
      });

      final response = await http.post(
        Uri.parse('${baseUrl}/api/reviews/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "userId": userId,
          "locationId": locationId,
          "reviewRate": rating,
          "reviewCaption": caption,
          "reviewImg1": _images.length > 0 ? _images[0] : "",
          "reviewImg2": _images.length > 1 ? _images[1] : "",
          "reviewImg3": _images.length > 2 ? _images[2] : ""
        }),
      );
      if (response.statusCode == 200) {
        return response.statusCode;
      } else {
        throw Exception("can not create review");
      }
    } else
      print('null userId');
  }

  // Future<void> removeBaggageItem(int locationId) async {
  //   final userId = await SharedPref().getUserId();
  //   if (userId != null) {
  //     final response = await http.delete(
  //       Uri.parse('${baseUrl}/api/baggage/${userId}/${locationId}'),
  //     );

  //     if (response.statusCode == 200) {
  //       await SharedPref().removeBaggageItem(locationId);
  //       print(response.body);
  //     } else {
  //       throw Exception("can not remove baggageItem");
  //     }
  //   }
  // }
}
