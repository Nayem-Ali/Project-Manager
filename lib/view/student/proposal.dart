import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:teamlead/View/student/student_home.dart';
import 'package:teamlead/Widget/buttonStyle.dart';
import 'package:teamlead/services/db_service.dart';

// import 'package:teamlead/services/google_sheets_api.dart';

import '../../model/proposal_model.dart';
import '../../services/proposal_sheets_api.dart';

class Proposal extends StatefulWidget {
  const Proposal({Key? key}) : super(key: key);

  @override
  State<Proposal> createState() => _ProposalState();
}

class _ProposalState extends State<Proposal> {
  DataBaseMethods dataBaseMethods = DataBaseMethods();
  bool cse3300 = true;
  bool cse4800 = false;
  bool isMember4 = false;
  bool isMember3 = false;
  bool isPreference = Get.arguments[0];
  String courseCode = Get.arguments[1];

  final formKey = GlobalKey<FormState>();

  RegExp cgpaValidator = RegExp(r"^(\d){1}\.(\d){1,2}$");
  RegExp nameValidator = RegExp(
      r"(^[A-Za-z\.]{2,16})([ ]{0,1})([A-Za-z]{2,16})?([ ]{0,1})?([A-Za-z]{2,16})?([ ]{0,1})?([A-Za-z]{2,16})$");
  RegExp idValidator = RegExp(r"[\d]{10,15}");
  RegExp emailValidator = RegExp(r"^[A-Za-z0-9_]{14,25}@lus\.ac\.bd$");
  RegExp cellValidator = RegExp(r"(^(\+88|0088)?(01){1}[3456789]{1}(\d){8})$");
  RegExp linkValidator = RegExp(
      r'^https:\/\/drive\.google\.com\/(?:file\/d\/|open\?id=|drive\/folders\/)([a-zA-Z0-9_-]+)(?:\/view)?(?:\?[^&]+)?$');

  String s1 = "";
  String s2 = "";
  String s3 = "";

  dynamic initials = [];
  List<String> titles1 = [];
  List<String> titles2 = [];

  TextEditingController title = TextEditingController();
  TextEditingController link = TextEditingController();
  List<TextEditingController> name = [];
  List<TextEditingController> id = [];
  List<TextEditingController> cgpa = [];
  List<TextEditingController> email = [];
  List<TextEditingController> number = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    for (int i = 0; i < 2; i++) {
      name.add(TextEditingController());
      id.add(TextEditingController());
      cgpa.add(TextEditingController());
      email.add(TextEditingController());
      number.add(TextEditingController());
    }
    initials = await dataBaseMethods.getAllSupervisorInitial();
    initials = initials.toSet().toList();
    initials.sort();
    titles1 = await ProjectSheetApi.getColumn('CSE-3300', 'Title');
    titles2 = await ProjectSheetApi.getColumn('CSE-3300-team-request', 'Title');
    setState(() {});
  }

  addToSheet() async {
    String studentName = "";
    String studentID = "";
    String studentCGPA = "";
    String studentEmail = "";
    String studentPhone = "";
    for (int i = 0; i < name.length; i++) {
      studentName += "${name[i].text.trim()}\n";
      studentID += "${id[i].text.trim()}\n";
      studentCGPA += "${cgpa[i].text.trim()}\n";
      studentEmail += "${email[i].text.trim()}\n";
      studentPhone += "${number[i].text.trim()}\n";
    }

    final data = {
      ProposalFields.id: "",
      ProposalFields.title: title.text.trim(),
      ProposalFields.link: link.text.trim(),
      ProposalFields.supervisor: "",
      ProposalFields.preference: "$s1 $s2 $s3",
      ProposalFields.members: "${name.length}",
      ProposalFields.name: studentName.trim(),
      ProposalFields.studentID: studentID.trim(),
      ProposalFields.email: studentEmail.trim(),
      ProposalFields.phone: studentPhone.trim(),
      ProposalFields.cgpa: studentCGPA.trim(),
    };
    final type = cse3300 ? "CSE-3300" : 'CSE-4800';
    // print(data);
    int proposalID = await ProjectSheetApi.addProposal(data, type);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Proposal"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: Get.height * .88,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Row(
                  children: [
                    const Text(
                      "Course Code: ",
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    OutlinedButton(
                      onPressed: () async {
                        titles1.clear();
                        titles2.clear();
                        titles1 = await ProjectSheetApi.getColumn('CSE-3300', 'Title');
                        titles2 = await ProjectSheetApi.getColumn(
                          'CSE-3300-team-request',
                          'Title',
                        );
                        setState(() {
                          cse3300 = true;
                          cse4800 = false;
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor:
                            cse3300 ? Colors.greenAccent.shade100 : Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      child: const Text(
                        "CSE - 3300",
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    OutlinedButton(
                        onPressed: () async {
                          titles1.clear();
                          titles2.clear();
                          titles1 = await ProjectSheetApi.getColumn('CSE-4800', 'Title');
                          titles2 = await ProjectSheetApi.getColumn(
                            'CSE-4800-team-request',
                            'Title',
                          );
                          setState(() {
                            cse3300 = false;
                            cse4800 = true;
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor:
                              cse4800 ? Colors.greenAccent.shade100 : Colors.transparent,
                          shadowColor: Colors.transparent,
                        ),
                        child: const Text(
                          "CSE - 4800",
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        )),
                  ],
                ),
                TextFormField(
                  controller: title,
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return "Enter title";
                    } else if (titles1.contains(value.trim()) || titles2.contains(value.trim())) {
                      return "This title is already taken.";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    label: Text('Project Title'),
                    labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    filled: true,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  controller: link,
                  validator: (value) {
                    // if (linkValidator.hasMatch(value!.trim()) == false) {
                    //   return "Invalid google drive link";
                    // } else
                    if (value!.trim().isEmpty) {
                      return "Please provide google drive link";
                    }

                    return null;
                  },
                  decoration: const InputDecoration(
                    label: Text('Upload Google Drive Link of Proposal'),
                    labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    filled: true,
                    helperText: "Make sure file is shared with anyone with link.",
                    helperStyle: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                    border: OutlineInputBorder(),
                  ),
                ),
                const Divider(color: Colors.green, thickness: 2),
                if (isPreference)
                  const Text(
                    "Select any three preferred supervisor.",
                    style:
                        TextStyle(color: Colors.teal, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                if (isPreference)
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 40.h,
                          child: DropdownButtonFormField(
                            items: [
                              for (String initial in initials)
                                DropdownMenuItem(
                                  value: initial,
                                  child: Text(initial),
                                )
                            ],
                            onChanged: (value) {
                              s1 = value!;
                            },
                            validator: (value) {
                              if (value == s2 || value == s3) {
                                return 'Choose Different';
                              }
                              return null;
                            },
                            // decoration: const InputDecoration(
                            //
                            //   border: OutlineInputBorder(),
                            // ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: SizedBox(
                          height: 40.h,
                          child: DropdownButtonFormField(
                            items: [
                              for (String initial in initials)
                                DropdownMenuItem(
                                  value: initial,
                                  child: Text(initial),
                                )
                            ],
                            onChanged: (value) {
                              s2 = value!;
                            },
                            validator: (value) {
                              if (value == s1 || value == s3) {
                                return 'Choose Different';
                              }
                              return null;
                            },
                            // decoration: const InputDecoration(
                            //   border: OutlineInputBorder(),
                            // ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: SizedBox(
                          height: 40.h,
                          child: DropdownButtonFormField(
                            items: [
                              for (String initial in initials)
                                DropdownMenuItem(
                                  value: initial,
                                  child: Text(initial),
                                )
                            ],
                            onChanged: (value) {
                              s3 = value!;
                            },
                            validator: (value) {
                              if (value == s2 || value == s1) {
                                return 'Choose Different';
                              }
                              return null;
                            },
                            // decoration: const InputDecoration(
                            //   border: OutlineInputBorder(),
                            // ),
                          ),
                        ),
                      ),
                    ],
                  ),
                const Divider(color: Colors.green, thickness: 2),
                Expanded(
                  child: SizedBox(
                    height: 300.h,
                    child: ListView.builder(
                      itemCount: name.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Text(
                              "Provide Member - ${index + 1} Details ",
                              style: TextStyle(
                                  fontSize: 14.h, fontWeight: FontWeight.bold, color: Colors.teal),
                            ),
                            const SizedBox(height: 5),
                            TextFormField(
                              controller: name[index],
                              validator: (value) {
                                if (nameValidator.hasMatch(value!.trim()) == false) {
                                  return "Invalid name format";
                                } else if (value.trim().isEmpty) {
                                  return "Please provide name";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                label: const Text('Name'),
                                labelStyle: TextStyle(fontSize: 14.h, fontWeight: FontWeight.bold),
                                filled: true,
                                border: const OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: TextFormField(
                                    controller: id[index],
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (idValidator.hasMatch(value!.trim()) == false) {
                                        return "Invalid student id provided";
                                      } else if (value.trim().isEmpty) {
                                        return "Please provide student id";
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      label: const Text('Student ID'),
                                      labelStyle:
                                          TextStyle(fontSize: 14.h, fontWeight: FontWeight.bold),
                                      filled: true,
                                      border: const OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  flex: 1,
                                  child: TextFormField(
                                    controller: cgpa[index],
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (cgpaValidator.hasMatch(value!) == false) {
                                        return "Invalid format. Try format like 3.00 or 3.78";
                                      } else if (value.isEmpty) {
                                        return "Provide CGPA";
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      label: const Text('CGPA'),
                                      labelStyle:
                                          TextStyle(fontSize: 14.h, fontWeight: FontWeight.bold),
                                      filled: true,
                                      border: const OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            TextFormField(
                              controller: email[index],
                              validator: (value) {
                                if (emailValidator.hasMatch(value!.trim()) == false) {
                                  return "Please provide academic (g-suit) email.";
                                } else if (value.trim().isEmpty) {
                                  return "Please provide academic (g-suit) email";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                label: const Text('Email'),
                                labelStyle: TextStyle(fontSize: 14.h, fontWeight: FontWeight.bold),
                                filled: true,
                                border: const OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 5),
                            TextFormField(
                              controller: number[index],
                              validator: (value) {
                                if (cellValidator.hasMatch(value!) == false) {
                                  return "Invalid phone number provided";
                                } else if (value.isEmpty) {
                                  return "Please provide phone number";
                                }
                                return null;
                              },
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                label: const Text('Mobile Number'),
                                labelStyle: TextStyle(fontSize: 14.h, fontWeight: FontWeight.bold),
                                filled: true,
                                border: const OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 5),
                            if (index == name.length - 1)
                              ElevatedButton.icon(
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                                    if (courseCode.substring(0,8) == "CSE-3300" && cse3300) {
                                      Get.showSnackbar(
                                        GetSnackBar(
                                          message: "You have already submitted proposal for "
                                              "$courseCode",
                                          duration: const Duration(seconds: 3),
                                          backgroundColor: Colors.redAccent,
                                        ),
                                      );
                                    } else if (courseCode.substring(0,8) == 'CSE-4800' && cse4800) {
                                      Get.showSnackbar(
                                        GetSnackBar(
                                          message: "You have already submitted proposal for "
                                              "$courseCode",
                                          duration: const Duration(seconds: 3),
                                          backgroundColor: Colors.redAccent,
                                        ),
                                      );
                                    } else {
                                      await addToSheet();
                                      Get.showSnackbar(
                                        const GetSnackBar(
                                          message: "Your proposal have submitted successfully ",
                                          duration: Duration(seconds: 3),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                      Get.off(const StudentScreen());
                                    }
                                  }
                                },
                                style: buttonStyle(300, 40),
                                icon: const Icon(Icons.send_sharp),
                                label: const Text("Submit"),
                              )
                          ],
                        );
                      },
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                        onPressed: () {
                          if (name.length < 4) {
                            name.add(TextEditingController());
                            id.add(TextEditingController());
                            cgpa.add(TextEditingController());
                            email.add(TextEditingController());
                            number.add(TextEditingController());
                            setState(() {});
                          } else {
                            Get.showSnackbar(
                              const GetSnackBar(
                                message: "One team can contain maximum 4 members",
                                duration: Duration(seconds: 3),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          }
                        },
                        child: const Text("Add Member")),
                    TextButton(
                        onPressed: () {
                          if (name.length > 2) {
                            name.removeLast();
                            id.removeLast();
                            cgpa.removeLast();
                            email.removeLast();
                            number.removeLast();
                            setState(() {});
                          } else {
                            Get.showSnackbar(
                              const GetSnackBar(
                                message: "Minimum 2 members required to submit proposal",
                                duration: Duration(seconds: 3),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          }
                        },
                        child: const Text("Remove Member")),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
