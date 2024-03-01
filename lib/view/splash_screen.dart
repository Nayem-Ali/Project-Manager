import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teamlead/View/auth/info_screen.dart';
import 'package:teamlead/View/auth/login_screen.dart';
import 'package:teamlead/View/student/student_home.dart';
import 'package:teamlead/View/teacher/tracher_screen.dart';
import 'package:teamlead/services/db_service.dart';

import '../Widget/logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  DataBaseMethods dataBaseMethods = DataBaseMethods();
  dynamic userData = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    userData = await dataBaseMethods.getStudent() ?? await dataBaseMethods.getTeacher();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Widget nextScreen = const LoginScreen();
    return AnimatedSplashScreen(
      splash: Logo(fontSize: 30, figureSize: 200),
      splashIconSize: 400,
      duration: 2000,
      nextScreen: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            Get.snackbar("Something went wrong", snapshot.error.toString(),
                duration: const Duration(seconds: 15));
            nextScreen = const LoginScreen();
          }
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data == null) {
              nextScreen = const LoginScreen();
            } else {
              if (userData == null) {
                nextScreen = const InfoScreen();
              } else if (userData.containsKey('role')) {
                print("role: ${userData['role'].toString()}");
                if (userData['role'].toString() == 'teacher') {
                  nextScreen = const TeacherHomeScreen();
                } else {
                  nextScreen = const StudentScreen();
                }
              }
            }
          }
          return nextScreen;
        },
      ),
    );
  }
}
