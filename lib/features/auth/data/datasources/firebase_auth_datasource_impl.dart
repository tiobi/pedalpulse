import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_auth_datasource.dart';

class FirebaseAuthDataSourceImpl implements FirebaseAuthDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  FirebaseAuthDataSourceImpl({
    required this.firestore,
    required this.auth,
  });
}
