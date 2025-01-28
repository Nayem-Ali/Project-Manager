import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:teamlead/v2/core/route/route_name.dart';
import 'package:teamlead/v2/modules/authentication/controller/auth_controller.dart';
import 'package:teamlead/v2/modules/authentication/controller/user_controller.dart';
import 'package:teamlead/v2/modules/authentication/model/student_model.dart';
import 'package:teamlead/v2/modules/widgets/app_logo.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final authController = Get.find<AuthController>();
  final userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const AppLogo(),
            SizedBox(
              width: Get.width * 0.8,
              height: Get.height * 0.05,
              child: ElevatedButton.icon(
                onPressed: () async {
                  UserCredential? credential = await authController.signInWithGoogle();
                  if (credential.user != null) {
                    dynamic data = await userController.getUserData(email: credential.user!.email!);
                    if (data != null) {
                      if(data is StudentModel) {
                        Get.offAllNamed(RouteName.studentHome, arguments: data);
                      } else {
                        // Get.offAllNamed(RouteName.teacherHome, arguments: data);
                      }
                    } else {
                      Get.toNamed(RouteName.info, arguments: credential.user);
                    }
                  }
                },
                icon: const Icon(FontAwesomeIcons.google),
                label: const Text("Sign In with Google"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
