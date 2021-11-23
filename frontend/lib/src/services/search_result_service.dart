import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trip_planner/src/models/response/search_result_response.dart';

class SearchResultService {
  Future<List<SearchResultResponse>> getSearchResultBy(
      String category, String sortedBy) async {
    http.Response response;
    response = await http.get(
        Uri.parse(
            'https://run.mocky.io/v3/e7e2de22-bbce-4aa6-93ee-51fde090f801'), //mock api
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
