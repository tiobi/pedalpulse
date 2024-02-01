import 'package:flutter/material.dart';
import 'package:pedalpulse/models/user_model.dart';
import 'package:pedalpulse/services/auth/auth_methods.dart';

import '../services/firebase/user_firestore_methods.dart';

class UserLikesProvider with ChangeNotifier {
  final List<String> _userLikes = [];
  final AuthMethods _authMethods = AuthMethods();

  List<String> get userLikes => _userLikes;

  Future<void> addLike(
      {required String userUid, required String postUid}) async {
    _userLikes.add(postUid);
    await UserFirestoreMethods()
        .addUserLike(postUid: postUid, userUid: userUid);
    notifyListeners();
  }

  Future<void> removeLike(
      {required String userUid, required String postUid}) async {
    _userLikes.remove(postUid);
    await UserFirestoreMethods()
        .removeUserLike(postUid: postUid, userUid: userUid);
    notifyListeners();
  }

  bool isLiked(String id) {
    return _userLikes.contains(id);
  }

  void handleLike(String postUid) async {
    UserModel user = await _authMethods.getUserDetails();
    if (isLiked(postUid)) {
      await removeLike(userUid: user.uid, postUid: postUid);
    } else {
      await addLike(userUid: user.uid, postUid: postUid);
    }
  }

  Future<void> setUserLikes() async {
    UserModel user = await _authMethods.getUserDetails();
    List<String> userLikes =
        await UserFirestoreMethods().getUserLikes(userUid: user.uid);
    _userLikes.addAll(userLikes);
    notifyListeners();
  }
}
