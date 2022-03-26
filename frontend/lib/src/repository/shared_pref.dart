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

  Future<void> addBaggageItem(int locationId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await getBaggageItems().then((value) async {
      value.add('${locationId}');
      await prefs.setStringList('cart', value);
    });
  }

  Future<List<String>> getBaggageItems() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('cart') ?? [];
  }

  Future<void> removeBaggageItem(int locationId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await getBaggageItems().then((value) async {
      value.remove('${locationId}');
      await prefs.setStringList('cart', value);
    });
  }
}
