import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:pedalpulse/services/firebase/user_firestore_methods.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../providers/user_provider_depr.dart';
import '../../utils/managers/message_manager.dart';

class SocialAuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<String> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);

        // check if user uid exists in firestore
        final String uid = userCredential.user!.uid;
        final bool isUserExists =
            await UserFirestoreMethods().isUserExists(uid: uid);
        if (!isUserExists) {
          await UserFirestoreMethods().uploadUserData(
            uid: uid,
            email: userCredential.user!.email!,
          );
        }

        await _auth.signInWithCredential(credential);

        await UserProviderDepr().setUser(); // Update user information if needed

        return NetworkMessageManager.success;
      } else {
        return NetworkMessageManager.error;
      }
    } catch (e) {
      // return NetworkMessageManager.error;
      return e.toString();
    }
  }

  Future<String> signInWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: 'com.pedalpulse.app',
          redirectUri: Uri.parse(
            'https://pedalpulse.com',
          ),
        ),
      );

      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      final UserCredential credential =
          await FirebaseAuth.instance.signInWithCredential(oauthCredential);

      final String uid = credential.user!.uid;
      final String email = credential.user!.email!;

      final bool isUserExists =
          await UserFirestoreMethods().isUserExists(uid: uid);

      if (!isUserExists) {
        await UserFirestoreMethods().uploadUserData(
          uid: uid,
          email: email,
        );
      }

      await UserProviderDepr().setUser(); // Update user information if needed

      return NetworkMessageManager.success;
    } catch (e) {
      return NetworkMessageManager.error;
    }
  }
}
