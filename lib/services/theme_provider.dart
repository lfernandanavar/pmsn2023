import 'package:flutter/material.dart';
import 'package:pmsn20232/services/local_storage.dart';

class ThemeProvider with ChangeNotifier {
  bool _isLightTheme = true;

  bool get isLightTheme {
    if (LocalStorage.prefs.getBool('isThemeLight') != null) {
      LocalStorage.prefs.getBool('isThemeLight') as bool == true
          ? _isLightTheme = true
          : _isLightTheme = false;
    }
    return _isLightTheme;
  }

  set isLightTheme(bool value) {
    _isLightTheme = value;
    notifyListeners();
  }
}