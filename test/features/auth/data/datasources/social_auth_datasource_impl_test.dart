import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pedalpulse/features/auth/data/datasources/social_auth_datasource.dart';
import 'package:pedalpulse/features/auth/data/datasources/social_auth_datasource_impl.dart';

import '../../mocks/mock_collection_reference.mocks.dart';
import '../../mocks/mock_document_refernce.mocks.dart';
import '../../mocks/mock_firebase_auth.mocks.dart';
import '../../mocks/mock_firebasse_firestore.mocks.dart';
import '../../mocks/mock_google_sign_in.mocks.dart';
import '../../mocks/mock_user.mocks.dart';

void main() {
  late SocialAuthDataSource dataSource;
  late MockFirebaseAuth auth;
  late MockFirebaseFirestore firestore;
  late MockGoogleSignIn googleSignIn;

  late MockUser user;
  late MockCollectionReference collection;
  late MockDocumentReference document;

  setUp(() {
    auth = MockFirebaseAuth();
    firestore = MockFirebaseFirestore();
    googleSignIn = MockGoogleSignIn();
    user = MockUser();

    dataSource = SocialAuthDataSourceImpl(
      auth: auth,
      firestore: firestore,
      googleSignIn: googleSignIn,
    );

    collection = MockCollectionReference();
    document = MockDocumentReference();

    when(firestore.collection(any)).thenReturn(collection);
    when(collection.doc(any)).thenReturn(document);
  });

  group('Social Auth Datasource Impl Test', () {
    group('SignInWithGoogle Test', () {
      test('should sign in the use with google account.', () async {
        when(googleSignIn)
      });
      test('if google sign in account is null, throw FirebaseAuthException',
          () async {});
      test('if user is not found, throw FirebaseAuthException', () async {});
    });
  });
}
