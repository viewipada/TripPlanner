import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trip_planner/src/models/response/location_request_detail_response.dart';

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
}
