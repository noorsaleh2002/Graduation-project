// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:gp_2/Screens/setting/darkMode.dart';
import 'package:gp_2/Screens/setting/lightMode.dart';

class Themeprovider extends ChangeNotifier {
  ThemeData _themeData = lightMode;

  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData == darkMode;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }
}
