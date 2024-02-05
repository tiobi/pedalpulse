import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/auth_entity.dart';
import 'firebase_auth_datasource.dart';

class FirebaseAuthDataSourceImpl implements FirebaseAuthDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  FirebaseAuthDataSourceImpl({
    required this.firestore,
    required this.auth,
  });

  @override
  Future<void> signUpWithEmailAndPassword({
    required AuthEntity authEntity,
  }) async {
    try{
      await auth.createUserWithEmailAndPassword(email: authEntity.email , password: authEntity.password,)
    }
  }
}
