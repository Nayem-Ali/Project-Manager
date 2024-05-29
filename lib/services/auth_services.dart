import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../View/auth/login_screen.dart';
import '../Widget/logo.dart';

signInWithGoogle() async {
  final auth = FirebaseAuth.instance;
  if (kIsWeb) {
    GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
    try {
      final UserCredential userCredential = await auth.signInWithPopup(googleAuthProvider);
      return userCredential;
    }
    catch (e) {
      print(e);
    }
  }
  else{
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,

    );

    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

    return userCredential;
  }

  // print(userCredential.user?.email);
  // print(userCredential.user?.displayName);
}

logOutUser() {
  Get.bottomSheet(
    backgroundColor: Colors.white54,
    Column(
      children: [
        const Spacer(),
        Logo(figureSize: 60, fontSize: 12),
        Text(
          "Are you sure to logout?",
          style: TextStyle(
              fontSize: Get.textScaleFactor * 30, fontWeight: FontWeight.bold),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text(
                "No",
                style: TextStyle(
                    fontSize: Get.textScaleFactor * 30,
                    fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              onPressed: () async {
                await GoogleSignIn().signOut();
                FirebaseAuth.instance
                    .signOut()
                    .whenComplete(() {
                  Get.offAll(const LoginScreen());
                });
              },
              child: Text(
                "Yes",
                style: TextStyle(
                    fontSize: Get.textScaleFactor * 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.red
                ),
              ),
            )
          ],
        ),
        const Spacer(),
      ],
    ),
  );
}