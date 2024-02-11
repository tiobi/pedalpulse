import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pedalpulse/features/auth/data/datasources/firebase_auth_datasource.dart';
import 'package:pedalpulse/features/auth/data/datasources/firebase_auth_datasource_impl.dart';
import 'package:pedalpulse/features/auth/domain/entities/auth_entity.dart';

import '../../mocks/mock_firebase_auth.mocks.dart';
import '../../mocks/mock_firebasse_firestore.mocks.dart';
import '../../mocks/mock_user_credential.mocks.dart';

void main() {
  late FirebaseAuthDataSource dataSource;
  late MockFirebaseAuth auth = MockFirebaseAuth();
  late MockFirebaseFirestore firestore = MockFirebaseFirestore();

  setUp(() {
    auth = MockFirebaseAuth();
    firestore = MockFirebaseFirestore();
    dataSource = FirebaseAuthDataSourceImpl(
      auth: auth,
      firestore: firestore,
    );
  });

  const String tEmail = 'hello@world.com';
  const String tPassword = 'password1234';
  const String tEmptyEmail = '';
  const String tEmptyPassword = '';

  const AuthEntity tAuthEntity = AuthEntity(
    email: tEmail,
    password: tPassword,
  );
  const AuthEntity tEmptyAuthEntity = AuthEntity(
    email: tEmptyEmail,
    password: tEmptyPassword,
  );

  final UserCredential tUserCredential = MockUserCredential();

  group('FirebaseAuthDataSourceImpl Test', () {
    /// Sign In With Email And Password Test
    ///
    group('SignInWithEmailAndPassword Test', () async {
      test('should sign in the user and get user credential', () async {
        // Arrange
        when(auth.signInWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        )).thenAnswer((_) async => tUserCredential);

        // Act
        final result = await dataSource.signInWithEmailAndPassword(
          authEntity: tAuthEntity,
        );

        // Assert
        expect(result, isA<UserCredential>());
        verify(auth.signInWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        )).called(1);
        verifyNoMoreInteractions(auth);
      });
    });
  });
}
