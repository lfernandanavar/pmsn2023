import 'package:flutter/material.dart';

class TaskProvider with ChangeNotifier {
  bool _isUpdated = false;

  bool get isUpdated => _isUpdated;

  set isUpdated(bool value) {
    _isUpdated = value;
    notifyListeners();
    // _isUpdated = false;
  }
}