import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:teamlead/v2/core/database/firebase_db/firebase_handler.dart';
import 'package:teamlead/v2/core/utils/logger/logger.dart';

class AuthController extends GetxController {
  Future<UserCredential> signInWithGoogle() async {
    BotToast.showLoading();
    try {
      if (kIsWeb) {
        GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
        BotToast.showLoading();
        final UserCredential userCredential =
            await FirebaseHandler.auth.signInWithPopup(googleAuthProvider);
        BotToast.closeAllLoading();
        return userCredential;
      } else {
        GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        BotToast.showLoading();
        GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

        AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );

        UserCredential userCredential =
            await FirebaseHandler.auth.signInWithCredential(credential);
        BotToast.closeAllLoading();
        return userCredential;
      }
    } catch (e) {
      BotToast.closeAllLoading();
      debug(e);
      rethrow;
    }

    // debug(userCredential.user?.email);
    // debug(userCredential.user?.displayName);
  }

  Future<bool> signOut() async {
    try {
      await GoogleSignIn().signOut();
      await FirebaseHandler.auth.signOut();
      return true;
    } catch (e) {
      debug(e);
    }
    return false;
  }

}
