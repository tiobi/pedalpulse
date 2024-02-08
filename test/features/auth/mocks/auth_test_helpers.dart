import 'package:firebase_auth/firebase_auth.dart';

import 'package:mockito/mockito.dart';
import 'package:pedalpulse/features/auth/data/datasources/firebase_auth_datasource.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockFirebaseAuthDatabase extends Mock implements FirebaseAuthDataSource {}
