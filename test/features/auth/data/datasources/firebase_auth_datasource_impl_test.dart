import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pedalpulse/features/auth/data/datasources/firebase_auth_datasource.dart';
import 'package:pedalpulse/features/auth/data/datasources/firebase_auth_datasource_impl.dart';
import 'package:pedalpulse/features/auth/domain/entities/auth_entity.dart';

import '../../mocks/mock_firebase_auth.mocks.dart';
import '../../mocks/mock_firebasse_firestore.mocks.dart';
import '../../mocks/mock_user.mocks.dart';
import '../../mocks/mock_user_credential.mocks.dart';

void main() {
  late FirebaseAuthDataSource dataSource;
  late MockUser user = MockUser();
  late MockFirebaseAuth auth = MockFirebaseAuth();
  late MockFirebaseFirestore firestore = MockFirebaseFirestore();

  setUp(() {
    auth = MockFirebaseAuth();
    firestore = MockFirebaseFirestore();
    user = MockUser();
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
    group('SignInWithEmailAndPassword Test', () {
      test('should sign in the user and get user credential', () async {
        // Arrange
        when(auth.signInWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        )).thenAnswer((_) async => tUserCredential);
        when(auth.currentUser).thenReturn(user);
        when(user.emailVerified).thenReturn(true);

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
        verify(auth.currentUser).called(1);
        verifyNoMoreInteractions(auth);
      });

      test('should return a Failure when the email and password are empty',
          () async {
        // Arrange
        when(auth.signInWithEmailAndPassword(
          email: tEmptyEmail,
          password: tEmptyPassword,
        )).thenThrow(FirebaseAuthException(
          code: 'Server Failure',
          message: 'Server Failure',
        ));

        // Act
        final result = dataSource.signInWithEmailAndPassword(
          authEntity: tEmptyAuthEntity,
        );

        // Assert
        expect(() => result, throwsA(isA<FirebaseAuthException>()));
      });

      test('should throw a FirebaseAuthException when the user is not found',
          () async {
        // Arrange
        when(auth.signInWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        )).thenThrow(FirebaseAuthException(
          code: 'user-not-found',
          message: 'User not found',
        ));

        // Act
        final call = dataSource.signInWithEmailAndPassword(
          authEntity: tAuthEntity,
        );

        // Assert
        expect(() => call, throwsA(isA<FirebaseAuthException>()));
      });

      test('should throw a FirebaseAuthException when the sign in fails',
          () async {
        // Arrange
        when(auth.signInWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        )).thenThrow(FirebaseAuthException(
          code: 'Server Failure',
          message: 'Server Failure',
        ));

        // Act
        final call = dataSource.signInWithEmailAndPassword(
          authEntity: tAuthEntity,
        );

        // Assert
        expect(() => call, throwsA(isA<FirebaseAuthException>()));
      });
    });

    /// Sign Up With Email And Password Test
    ///
    group('SignUpWithEmailAndPassword Test', () {
      test('should sign up the user and get user credential', () async {
        // Arrange
        when(auth.createUserWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        )).thenAnswer((_) async => tUserCredential);
        when(auth.currentUser).thenReturn(user);
        when(user.sendEmailVerification()).thenAnswer((_) async => unit);
        when(dataSource.initializeUserData(uid: '1234', email: tEmail))
            .thenAnswer((_) async => unit);

        // Act
        final result = await dataSource.signUpWithEmailAndPassword(
          authEntity: tAuthEntity,
        );

        // Assert
        expect(result, isA<UserCredential>());
        verify(auth.createUserWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        )).called(1);
        verifyNoMoreInteractions(auth);
      });

      test('should throw a FirebaseAuthException when the sign up fails',
          () async {
        // Arrange
        when(auth.createUserWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        )).thenThrow(FirebaseAuthException(
          code: 'Server Failure',
          message: 'Server Failure',
        ));

        // Act
        final call = dataSource.signUpWithEmailAndPassword(
          authEntity: tAuthEntity,
        );

        // Assert
        expect(() => call, throwsA(isA<FirebaseAuthException>()));
      });
    });

    /// Is Email Verified Test
    ///
    group('IsEmailVerified Test', () {
      test('should return true if the email is verified', () async {
        // Arrange
        when(auth.currentUser).thenReturn(user);
        when(user.emailVerified).thenReturn(true);

        // Act
        final result = await dataSource.isEmailVerified(email: tEmail);

        // Assert
        expect(result, true);
        verify(auth.currentUser).called(1);
        verifyNoMoreInteractions(auth);
        verify(user.emailVerified).called(1);
        verifyNoMoreInteractions(user);
      });

      test('should return false if the email is not verified', () async {
        // Arrange
        when(auth.currentUser).thenReturn(user);
        when(user.emailVerified).thenReturn(false);

        // Act
        final result = await dataSource.isEmailVerified(email: tEmail);

        // Assert
        expect(result, false);
        verify(auth.currentUser).called(1);
        verifyNoMoreInteractions(auth);
        verify(user.emailVerified).called(1);
        verifyNoMoreInteractions(user);
      });

      test('should throw a FirebaseAuthException when the user is not found',
          () async {
        // Arrange
        when(auth.currentUser).thenReturn(null);

        // Act
        final call = dataSource.isEmailVerified(email: tEmail);

        // Assert
        expect(() => call, throwsA(isA<FirebaseAuthException>()));
      });
    });
  });
}
