import 'package:firebase_auth/firebase_auth.dart';

import 'package:mockito/mockito.dart';
import 'package:pedalpulse/features/auth/data/datasources/firebase_auth_datasource.dart';
import 'package:pedalpulse/features/auth/domain/repositories/firebase_auth_repository.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUserCredential extends Mock implements UserCredential {}

class MockFirebaseAuthRepository extends Mock
    implements FirebaseAuthRepository {}

class MockFirebaseAuthDatabase extends Mock implements FirebaseAuthDataSource {}
