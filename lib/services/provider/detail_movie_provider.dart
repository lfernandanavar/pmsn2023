import 'package:flutter/foundation.dart';

class DetailMovieProvider with ChangeNotifier {
  bool _isUpdated = false;

  bool get isUpdated => _isUpdated;

  set isUpdated(bool value) {
    _isUpdated = value;
    notifyListeners();
  }
}
