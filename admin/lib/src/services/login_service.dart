import 'dart:convert';
import 'package:admin/src/shared_pref.dart';
import 'package:http/http.dart' as http;

class LoginService {
  final String baseUrl = 'https://eztrip-backend.herokuapp.com';

  Future<int?> tryToLogin(String username, String password) async {
    final response = await http.post(Uri.parse("$baseUrl/api/authen/login"),
        body: {"username": username, "password": password});

    if (response.statusCode == 200) {
      var jwt = json.decode(ascii.decode(
          base64.decode(base64.normalize(response.body.split(".")[1]))));
      if (jwt['role'] == 'user') {
        return 403;
      } else {
        await SharedPref().saveUserId(jwt['user_id']);
        await SharedPref().saveUsername(jwt['username']);
        return response.statusCode;
      }
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
