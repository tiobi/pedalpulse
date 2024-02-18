import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pedalpulse/features/auth/data/datasources/firebase_auth_datasource.dart';
import 'package:pedalpulse/features/auth/data/datasources/firebase_auth_datasource_impl.dart';
import 'package:pedalpulse/features/auth/domain/entities/auth_entity.dart';

import '../../../../mocks/auth/firebase/mock_firebase_auth.mocks.dart';
import '../../../../mocks/auth/mock_user_credential.mocks.dart';
import '../../../../mocks/database/mock_collection_reference.mocks.dart';
import '../../../../mocks/database/mock_document_refernce.mocks.dart';
import '../../../../mocks/database/mock_firebasse_firestore.mocks.dart';
import '../../../../mocks/user/mock_user.mocks.dart';

void main() {
  late FirebaseAuthDataSource dataSource;
  late MockUser user;
  late MockFirebaseAuth auth;
  late MockFirebaseFirestore firestore;
  late MockCollectionReference collection;
  late MockDocumentReference document;

  setUp(() {
    auth = MockFirebaseAuth();
    firestore = MockFirebaseFirestore();
    user = MockUser();
    dataSource = FirebaseAuthDataSourceImpl(
      auth: auth,
      firestore: firestore,
    );
    collection = MockCollectionReference();
    document = MockDocumentReference();

    when(firestore.collection(any)).thenReturn(collection);
    when(collection.doc(any)).thenReturn(document);
  });

  const String tEmail = 'hello@world.com';
  const String tPassword = 'password1234';
  const String tEmptyEmail = '';
  const String tEmptyPassword = '';

  const String tUid = '1b5d7f6c-3e5f-436a-9ff0-7200e0eef99c';

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
        final result = dataSource.signInWithEmailAndPassword(
          authEntity: tAuthEntity,
        );

        // Assert
        expect(() => result, throwsA(isA<FirebaseAuthException>()));
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
        when(firestore.collection('users')).thenReturn(collection);
        when(collection.doc(tUid)).thenReturn(document);
        when(document.set(any)).thenAnswer((_) async => unit);
        when(dataSource.signUpWithEmailAndPassword(
          authEntity: tAuthEntity,
        )).thenAnswer((_) async => tUserCredential);

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

    /// Send Email Verification Test
    ///
    group('SendEmailVerification Test', () {
      test('should send an email verification', () async {
        // Arrange
        when(auth.currentUser).thenReturn(user);
        when(user.sendEmailVerification()).thenAnswer((_) async => unit);

        // Act
        final result = await dataSource.sendEmailVerification(email: tEmail);

        // Assert
        expect(result, unit);
        verify(auth.currentUser).called(1);
        verifyNoMoreInteractions(auth);
        verify(user.sendEmailVerification()).called(1);
        verifyNoMoreInteractions(user);
      });

      test(
          'should throw a FirebaseAuthException when the email verification fails',
          () async {
        // Arrange
        when(auth.currentUser).thenReturn(user);
        when(user.sendEmailVerification()).thenThrow(FirebaseAuthException(
          code: 'Server Failure',
          message: 'Server Failure',
        ));

        // Act
        final call = dataSource.sendEmailVerification(email: tEmail);

        // Assert
        expect(() => call, throwsA(isA<FirebaseAuthException>()));
      });
    });

    /// Initialize User Data Test
    ///
    group('InitializeUserData Test', () {
      test('should initialize the user data', () async {
        // Arrange
        // when(firestore.collection('users').doc(tUid).set({
        //   'uid': tUid,
        //   'email': tEmail,
        // }));

        when(firestore.collection('users')).thenReturn(collection);
        when(collection.doc(tUid)).thenReturn(document);
        when(document.set({
          'uid': tUid,
          'email': tEmail,
        })).thenAnswer((_) async => unit);

        // Act
        final result = await dataSource.initializeUserData(
          uid: tUid,
          email: tEmail,
        );

        // Assert
        expect(result, unit);
        verify(firestore.collection('users')).called(1);
        verifyNoMoreInteractions(firestore);
      });

      test('should throw a FirebaseException when an error occurs', () async {
        // Arrange
        when(firestore.collection('users')).thenReturn(collection);
        when(collection.doc(tUid)).thenReturn(document);
        when(document.set(any)).thenThrow(FirebaseException(
          plugin: 'firebase',
          message: 'Server Failure',
        ));

        // Act
        final call = dataSource.initializeUserData(
          uid: tUid,
          email: tEmail,
        );

        // Assert
        expect(call, throwsA(isA<FirebaseException>()));
      });
    });

    /// Send Password Reset Email Test
    ///
    group('SendPasswordResetEmail Test', () {
      test('should send a password reset email', () async {
        // Arrange
        when(auth.sendPasswordResetEmail(email: tEmail))
            .thenAnswer((_) async => unit);

        // Act
        final result = await dataSource.sendPasswordResetEmail(email: tEmail);

        // Assert
        expect(result, unit);
        verify(auth.sendPasswordResetEmail(email: tEmail)).called(1);
        verifyNoMoreInteractions(auth);
      });

      test(
          'should throw a FirebaseAuthException when the password reset email fails',
          () async {
        // Arrange
        when(auth.sendPasswordResetEmail(email: tEmail)).thenThrow(
          FirebaseAuthException(
            code: 'Server Failure',
            message: 'Server Failure',
          ),
        );

        // Act
        final call = dataSource.sendPasswordResetEmail(email: tEmail);

        // Assert
        expect(() => call, throwsA(isA<FirebaseAuthException>()));
      });
    });

    /// Sign Out Test
    ///
    group('SignOut Test', () {
      test('should sign out the user', () async {
        // Arrange
        when(auth.signOut()).thenAnswer((_) async => unit);

        // Act
        final result = await dataSource.signOut();

        // Assert
        expect(result, unit);
        verify(auth.signOut()).called(1);
        verifyNoMoreInteractions(auth);
      });

      test('should throw a FirebaseAuthException when the sign out fails',
          () async {
        // Arrange
        when(auth.signOut()).thenThrow(FirebaseAuthException(
          code: 'Server Failure',
          message: 'Server Failure',
        ));

        // Act
        final call = dataSource.signOut();

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
