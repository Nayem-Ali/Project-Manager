

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teamlead/View/splash_screen.dart';
import 'package:teamlead/View/teacher/tracher_screen.dart';
import 'package:teamlead/services/auth_services.dart';
import 'package:teamlead/View/auth/info_screen.dart';

import '../../Widget/logo.dart';
import '../student/student_home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {


  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Logo(fontSize: 25, figureSize: 170),
              // Container(
              //   margin: const EdgeInsets.symmetric(horizontal: 8),
              //   child: Form(
              //     child: Column(
              //       children: [
              //         TextFormField(
              //           decoration: const InputDecoration(
              //             prefixIcon: Icon(
              //               Icons.email_outlined,
              //               color: Colors.teal,
              //             ),
              //             hintText: "Enter g-suit email",
              //             hintStyle: TextStyle(
              //                 fontWeight: FontWeight.bold, fontSize: 16),
              //             border: OutlineInputBorder(),
              //           ),
              //         ),
              //         const SizedBox(height: 20),
              //         TextFormField(
              //           decoration: const InputDecoration(
              //             prefixIcon: Icon(
              //               Icons.lock_outline,
              //               color: Colors.teal,
              //             ),
              //             hintText: "Enter password",
              //             hintStyle: TextStyle(
              //                 fontWeight: FontWeight.bold, fontSize: 16),
              //             border: OutlineInputBorder(),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // TextButton(
              //     onPressed: showModal,
              //     child: const Text(
              //       "Forget Password?",
              //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              //     )),
              SizedBox(height: MediaQuery.of(context).size.height*0.4,),
              OutlinedButton.icon(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(250, 50),
                  textStyle: GoogleFonts.aBeeZee(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () async {
                  UserCredential credential = await signInWithGoogle();
                  Get.off(const SplashScreen());
                },
                icon: const FaIcon(FontAwesomeIcons.google,color: Colors.deepOrange,),
                label: const Text(
                  "Continue with Google",
                  style: TextStyle(color: Colors.black87),
                ),
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     const Text(
              //       "Did not have an account?",
              //       style: TextStyle(fontSize: 16),
              //     ),
              //     TextButton(
              //         onPressed: () {
              //           Get.off(
              //             const SignupScreen(),
              //           );
              //         },
              //         child: const Text(
              //           "Sign Up",
              //           style: TextStyle(
              //               fontSize: 16, fontWeight: FontWeight.bold),
              //         ))
              //   ],
              // ),
              // TextButton(
              //   onPressed: () {
              //     Get.off(
              //       const SignupScreen(),
              //     );
              //   },
              //   child: const Text(
              //     "Login as Admin",
              //     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              //   ),
              // )
            ],
          ),
        ),
      ),
    ));
  }
}
