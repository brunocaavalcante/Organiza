import 'package:flutter/material.dart';

class NavigationController extends ChangeNotifier {
  int _currentTabIndex = 0;

  int get currentTabIndex => _currentTabIndex;

  void changeTab(int index) {
    if (_currentTabIndex != index) {
      _currentTabIndex = index;
      notifyListeners();
    }
  }

  /// Retorna ao início (primeira tab)
  void resetToHome() {
    changeTab(0);
  }
}
