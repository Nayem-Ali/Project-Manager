import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:teamlead/View/auth/login_screen.dart';
import 'package:teamlead/Widget/buttonStyle.dart';
import 'package:teamlead/services/db_service.dart';
import 'package:teamlead/view/selectRoute.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({Key? key}) : super(key: key);

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  bool isTeacher = false;
  bool isStudent = true;
  List<String> sections = ['A', "B", "C", "D", 'E', 'F', 'G', 'H', 'I', 'J', 'K'];
  List<String> designations = [
    'Professor',
    'Associate Professor',
    'Assistant Professor',
    'Lecturer',
    'Adjunct Lecturer'
  ];

  String designation = "";
  String section = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController.text = auth.currentUser!.displayName!;
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController initialController = TextEditingController();
  TextEditingController deptController = TextEditingController();
  TextEditingController batchController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "To Continue",
                      style: TextStyle(
                        fontSize: 22.h,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Add your information",
                      style: TextStyle(
                        fontSize: 18.h,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Hello, ${auth.currentUser!.email}",
                      style: TextStyle(fontSize: 14.h, fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Continue as?",
                      style: TextStyle(fontSize: 22.h, fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          setState(() {
                            isTeacher = true;
                            isStudent = false;
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor:
                              isTeacher ? Colors.greenAccent.shade100 : Colors.transparent,
                          shadowColor: Colors.transparent,
                        ),
                        child: Text(
                          "Teacher",
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.h,
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      OutlinedButton(
                          onPressed: () {
                            setState(() {
                              isTeacher = false;
                              isStudent = true;
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor:
                                isStudent ? Colors.greenAccent.shade100 : Colors.transparent,
                            shadowColor: Colors.transparent,
                          ),
                          child: Text(
                            "Student",
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.h,
                            ),
                          )),
                    ],
                  ),
                  if (isStudent)
                    Column(
                      children: [
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                            label: const Text('Full Name'),
                            labelStyle: TextStyle(fontSize: 14.h, fontWeight: FontWeight.bold),
                            filled: true,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: idController,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "This field is required";
                            } else if (RegExp(r'^(\d){10,15}$').hasMatch(value) == false) {
                              return "Follow format: 53 or 59";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            label: const Text('Student ID'),
                            labelStyle: TextStyle(fontSize: 14.h, fontWeight: FontWeight.bold),
                            filled: true,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: batchController,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "This field is required";
                                  } else if (RegExp(r'^(\d){2,3}$').hasMatch(value) == false) {
                                    return "Follow format: 53 or 59";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  label: const Text('Batch'),
                                  labelStyle:
                                      TextStyle(fontSize: 14.h, fontWeight: FontWeight.bold),
                                  filled: true,
                                  border: const OutlineInputBorder(),
                                ),
                              ),
                            ),
                            SizedBox(width: 20.h),
                            Expanded(
                              child: DropdownButtonFormField(
                                //alignment: Alignment.bottomCenter,
                                //  value: designation,
                                validator: (value) {
                                  if (section == "") {
                                    return "This field is required";
                                  }
                                  return null;
                                },
                                items: sections
                                    .map(
                                      (value) => DropdownMenuItem(
                                        value: value,
                                        child: Text(value),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  section = value!;
                                },
                                decoration: InputDecoration(
                                  label: const Text('Section'),
                                  labelStyle: TextStyle(
                                    fontSize: 14.h,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  filled: true,
                                  border: const OutlineInputBorder(),
                                ),
                              ),
                            )
                          ],
                        ),
                        // const SizedBox(height: 10),
                        // TextFormField(
                        //   controller: deptController,
                        //   decoration: const InputDecoration(
                        //     label: Text('Department'),
                        //     labelStyle: TextStyle(
                        //         fontSize: 16, fontWeight: FontWeight.bold),
                        //     filled: true,
                        //     border: OutlineInputBorder(),
                        //   ),
                        // ),
                      ],
                    ),
                  if (isTeacher)
                    Column(
                      children: [
                        SizedBox(height: 10.h),
                        TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                            label: const Text('Full Name'),
                            labelStyle: TextStyle(fontSize: 14.h, fontWeight: FontWeight.bold),
                            filled: true,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: initialController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "This field is required";
                            } else if (RegExp(r'[A-Z]{3,5}').hasMatch(value) == false) {
                              return "Only uppercase later is allowed";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            label: const Text('Initial'),
                            hintText: 'Example: SRK,JIM',
                            labelStyle: TextStyle(fontSize: 14.h, fontWeight: FontWeight.bold),
                            filled: true,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                        // const SizedBox(height: 10),
                        // TextFormField(
                        //   controller: deptController,
                        //   decoration: const InputDecoration(
                        //     label: Text('Department'),
                        //     labelStyle: TextStyle(
                        //         fontSize: 16, fontWeight: FontWeight.bold),
                        //     filled: true,
                        //     border: OutlineInputBorder(),
                        //   ),
                        // ),
                        SizedBox(height: 10.h),
                        DropdownButtonFormField(
                          //alignment: Alignment.bottomCenter,
                          // value: designation,
                          validator: (value) {
                            if (designation == "") {
                              return "This field is required";
                            }
                            return null;
                          },
                          items: designations
                              .map(
                                (value) => DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            ),
                          )
                              .toList(),
                          onChanged: (value) {
                            designation = value!;

                            // print(designation);
                          },
                          decoration: InputDecoration(
                            label: const Text('Designation'),
                            labelStyle: TextStyle(
                              fontSize: 14.h,
                              fontWeight: FontWeight.bold,
                            ),
                            filled: true,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  OutlinedButton.icon(
                    onPressed: () async {
                      await GoogleSignIn().signOut();
                      FirebaseAuth.instance.signOut().whenComplete(() {
                        Get.offAll(const LoginScreen());
                      });
                    },
                    icon: const Icon(Icons.arrow_back),
                    label: const Text("Back"),
                  ),
                  SizedBox(height: 20.h),
                  ElevatedButton.icon(
                    onPressed: () async {
                      DataBaseMethods db = DataBaseMethods();
                      Map<String, dynamic> info = {};
                      if (formKey.currentState!.validate()) {
                        if (isTeacher) {
                          info["name"] = nameController.text.trim();
                          info["initial"] = initialController.text.trim();
                          info["designation"] = designation;
                          info['role'] = 'teacher';
                          info['status'] = 'pending';
                          await db.addTeacher(info);
                        } else {
                          info["name"] = nameController.text.trim();
                          info["id"] = idController.text.trim();
                          info["batch"] = batchController.text.trim();
                          info['section'] = section;
                          info["title"] = "";
                          info["projectType"] = "";
                          info['role'] = 'student';
                          info['PID'] = 0;
                          await db.addStudent(info);
                        }
                      }
                      Get.offAll(const SelectRoute());
                    },
                    label: Text(
                      "Continue",
                      style: TextStyle(
                        fontSize: 16.h,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    icon: const Icon(Icons.play_arrow),
                    style: buttonStyle(250, 40),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
