import 'package:flutter/material.dart';

class UploadProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> upload() async {
    setLoading(_isLoading ? false : true);
    print(_isLoading);
  }
}
