import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teamlead/v2/core/utils/constant/super_admins.dart';
import 'package:teamlead/v2/modules/admin/manage_admin/controller/manage_admin_controller.dart';
import 'package:teamlead/v2/modules/authentication/controller/user_controller.dart';
import 'package:teamlead/v2/modules/authentication/model/enums.dart';
import 'package:teamlead/v2/modules/authentication/model/teacher_model.dart';

class ManageAdmin extends StatefulWidget {
  const ManageAdmin({super.key});

  @override
  State<ManageAdmin> createState() => _ManageAdminState();
}

class _ManageAdminState extends State<ManageAdmin> {
  final ManageAdminController _manageAdmin = Get.find<ManageAdminController>();
  final UserController _userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Admin"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            Flexible(
              child: StreamBuilder(
                stream: _manageAdmin.getAllAdmin(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<TeacherModel> admins = snapshot.data!.docs
                        .map((data) => TeacherModel.fromJson(data.data()))
                        .toList();
                    // debug(admins);
                    return Column(
                      children: [
                        Divider(thickness: 2, color: Theme.of(context).primaryColor),
                        const Text("ADMIN PANEL"),
                        Divider(thickness: 2, color: Theme.of(context).primaryColor),
                        Flexible(
                          child: ListView.builder(
                            itemCount: admins.length,
                            itemBuilder: (context, index) {
                              return Card(
                                child: ListTile(
                                  title: Text("${admins[index].name} (${admins[index].initial})"),
                                  subtitle: Text("${admins[index].email}"),
                                  trailing: SuperAdmins.superAdmins
                                          .contains(_userController.teacher.value.email)
                                      ? IconButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text("Acknowledgement"),
                                                  content: Text(
                                                      "Are you sure to remove ${admins[index].name} from admin"),
                                                  actionsAlignment: MainAxisAlignment.center,
                                                  actions: [
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        admins[index].role = Roles.teacher;
                                                        _manageAdmin.updateRole(
                                                          newAdmin: admins[index],
                                                        );
                                                        Get.back();
                                                      },
                                                      child: const Text("YES"),
                                                    ),
                                                    ElevatedButton(
                                                        onPressed: () {
                                                          Get.back();
                                                        },
                                                        child: const Text("NO")),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          icon: const Icon(Icons.remove),
                                        )
                                      : const SizedBox.shrink(),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
            ),
            Flexible(
              child: StreamBuilder(
                stream: _manageAdmin.getAllTeacher(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<TeacherModel> teachers = snapshot.data!.docs
                        .map((data) => TeacherModel.fromJson(data.data()))
                        .toList();
                    return Column(
                      children: [
                        Divider(thickness: 2, color: Theme.of(context).primaryColor),
                        const Text("FACULTY MEMBERS"),
                        Divider(thickness: 2, color: Theme.of(context).primaryColor),
                        Flexible(
                          child: ListView.builder(
                            itemCount: teachers.length,
                            itemBuilder: (context, index) {
                              return Card(
                                child: ListTile(
                                  title:
                                      Text("${teachers[index].name} (${teachers[index].initial})"),
                                  subtitle: Text("${teachers[index].email}"),
                                  trailing: SuperAdmins.superAdmins
                                          .contains(_userController.teacher.value.email)
                                      ? IconButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text("Acknowledgement"),
                                                  content: Text(
                                                      "Are you sure to add ${teachers[index].name} as admin"),
                                                  actionsAlignment: MainAxisAlignment.center,
                                                  actions: [
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        teachers[index].role = Roles.admin;
                                                        _manageAdmin.updateRole(
                                                            newAdmin: teachers[index]);
                                                        Get.back();
                                                      },
                                                      child: const Text("YES"),
                                                    ),
                                                    ElevatedButton(
                                                        onPressed: () {
                                                          Get.back();
                                                        },
                                                        child: const Text("NO")),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          icon: const Icon(Icons.add))
                                      : const SizedBox.shrink(),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
