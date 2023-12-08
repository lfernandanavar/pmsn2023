import 'package:flutter/foundation.dart';

class TestProvider with ChangeNotifier {
  String _user = '';

  String get user => _user;

  set user(String value) {
    _user = value;
    notifyListeners();
  }

  
}