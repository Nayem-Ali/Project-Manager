import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:teamlead/v2/featuers/widgets/app_logo.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
                onPressed: () {},
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
