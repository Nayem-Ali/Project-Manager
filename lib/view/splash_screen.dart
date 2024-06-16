import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teamlead/View/auth/info_screen.dart';
import 'package:teamlead/View/auth/login_screen.dart';
import 'package:teamlead/View/student/student_home.dart';
import 'package:teamlead/View/teacher/tracher_screen.dart';
import 'package:teamlead/services/db_service.dart';
import 'package:teamlead/view/selectRoute.dart';

import '../Widget/logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {



  @override
  Widget build(BuildContext context) {
    Widget nextScreen = const LoginScreen();
    return AnimatedSplashScreen(
      splash: Logo(fontSize: 30, figureSize: 200),
      splashIconSize: 400,
      duration: 500,
      nextScreen: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            nextScreen = const LoginScreen();
          }
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data == null) {
              nextScreen = const LoginScreen();
            } else {
              nextScreen = const SelectRoute();
            }
          }
          return nextScreen;
        },
      ),
    );
  }
}
