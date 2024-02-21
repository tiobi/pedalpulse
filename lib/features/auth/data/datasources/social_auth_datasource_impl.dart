import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pedalpulse/features/auth/core/constants/web_auth_options.keys.dart';
import 'package:pedalpulse/features/auth/data/datasources/social_auth_datasource.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SocialAuthDataSourceImpl implements SocialAuthDataSource {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final GoogleSignIn googleSignIn;

  SocialAuthDataSourceImpl({
    required this.auth,
    required this.firestore,
    required this.googleSignIn,
  });

  @override
  Future<UserCredential> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      /// If Google Sign In Account is not null, then proceed with the authentication.
      /// If there's no user found, Try to create a new user with the given credentials.
      /// If the user already exists, then just sign in the user.
      ///
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential userCredential =
            await auth.signInWithCredential(credential);

        final String uid = userCredential.user!.uid;
        final bool isUserExists = await firestore
            .collection('users')
            .doc(uid)
            .get()
            .then((doc) => doc.exists);

        if (!isUserExists) {
          await firestore.collection('users').doc(uid).set({
            'uid': uid,
            'email': userCredential.user!.email!,
          });
        }

        return userCredential;
      } else {
        throw FirebaseAuthException(
          code: 'user-not-found',
          message: 'User not found',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserCredential> signInWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: clientId,
          redirectUri: Uri.parse(
            redirectUri,
          ),
        ),
      );

      final OAuthCredential credential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      final UserCredential userCredential =
          await auth.signInWithCredential(credential);

      final String uid = userCredential.user!.uid;
      final bool isUserExists = await firestore
          .collection('users')
          .doc(uid)
          .get()
          .then((doc) => doc.exists);

      if (!isUserExists) {
        await firestore.collection('users').doc(uid).set({
          'uid': uid,
          'email': userCredential.user!.email!,
        });
      }

      return userCredential;
    } catch (e) {
      rethrow;
    }
  }
}
