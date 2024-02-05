// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';

import '../../domain/entities/auth_entity.dart';
import '../../domain/usecases/firebase_auth_usecases.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuthUseCase firebaseAuthUseCase;

  AuthProvider({
    required this.firebaseAuthUseCase,
  });

  Future<void> signInWithEmailAndPassword({
    required AuthEntity authEntity,
  }) async {
    await firebaseAuthUseCase.signInWithEmailAndPassword(authEntity);
    notifyListeners();
  }
}
