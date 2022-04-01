import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trip_planner/src/models/response/search_result_response.dart';

class SearchResultService {
  final String baseUrl = 'http://10.0.2.2:8080';

  Future<List<SearchResultResponse>> getSearchResultBy(
      String category, String sortedBy) async {
    http.Response response;
    if (category == 'all') {
      if (sortedBy == 'rating') {
        response = await http.get(
            Uri.parse('${baseUrl}/api/locations/search/rating/category=0'),
            headers: {"Accept": "application/json"});
      } else {
        response = await http.get(
            Uri.parse('${baseUrl}/api/locations/search/checkin/category=0'),
            headers: {"Accept": "application/json"});
      }
    } else if (category == 'travel') {
      if (sortedBy == 'rating') {
        response = await http.get(
            Uri.parse('${baseUrl}/api/locations/search/rating/category=1'),
            headers: {"Accept": "application/json"});
      } else {
        response = await http.get(
            Uri.parse('${baseUrl}/api/locations/search/checkin/category=1'),
            headers: {"Accept": "application/json"});
      }
    } else if (category == 'food') {
      if (sortedBy == 'rating') {
        response = await http.get(
            Uri.parse('${baseUrl}/api/locations/search/rating/category=2'),
            headers: {"Accept": "application/json"});
      } else {
        response = await http.get(
            Uri.parse('${baseUrl}/api/locations/search/checkin/category=2'),
            headers: {"Accept": "application/json"});
      }
    } else {
      if (sortedBy == 'rating') {
        response = await http.get(
            Uri.parse('${baseUrl}/api/locations/search/rating/category=3'),
            headers: {"Accept": "application/json"});
      } else {
        response = await http.get(
            Uri.parse('${baseUrl}/api/locations/search/checkin/category=3'),
            headers: {"Accept": "application/json"});
      }
    }

    if (response.statusCode == 200) {
      List<SearchResultResponse> searchResult;
      searchResult = (json.decode(response.body) as List)
          .map((i) => SearchResultResponse.fromJson(i))
          .toList();
      return searchResult;
    } else {
      throw Exception('Failed to load searchResult');
    }
  }
}
