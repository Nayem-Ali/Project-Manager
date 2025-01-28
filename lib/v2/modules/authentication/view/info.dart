import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:teamlead/v2/core/database/firebase_db/firebase_handler.dart';
import 'package:teamlead/v2/core/route/route_name.dart';
import 'package:teamlead/v2/core/utils/logger/logger.dart';
import 'package:teamlead/v2/modules/authentication/controller/auth_controller.dart';
import 'package:teamlead/v2/modules/authentication/view/components/student_form.dart';
import 'package:teamlead/v2/modules/authentication/view/components/teacher_form.dart';
import 'package:teamlead/v2/modules/widgets/option_button.dart';

class Info extends StatefulWidget {
  const Info({super.key, required this.user});

  final User user;

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> {
  RxBool doesStudent = RxBool(true);
  RxBool doesTeacher = RxBool(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () async {
            await Get.find<AuthController>().signOut();
            Get.offNamed(RouteName.login);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text("Complete Profile"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 20.0),
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "To Continue, Provide Necessary Details",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      letterSpacing: 1.5,
                    ),
              ),
              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 12),
              Text(
                "Hello, ${widget.user.displayName ?? "User"} 👋",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              const SizedBox(height: 20),
              Text(
                "Continue as?",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: OptionButton(
                      onPressed: () {
                        doesStudent.value = true;
                        doesTeacher.value = false;
                      },
                      optionName: "Student",
                      doesFocus: doesStudent.value,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OptionButton(
                      onPressed: () {
                        doesTeacher.value = true;
                        doesStudent.value = false;
                      },
                      optionName: "Teacher",
                      doesFocus: doesTeacher.value,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              doesTeacher.value
                  ? TeacherForm(user: widget.user)
                  : StudentForm(user: widget.user),


            ],
          ),
        ),
      ),
    );
  }
}
