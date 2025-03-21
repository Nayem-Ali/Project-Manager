import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:teamlead/v2/modules/shared/profile/view/components/about_us.dart';
import 'package:teamlead/v2/core/database/firebase_db/firebase_handler.dart';
import 'package:teamlead/v2/core/route/route_name.dart';
import 'package:teamlead/v2/modules/authentication/controller/auth_controller.dart';
import 'package:teamlead/v2/modules/authentication/model/student_model.dart';
import 'package:teamlead/v2/modules/authentication/model/teacher_model.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key, required this.data});

  final Object data;

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  StudentModel student = StudentModel();
  TeacherModel teacher = TeacherModel();

  @override
  void initState() {
    if (widget.data is StudentModel) {
      student = widget.data as StudentModel;
    } else {
      teacher = widget.data as TeacherModel;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isStudent = widget.data is StudentModel;

    return Scaffold(
      appBar: AppBar(
        title: Text(isStudent ? "Student Profile" : "Teacher Profile"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Image
              Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  border: Border.all(width: 3, color: Theme.of(context).colorScheme.primary),
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(FirebaseHandler.auth.currentUser!.photoURL!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // User Details Card
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      profileRow(
                        title: "Name",
                        value: isStudent ? student.name ?? "" : teacher.name ?? "",
                        icon: Icons.person,
                      ),
                      profileRow(
                        title: isStudent ? "Student ID" : "Initial",
                        value: isStudent ? student.id ?? "" : teacher.initial ?? "",
                        icon: Icons.badge,
                      ),
                      profileRow(
                        title: isStudent ? "Batch (Section)" : "Designation",
                        value: isStudent
                            ? "${student.batch} (${student.section})"
                            : teacher.designation ?? "",
                        icon: isStudent ? Icons.groups : Icons.work,
                      ),
                      profileRow(
                        title: "Email",
                        value: FirebaseHandler.auth.currentUser!.email!.trim() ?? "N/A",
                        icon: Icons.email,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Logout Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Get.dialog(AlertDialog(
                      title: const Text("Are you sure to logout?"),
                      actionsAlignment: MainAxisAlignment.center,
                      actions: [
                        ElevatedButton(
                          onPressed: () async {
                            await Get.find<AuthController>().signOut();
                            Get.offAllNamed(RouteName.login);
                          },
                          child: const Text("Yes"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: const Text("No"),
                        ),
                      ],
                    ));
                  },
                  icon: const Icon(Icons.exit_to_app),
                  label: const Text("Log Out"),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    textStyle: Theme.of(context).textTheme.labelLarge,
                    side: BorderSide(color: Theme.of(context).colorScheme.primary),
                  ),
                ),
              ),
              Spacer(),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Get.to(()=>AboutUs());
                    },
                    icon: const Icon(Icons.info_outline),
                    label: const Text("About Us"),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      textStyle: Theme.of(context).textTheme.labelLarge,
                      side: BorderSide(color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget profileRow({required String title, required String value, required IconData icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            "$title: ",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Flexible(
            child: Text(
              value,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
