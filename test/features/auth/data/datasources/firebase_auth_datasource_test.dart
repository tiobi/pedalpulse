import 'package:dartz/dartz.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_auth_mocks/src/mock_user_credential.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pedalpulse/features/auth/data/datasources/firebase_auth_datasource_impl.dart';
import 'package:pedalpulse/features/auth/domain/entities/auth_entity.dart';

void main() {
  late final FakeFirebaseFirestore firestore;
  late final MockFirebaseAuth auth;
  late final FirebaseAuthDataSourceImpl dataSource;

  setUp() {
    firestore = FakeFirebaseFirestore();
    auth = MockFirebaseAuth();
    dataSource = FirebaseAuthDataSourceImpl(
      firestore: firestore,
      auth: auth,
    );
  }

  const AuthEntity tAuthEntity = AuthEntity(
    email: 'hello@world.com',
    password: 'password',
  );

  MockUserCredential userCredential = MockUserCredential(
    false,
    mockUser: MockUser(
      isAnonymous: false,
      email: tAuthEntity.email,
    ),
  );

  group('signUpWithEmailAndPassword', () {
    test('should sign up with email and password', () async {
      // arrange
      when(auth.createUserWithEmailAndPassword(
        email: tAuthEntity.email,
        password: tAuthEntity.password,
      )).thenAnswer((_) async => userCredential);

      // act
      final result =
          await dataSource.signUpWithEmailAndPassword(authEntity: tAuthEntity);

      // assert
      expect(result, isA<Unit>());
    });
  });
}
