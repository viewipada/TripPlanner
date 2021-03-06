import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:trip_planner/src/models/response/review_response.dart';
import 'package:trip_planner/src/repository/shared_pref.dart';

class ReviewService {
  final String baseUrl = 'https://eztrip-backend.herokuapp.com';

  Future<ReviewResponse?> getReviewByUserIdAndLocationId(int locationId) async {
    final userId = await SharedPref().getUserId();
    if (userId != null) {
      final response = await http
          .get(Uri.parse('${baseUrl}/api/reviews/${userId}/${locationId}'));
      if (response.statusCode == 200) {
        var data = ReviewResponse.fromJson(json.decode(response.body));
        return data;
      } else if (response.statusCode == 204) {
        return null;
      } else {
        throw Exception("can not fetch data review by user & locationId");
      }
    } else
      return null;
  }

  Future<int?> createReview(
      int locationId, int rating, String caption, List<File> images) async {
    final userId = await SharedPref().getUserId();
    if (userId != null) {
      var _images = [];

      await Future.forEach(images, (File element) async {
        var formData = FormData();
        formData.files.add(MapEntry(
          "file",
          await MultipartFile.fromFile(element.path),
        ));
        var res =
            await Dio().post("${baseUrl}/api/file/upload", data: formData);
        _images.add(await '${baseUrl}/' + res.data['name'].toString());
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
    return null;
  }

  Future<int?> updateReview(
      int locationId, int rating, String caption, List<File> images) async {
    final userId = await SharedPref().getUserId();
    if (userId != null) {
      var _images = [];

      await Future.forEach(images, (File element) async {
        var formData = FormData();
        formData.files.add(MapEntry(
          "file",
          await MultipartFile.fromFile(element.path),
        ));
        var res =
            await Dio().post("${baseUrl}/api/file/upload", data: formData);
        _images.add(await '${baseUrl}/' + res.data['name'].toString());
      });

      final response = await http.put(
        Uri.parse('${baseUrl}/api/reviews/${userId}'),
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
        throw Exception("can not update review");
      }
    } else
      print('null userId');
    return null;
  }
}
