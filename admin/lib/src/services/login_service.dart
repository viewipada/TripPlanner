import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginService {
  final String baseUrl = 'http://10.0.2.2:8080';

  Future<int?> tryToLogin(String username, String password) async {
    final response = await http.post(Uri.parse("$baseUrl/api/authen/login"),
        body: {"username": username, "password": password});

    if (response.statusCode == 200) {
      var jwt = json.decode(ascii.decode(
          base64.decode(base64.normalize(response.body.split(".")[1]))));
      // await SharedPref().saveUserId(jwt['user_id']);
      // List<String> _baggage = [];
      // await BaggageService()
      //     .getBaggageList()
      //     .then((list) => list.forEach((element) {
      //           _baggage.add(element.locationId.toString());
      //         }));
      // await SharedPref().initialBaggageItem(_baggage);
      print(jwt['user_id']);
      return response.statusCode;
    } else if (response.statusCode == 400) {
      //wrong password
      return response.statusCode;
    } else if (response.statusCode == 401) {
      //user not found
      return response.statusCode;
    } else {
      return null;
    }
  }
}
