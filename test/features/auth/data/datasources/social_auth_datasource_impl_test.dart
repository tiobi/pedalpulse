import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pedalpulse/features/auth/data/datasources/social_auth_datasource.dart';
import 'package:pedalpulse/features/auth/data/datasources/social_auth_datasource_impl.dart';

import '../../../../mocks/auth/firebase/mock_firebase_auth.mocks.dart';
import '../../../../mocks/auth/social/mock_google_sign_in.mocks.dart';
import '../../../../mocks/auth/social/mock_google_sign_in_account.mocks.dart';
import '../../../../mocks/auth/social/mock_google_sign_in_authentication.mocks.dart';
import '../../../../mocks/database/mock_collection_reference.mocks.dart';
import '../../../../mocks/database/mock_document_refernce.mocks.dart';
import '../../../../mocks/database/mock_firebasse_firestore.mocks.dart';
import '../../../../mocks/user/mock_user.mocks.dart';

void main() {
  late SocialAuthDataSource dataSource;
  late MockFirebaseAuth auth;
  late MockFirebaseFirestore firestore;
  late MockGoogleSignIn googleSignIn;

  late MockUser user;
  late MockGoogleSignInAccount googleSignInAccount;
  late MockGoogleSignInAuthentication googleSignInAuthentication;
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

    user = MockUser();
    googleSignInAccount = MockGoogleSignInAccount();
    googleSignInAuthentication = MockGoogleSignInAuthentication();

    collection = MockCollectionReference();
    document = MockDocumentReference();

    when(firestore.collection(any)).thenReturn(collection);
    when(collection.doc(any)).thenReturn(document);
  });

  group('Social Auth Datasource Impl Test', () {
    group('SignInWithGoogle Test', () {
      test('should sign in the use with google account.', () async {});
    });
    test('if google sign in account is null, throw FirebaseAuthException',
        () async {});
    test('if user is not found, throw FirebaseAuthException', () async {});
  });
}
