import 'package:flutter/material.dart';

class NavigationBarViewModel with ChangeNotifier {
  int _selectedIndex = 0;
  PageController _pageController = PageController();

  void initSelectedIndex() {
    _selectedIndex = 0;
  }

  void onSlidePageView(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void onIconTapped(int index) {
    _selectedIndex = index;
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeIn,
    );
    notifyListeners();
  }

  PageController get pageController => _pageController;
  int get selectedIndex => _selectedIndex;
}
