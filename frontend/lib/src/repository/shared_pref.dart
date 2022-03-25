import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  Future<void> saveUserId(int userId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', userId);
  }

  Future<int?> getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getInt('userId');
  }

  Future<void> removeUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
  }
}
