import 'package:flutter/material.dart';

class AppTheme with ChangeNotifier {
  static ThemeMode _themeMode = ThemeMode.system;

  ThemeMode currentTheme() {
    return _themeMode;
  }

  void switchTheme(ThemeMode themeMode) {
    _themeMode = themeMode;
    notifyListeners();
  }
}
