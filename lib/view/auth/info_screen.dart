import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:teamlead/View/auth/login_screen.dart';
import 'package:teamlead/View/splash_screen.dart';
import 'package:teamlead/View/student/student_home.dart';
import 'package:teamlead/View/teacher/tracher_screen.dart';
import 'package:teamlead/services/db_service.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({Key? key}) : super(key: key);

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  bool isTeacher = false;
  bool isStudent = true;

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
                        fontSize: Get.textScaleFactor * 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Add your information",
                      style: TextStyle(fontSize: Get.textScaleFactor * 20, fontWeight: FontWeight
                          .w600),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Hello, ${auth.currentUser!.email}",
                      style: TextStyle(fontSize: Get.textScaleFactor*16, fontWeight:
                      FontWeight.w700),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Continue as?",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(height: 10),
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
                        child: const Text(
                          "Teacher",
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
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
                          child: const Text(
                            "Student",
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
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
                          decoration: const InputDecoration(
                            label: Text('Full Name'),
                            labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            filled: true,
                            border: OutlineInputBorder(),
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
                          decoration: const InputDecoration(
                            label: Text('Student ID'),
                            labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            filled: true,
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),
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
                                decoration: const InputDecoration(
                                  label: Text('Batch'),
                                  labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  filled: true,
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
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
                                items: const [
                                  DropdownMenuItem(
                                    value: "A",
                                    child: Text("A"),
                                  ),
                                  DropdownMenuItem(
                                    value: "B",
                                    child: Text("B"),
                                  ),
                                  DropdownMenuItem(
                                    value: "C",
                                    child: Text("C"),
                                  ),
                                  DropdownMenuItem(
                                    value: "D",
                                    child: Text("D"),
                                  ),
                                  DropdownMenuItem(
                                    value: "E",
                                    child: Text("E"),
                                  ),
                                  DropdownMenuItem(
                                    value: "F",
                                    child: Text("F"),
                                  ),
                                  DropdownMenuItem(
                                    value: "G",
                                    child: Text("G"),
                                  ),
                                  DropdownMenuItem(
                                    value: "H",
                                    child: Text("H"),
                                  ), //
                                  DropdownMenuItem(
                                    value: "I",
                                    child: Text("I"),
                                  ),
                                  DropdownMenuItem(
                                    value: "J",
                                    child: Text("J"),
                                  ),
                                ],
                                onChanged: (value) {
                                  section = value!;
                                },
                                decoration: const InputDecoration(
                                  label: Text('Section'),
                                  labelStyle: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  filled: true,
                                  border: OutlineInputBorder(),
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
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            label: Text('Full Name'),
                            labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            filled: true,
                            border: OutlineInputBorder(),
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
                          decoration: const InputDecoration(
                            label: Text('Initial'),
                            hintText: 'Example: SRK,JIM',
                            labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            filled: true,
                            border: OutlineInputBorder(),
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
                        const SizedBox(height: 10),
                        DropdownButtonFormField(
                          //alignment: Alignment.bottomCenter,
                          // value: designation,
                          validator: (value) {
                            if (designation == "") {
                              return "This field is required";
                            }
                            return null;
                          },
                          items: const [
                            DropdownMenuItem(
                              value: "Professor",
                              child: Text("Professor"),
                            ),
                            DropdownMenuItem(
                              value: "Associate Professor",
                              child: Text("Associate Professor"),
                            ),
                            DropdownMenuItem(
                              value: "Assistant Professor",
                              child: Text("Assistant Professor"),
                            ),
                            DropdownMenuItem(
                              value: "Lecturer",
                              child: Text("Lecturer"),
                            ),
                            // DropdownMenuItem(
                            //   value: "A",
                            //   child: Text("A"),
                            // ),
                            // DropdownMenuItem(
                            //   value: "A",
                            //   child: Text("A"),
                            // ),
                          ],
                          onChanged: (value) {
                            designation = value!;

                            print(designation);
                          },
                          decoration: const InputDecoration(
                            label: Text('Designation'),
                            labelStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            filled: true,
                            border: OutlineInputBorder(),
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
                  const SizedBox(height: 20),
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
                          info["submitted"] = "no";
                          info["title"] = "";
                          info["projectType"] = "";
                          info['role'] = 'student';
                          await db.addStudent(info);
                        }
                      }
                      Get.offAll(const SplashScreen());
                    },
                    label: const Text(
                      "Continue",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    icon: const Icon(Icons.play_arrow),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(250, 50),
                    ),
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
