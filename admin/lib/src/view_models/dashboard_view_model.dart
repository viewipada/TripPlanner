import 'package:flutter/material.dart';

class DashBoardViewModel with ChangeNotifier {
  final List _dropdownItemList = [
    {'label': 'ทั้งหมด', 'value': 0},
    {'label': 'ที่เที่ยว', 'value': 1},
    {'label': 'ที่กิน', 'value': 2},
    {'label': 'ที่พัก', 'value': 3},
  ];
  bool _isQuery = false;
  // List<SearchResultResponse> _queryResult = [];

  Future<void> getSearchResultBy(int category) async {
    // _searchResultCard =
    //     await SearchResultService().getSearchResultBy(category, sortedBy);
    notifyListeners();
  }

  void goToCreateLocation(BuildContext context) {
    Navigator.pushNamed(context, '/create');
  }

  void logout(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  void isSearchMode() {
    _isQuery = false;
    notifyListeners();
  }

  void isQueryMode() {
    _isQuery = true;
    notifyListeners();
  }

  // Future<void> query(
  //     List<SearchResultResponse> allLocationList, String searchMessage) async {
  //   _queryResult = await allLocationList.where((location) {
  //     final nameLower = location.locationName.toLowerCase();
  //     final searchMessageLower = searchMessage.toLowerCase();
  //     return nameLower.contains(searchMessageLower);
  //   }).toList();
  //   notifyListeners();
  // }

  List get dropdownItemList => _dropdownItemList;
}
