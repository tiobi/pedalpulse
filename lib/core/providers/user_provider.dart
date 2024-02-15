import 'package:flutter/material.dart';

import '../entities/user_entity.dart';

class UserProvider extends ChangeNotifier {
  UserEntity? _user;

  UserEntity? get user => _user;
}
