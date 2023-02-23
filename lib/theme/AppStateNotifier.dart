import 'package:flutter/material.dart';

class AppStateNotifier extends ChangeNotifier {
  //
  bool isDarkMode = false;

  void updateTheme(bool isDarkMode) {
    this.isDarkMode = isDarkMode;
    notifyListeners();
  }

  void toggleTheme() {
    this.isDarkMode = !this.isDarkMode;
    notifyListeners();
  }
}
