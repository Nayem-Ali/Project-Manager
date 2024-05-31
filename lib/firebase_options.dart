// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyCLypnwO7g0n084BEWLOdhyNajNbOJxTRU",
    appId: "1:933388745290:web:22a36345fe86cfefbb04b3",
    messagingSenderId: "933388745290",
    projectId: "project-manager-4cea3",
    authDomain: "project-manager-4cea3.firebaseapp.com",
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "AIzaSyCLypnwO7g0n084BEWLOdhyNajNbOJxTRU",
    appId: "1:933388745290:web:22a36345fe86cfefbb04b3",
    messagingSenderId: "933388745290",
    projectId: "project-manager-4cea3",
  );
}

