import 'dart:convert';
import 'package:http/http.dart' as http;

class CreateLocationService {
  Future<List> getLocationTypeList(String category) async {
    final response = await http.get(Uri.parse(
        'https://run.mocky.io/v3/642a8640-04a2-4150-b1e5-35e2063d6780'));
    List locationTypeList = [];
    if (response.statusCode == 200) {
      var data = json.decode(response.body) as List<dynamic>;
      data.map((item) => locationTypeList.add(item)).toList();
      return locationTypeList;
    } else {
      throw Exception("can not fetch data hot location");
    }
  }
}
