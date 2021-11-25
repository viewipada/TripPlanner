import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trip_planner/src/models/response/search_result_response.dart';

class SearchResultService {
  Future<List<SearchResultResponse>> getSearchResultBy(
      String category, String sortedBy) async {
    http.Response response;
    if (category == 'all') {
      if (sortedBy == 'rating') {
        response = await http.get(
            Uri.parse(
                'https://run.mocky.io/v3/c29703ef-a478-4f5b-8616-6d2793cb1bad'), //mock api
            headers: {"Accept": "application/json"});
      } else if (sortedBy == 'distance') {
        response = await http.get(
            Uri.parse(
                'https://run.mocky.io/v3/1e2c5561-2bf8-4dc5-9f00-8876dc6a3ce4'), //mock api
            headers: {"Accept": "application/json"});
      } else {
        response = await http.get(
            Uri.parse(
                'https://run.mocky.io/v3/4ce773a1-6801-401b-8cb2-d46b74643fdd'), //mock api
            headers: {"Accept": "application/json"});
      }
    } else if (category == 'travel') {
      if (sortedBy == 'rating') {
        response = await http.get(
            Uri.parse(
                'https://run.mocky.io/v3/779e6fb2-a539-4a52-afe7-429d7c3fc541'), //mock api
            headers: {"Accept": "application/json"});
      } else if (sortedBy == 'distance') {
        response = await http.get(
            Uri.parse(
                'https://run.mocky.io/v3/902e5bd1-4990-4699-bec9-26bbccf71258'), //mock api
            headers: {"Accept": "application/json"});
      } else {
        response = await http.get(
            Uri.parse(
                'https://run.mocky.io/v3/e7e2de22-bbce-4aa6-93ee-51fde090f801'), //mock api
            headers: {"Accept": "application/json"});
      }
    } else if (category == 'food') {
      if (sortedBy == 'rating') {
        response = await http.get(
            Uri.parse(
                'https://run.mocky.io/v3/c29703ef-a478-4f5b-8616-6d2793cb1bad'), //mock api
            headers: {"Accept": "application/json"});
      } else if (sortedBy == 'distance') {
        response = await http.get(
            Uri.parse(
                'https://run.mocky.io/v3/1e2c5561-2bf8-4dc5-9f00-8876dc6a3ce4'), //mock api
            headers: {"Accept": "application/json"});
      } else {
        response = await http.get(
            Uri.parse(
                'https://run.mocky.io/v3/4ce773a1-6801-401b-8cb2-d46b74643fdd'), //mock api
            headers: {"Accept": "application/json"});
      }
    } else {
      if (sortedBy == 'rating') {
        response = await http.get(
            Uri.parse(
                'https://run.mocky.io/v3/779e6fb2-a539-4a52-afe7-429d7c3fc541'), //mock api
            headers: {"Accept": "application/json"});
      } else if (sortedBy == 'distance') {
        response = await http.get(
            Uri.parse(
                'https://run.mocky.io/v3/902e5bd1-4990-4699-bec9-26bbccf71258'), //mock api
            headers: {"Accept": "application/json"});
      } else {
        response = await http.get(
            Uri.parse(
                'https://run.mocky.io/v3/e7e2de22-bbce-4aa6-93ee-51fde090f801'), //mock api
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
