import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trip_planner/src/models/response/search_result_response.dart';

class SearchResultService {
  final String baseUrl = 'http://10.0.2.2:8080';

  Future<List<SearchResultResponse>> getSearchResultBy(
      int category, String sortedBy) async {
    http.Response response = await http.get(
        Uri.parse(
            '${baseUrl}/api/locations/search/${sortedBy}?category=${category}'),
        headers: {"Accept": "application/json"});

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
