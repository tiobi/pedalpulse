import 'package:flutter/material.dart';
import 'package:pedalpulse/models/user_model.dart';
import 'package:pedalpulse/services/auth/auth_methods.dart';

class UserProviderDepr with ChangeNotifier {
  UserModelDepr? _user;
  final AuthMethods _authMethods = AuthMethods();

  UserModelDepr? get user => _user;

  Future<void> setUser() async {
    // UserModel user = await _authMethods.getUserDetails();
    // _user = user;
    // notifyListeners();
  }
}
