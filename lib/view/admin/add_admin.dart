import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:teamlead/View/admin/admin_home.dart';
import 'package:teamlead/services/db_service.dart';

class AddAdmin extends StatefulWidget {
  const AddAdmin({Key? key}) : super(key: key);

  @override
  State<AddAdmin> createState() => _AddAdminState();
}

class _AddAdminState extends State<AddAdmin> {
  DataBaseMethods dataBaseMethods = DataBaseMethods();
  String? currentUserEmail = FirebaseAuth.instance.currentUser!.email;
  dynamic admins = [];
  dynamic allTeacherEmail = [];
  dynamic teacherData = [];
  dynamic adminPanel = [];
  dynamic adminCandidate = [];
  String selectedAdmin = "";
  String email = "";
  List<String> superAdmins = ["project_cse@lus.ac.bd", "nayemacademic14@gmail.com"];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    teacherData = await dataBaseMethods.getAllTeacherData();
    admins = await dataBaseMethods.getAdmin();
    allTeacherEmail = await dataBaseMethods.getAllTeacherEmail();
    for (int i = 0; i < admins.length; i++) {
      allTeacherEmail.remove(admins[i]);
    }
    for (var data in teacherData) {
      for (int i = 0; i < admins.length; i++) {
        if (data['email'] == admins[i]) {
          adminPanel.add(data);
        }
      }
      for (int i = 0; i < allTeacherEmail.length; i++) {
        if (data['email'] == allTeacherEmail[i] && data['status'] == 'approved') {
          adminCandidate.add(data);
        }
      }
    }
    setState(() {
      // if(adminCandidate.isNotEmpty) {
      //   selectedAdmin = adminCandidate[0]['name'];
      // }
    });
  }

  removeAdmin(dynamic adminData) {
    Get.defaultDialog(
        title: "Attention",
        middleText: "Are you sure remove ${adminData['name']} from admin",
        actions: [
          TextButton(
            onPressed: () async {
              // print(admins);
              admins.remove(adminData['email']);
              // print(admins);
              await dataBaseMethods.addAdmin(admins);
              admins.clear();
              adminPanel.clear();
              adminCandidate.clear();
              teacherData.clear();
              allTeacherEmail.clear();
              await getData();
              Get.back();
            },
            child: const Text("Yes"),
          ),
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text("No"),
          ),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Add Admin"),
          centerTitle: true,
        ),
        body: Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: DropdownButtonFormField(
                      // alignment: Alignment.bottomCenter,
                      // value: selectedSupervisor,
                      // validator: (value) {
                      //   if (designation == "") {
                      //     return "This field is required";
                      //   }
                      //   return null;
                      // },
                      items: [
                        for (var teacher in adminCandidate)
                          DropdownMenuItem(
                            value: teacher['name'].toString(),
                            child: Text(
                              teacher["name"],
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                      onChanged: (value) {
                        selectedAdmin = value.toString();

                        // print(selectedSupervisor);
                      },
                      decoration: const InputDecoration(
                        label: Text('Select Admin'),
                        labelStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        filled: true,
                        border: OutlineInputBorder(borderRadius: BorderRadius.zero),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      for (var teacher in adminCandidate) {
                        if (teacher['name'] == selectedAdmin) {
                          admins.add(teacher['email']);
                          // adminCandidate.remove(teacher['email']);
                          break;
                        }
                      }
                      // print(admins);
                      await dataBaseMethods.addAdmin(admins);

                      Get.off(const AdminHome());
                      Get.showSnackbar(const GetSnackBar(
                        duration: Duration(seconds: 3),
                        backgroundColor: Colors.green,
                        message: "Admin added successfully",
                      ));
                    },
                    // icon: const Icon(Icons.add),
                    child: Text("ADD"),
                  ),
                ],
              ),
              const Divider(thickness: 2),
              Text(
                "Admin Panel",
                style: TextStyle(fontSize: 28.h, fontWeight: FontWeight.bold),
              ),
              const Divider(thickness: 2),
              Expanded(
                flex: 5,
                child: ListView.builder(
                  itemCount: adminPanel.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        trailing: superAdmins.contains(currentUserEmail)
                            ? IconButton(
                                onPressed: () async {
                                  removeAdmin(adminPanel[index]);
                                },
                                icon: const Icon(Icons.remove))
                            : const SizedBox(),
                        title: Text(
                          '${adminPanel[index]['name']} ',
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          "${adminPanel[index]['email']} "
                          "(${adminPanel[index]['designation']})",
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Expanded(
              //   child: ListView.builder(
              //     itemCount: adminCandidate.length,
              //     itemBuilder: (context, index) {
              //       return Card(
              //         child: ListTile(title: Text(adminCandidate[index]['name'])),
              //       );
              //     },
              //   ),
              // ),
            ],
          ),
        ));
  }
}
