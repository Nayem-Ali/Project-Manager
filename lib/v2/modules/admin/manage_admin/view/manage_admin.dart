import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teamlead/v2/core/utils/constant/super_admins.dart';
import 'package:teamlead/v2/modules/admin/manage_admin/controller/manage_admin_controller.dart';
import 'package:teamlead/v2/modules/authentication/controller/user_controller.dart';
import 'package:teamlead/v2/modules/authentication/model/enums.dart';
import 'package:teamlead/v2/modules/authentication/model/teacher_model.dart';
import 'package:teamlead/v2/modules/widgets/k_option_button.dart';

class ManageAdmin extends StatefulWidget {
  const ManageAdmin({super.key});

  @override
  State<ManageAdmin> createState() => _ManageAdminState();
}

class _ManageAdminState extends State<ManageAdmin> {
  final ManageAdminController _manageAdmin = Get.find<ManageAdminController>();
  final UserController _userController = Get.find<UserController>();
  Rx<bool> doesAdminPanel = Rx(true);
  Rx<bool> doesFacultyMember = Rx(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Admin"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Obx(
          () => Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OptionButton(
                    onPressed: () {
                      doesAdminPanel.value = true;
                      doesFacultyMember.value = false;
                    },
                    optionName: "ADMIN",
                    doesFocus: doesAdminPanel.value,
                  ),
                  OptionButton(
                    onPressed: () {
                      doesAdminPanel.value = false;
                      doesFacultyMember.value = true;
                    },
                    optionName: "FACULTY",
                    doesFocus: doesFacultyMember.value,
                  ),
                ],
              ),
              if (doesAdminPanel.value)
                Flexible(
                  child: StreamBuilder(
                    stream: _manageAdmin.getAllAdmin(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<TeacherModel> admins = snapshot.data!.docs
                            .map((data) => TeacherModel.fromJson(data.data()))
                            .toList();
                        if (admins.isEmpty) {
                          return const Center(
                            child: Text(
                              "No admins available.",
                              style: TextStyle(fontSize: 16.0, color: Colors.grey),
                            ),
                          );
                        }
                        // debug(admins);
                        return Column(
                          children: [
                            Flexible(
                              child: ListView.builder(
                                itemCount: admins.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [Colors.green.shade100, Colors.teal.shade200],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                      ),
                                      child: ListTile(
                                        title: Text(
                                          "${admins[index].name} (${admins[index].initial})",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
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
                                                icon: const CircleAvatar(
                                                  backgroundColor: Colors.white,
                                                  child: Icon(
                                                    Icons.remove,
                                                    color: Colors.redAccent,
                                                  ),
                                                ),
                                              )
                                            : const SizedBox.shrink(),
                                      ),
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
                )
              else
                Flexible(
                  child: StreamBuilder(
                    stream: _manageAdmin.getAllTeacher(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<TeacherModel> teachers = snapshot.data!.docs
                            .map((data) => TeacherModel.fromJson(data.data()))
                            .toList();
                        if (teachers.isEmpty) {
                          return const Center(
                            child: Text(
                              "No teachers available.",
                              style: TextStyle(fontSize: 16.0, color: Colors.grey),
                            ),
                          );
                        }
                        return Column(
                          children: [
                            Flexible(
                              child: ListView.builder(
                                itemCount: teachers.length,
                                itemBuilder: (context, index) {
                                  if (teachers[index].role == Roles.admin) {
                                    return const SizedBox.shrink();
                                  }
                                  return Card(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.greenAccent.shade100,
                                            Colors.teal.shade200
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                      ),
                                      child: ListTile(
                                        title: Text(
                                          "${teachers[index].name} (${teachers[index].initial})",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
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
                                                icon: const CircleAvatar(
                                                  backgroundColor: Colors.white,
                                                  child: Icon(
                                                    Icons.add,
                                                    color: Colors.green,
                                                  ),
                                                ),
                                              )
                                            : const SizedBox.shrink(),
                                      ),
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
      ),
    );
  }
}
