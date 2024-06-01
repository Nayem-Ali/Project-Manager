import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:teamlead/View/student/student_home.dart';
import 'package:teamlead/Widget/buttonStyle.dart';

import '../../model/proposal_model.dart';
import '../../services/db_service.dart';
import '../../services/proposal_sheets_api.dart';
// import '../../services/google_sheets_api.dart';

class RequestTeam extends StatefulWidget {
  const RequestTeam({Key? key}) : super(key: key);

  @override
  State<RequestTeam> createState() => _RequestTeamState();
}

class _RequestTeamState extends State<RequestTeam> {
  DataBaseMethods dataBaseMethods = DataBaseMethods();
  bool cse3300 = true;
  bool cse4800 = false;
  bool isProject = true;
  bool isThesis = false;
  bool isMember1 = true;
  bool isMember2 = false;
  bool isPreference = Get.arguments;

  final formKey = GlobalKey<FormState>();

  RegExp cgpaValidator = RegExp(r"^(\d){1}\.(\d){2}$");
  RegExp nameValidator = RegExp(
      r"(^[A-Za-z\.]{2,16})([ ]{0,1})([A-Za-z]{2,16})?([ ]{0,1})?([A-Za-z]{2,16})?([ ]{0,1})?([A-Za-z]{2,16})$");
  RegExp idValidator = RegExp(r"[\d]{10,15}");
  RegExp emailValidator = RegExp(r"^[A-Za-z0-9_]{14,25}@lus\.ac\.bd$");
  RegExp cellValidator = RegExp(r"(^(\+88|0088)?(01){1}[3456789]{1}(\d){8})$");
  RegExp linkValidator = RegExp(
      r'^https:\/\/drive\.google\.com\/(?:file\/d\/|open\?id=|drive\/folders\/)([a-zA-Z0-9_-]+)(?:\/view)?(?:\?[^&]+)?$');

  TextEditingController name1 = TextEditingController();
  TextEditingController id1 = TextEditingController();
  TextEditingController cgpa1 = TextEditingController();
  TextEditingController email1 = TextEditingController();
  TextEditingController number1 = TextEditingController();

  TextEditingController name2 = TextEditingController();
  TextEditingController id2 = TextEditingController();
  TextEditingController cgpa2 = TextEditingController();
  TextEditingController email2 = TextEditingController();
  TextEditingController number2 = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController link = TextEditingController();

  String s1 = "";
  String s2 = "";
  String s3 = "";

  dynamic initials = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    initials = await dataBaseMethods.getAllSupervisorInitial();
    setState(() {});
  }

  addRequest() async {
    DataBaseMethods dataBaseMethods = DataBaseMethods();
    Map<String, String> teamInfo = {};

    if (cse3300) {
      teamInfo["projectType"] = "CSE-3300";
    } else {
      teamInfo["projectType"] = "CSE-4800";
    }
    teamInfo["title"] = title.text.trim();
    teamInfo["link"] = link.text.trim();
    teamInfo["preference"] = "$s1 $s2 $s3";

    teamInfo["name1"] = name1.text.trim();
    teamInfo["id1"] = id1.text.trim();
    teamInfo["email1"] = email1.text.trim();
    teamInfo["number1"] = number1.text.trim();
    teamInfo["cgpa1"] = cgpa1.text.trim();
    teamInfo["isAssigned"] = "";
    teamInfo["mergeWith"] = "";
    teamInfo["submitted"] = "yes";

    if (name2.text.isNotEmpty) {
      teamInfo["name2"] = name2.text.trim();
      teamInfo["id2"] = id2.text.trim();
      teamInfo["email2"] = email2.text.trim();
      teamInfo["number2"] = number2.text.trim();
      teamInfo["cgpa2"] = cgpa2.text.trim();
    }
    await dataBaseMethods.addTeamRequest(teamInfo);
  }

  addToSheet() async {
    int members = 1;
    if (id2.text.isNotEmpty) members = 2;
    final data = {
      ProposalFields.id: "",
      ProposalFields.title: title.text.trim(),
      ProposalFields.link: link.text.trim(),
      ProposalFields.supervisor: "",
      ProposalFields.preference: "$s1 $s2 $s3",
      ProposalFields.members: "$members",
      ProposalFields.name: "${name1.text.trim()}\n${name2.text.trim()}",
      ProposalFields.studentID: "${id1.text.trim()}\n${id2.text.trim()}",
      ProposalFields.email: "${email1.text.trim()}\n${email2.text.trim()}",
      ProposalFields.phone: "${number1.text.trim()}\n${number2.text.trim()}",
      ProposalFields.cgpa: "${cgpa1.text.trim()}\n${cgpa2.text.trim()}",
    };
    final type = cse3300 ? "CSE-3300-request" : 'CSE-4800-request';
    ProjectSheetApi.addTeamRequest(data, type);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
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
                        onPressed: () {
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
                          onPressed: () {
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
                  if (cse4800)
                    Row(
                      children: [
                        const Text(
                          "What will you do: ",
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const Spacer(),
                        OutlinedButton(
                          onPressed: () {
                            setState(() {
                              isProject = true;
                              isThesis = false;
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor:
                                isProject ? Colors.greenAccent.shade100 : Colors.transparent,
                            shadowColor: Colors.transparent,
                          ),
                          child: const Text(
                            "Project",
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
                              isProject = false;
                              isThesis = true;
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor:
                                isThesis ? Colors.greenAccent.shade100 : Colors.transparent,
                            shadowColor: Colors.transparent,
                          ),
                          child: const Text(
                            "Thesis",
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const Spacer()
                      ],
                    ),
                  TextFormField(
                    controller: title,
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return "This field is required";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      label: Text('Project/Thesis Title'),
                      labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      filled: true,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: link,
                    validator: (value) {
                      if (linkValidator.hasMatch(value!.trim()) == false) {
                        return "Invalid google drive link";
                      } else if (value.trim().isEmpty) {
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
                  if (isPreference) const SizedBox(height: 5),
                  if (isPreference)
                    Row(
                      children: [
                        Expanded(
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
                                return 'Chose Different';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
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
                                return 'Chose Different';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
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
                                return 'Chose Different';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  const Divider(color: Colors.green, thickness: 2),
                  Column(
                    children: [
                      const Text(
                        "Provide Member - 1 Details",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: name1,
                        validator: (value) {
                          if (nameValidator.hasMatch(value!.trim()) == false) {
                            return "Invalid name format";
                          } else if (value.trim().isEmpty) {
                            return "Please provide name";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          label: Text('Name'),
                          labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          filled: true,
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: id1,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (idValidator.hasMatch(value!.trim()) == false) {
                                  return "Invalid student id provided";
                                } else if (value.trim().isEmpty) {
                                  return "Please provide student id";
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
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 1,
                            child: TextFormField(
                              controller: cgpa1,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (cgpaValidator.hasMatch(value!.trim()) == false) {
                                  return "Invalid format. Try format like 3.00 or 3.78";
                                } else if (value.trim().isEmpty) {
                                  return "Provide CGPA";
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                label: Text('CGPA'),
                                labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                filled: true,
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: email1,
                        validator: (value) {
                          if (emailValidator.hasMatch(value!.trim()) == false) {
                            return "Please provide academic (g-suit) email.";
                          } else if (value.trim().isEmpty) {
                            return "Please provide academic (g-suit) email";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          label: Text('Email'),
                          labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          filled: true,
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: number1,
                        validator: (value) {
                          if (cellValidator.hasMatch(value!.trim()) == false) {
                            return "Invalid phone number provided";
                          } else if (value.trim().isEmpty) {
                            return "Please provide phone number";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          label: Text('Mobile Number'),
                          labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          filled: true,
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  SwitchListTile(
                    value: isMember2,
                    tileColor: Colors.teal.shade100,
                    title: const Text("Add 2nd Member"),
                    onChanged: (value) {
                      setState(() {
                        isMember2 = value;
                      });
                    },
                  ),
                  const SizedBox(height: 5),
                  if(isMember2)
                  Column(
                    children: [
                      const Text(
                        "Provide Member - 2 Details ",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: name2,
                        validator: (value) {
                          if (nameValidator.hasMatch(value!.trim()) == false &&
                              value.trim().isNotEmpty) {
                            return "Invalid name format";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          label: Text('Name'),
                          labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          filled: true,
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: id2,
                              validator: (value) {
                                if (idValidator.hasMatch(value!.trim()) == false &&
                                    value.trim().isNotEmpty) {
                                  return "Invalid student id provided";
                                }
                                return null;
                              },
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                label: Text('Student ID'),
                                labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                filled: true,
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 1,
                            child: TextFormField(
                              controller: cgpa2,
                              validator: (value) {
                                if (cgpaValidator.hasMatch(value!.trim()) == false &&
                                    value.trim().isNotEmpty) {
                                  return "Invalid format. Try format like 3.00 or 3.78";
                                }
                                return null;
                              },
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                label: Text('CGPA'),
                                labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                filled: true,
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: email2,
                        validator: (value) {
                          if (emailValidator.hasMatch(value!.trim()) == false &&
                              value.trim().isNotEmpty) {
                            return "Please provide academic (g-suit) email.";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          label: Text('Email'),
                          labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          filled: true,
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: number2,
                        validator: (value) {
                          if (cellValidator.hasMatch(value!.trim()) == false &&
                              value.trim().isNotEmpty) {
                            return "Please provide valid phone number.";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          label: Text('Mobile Number'),
                          labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          filled: true,
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        await addRequest();
                        await addToSheet();
                        Get.off(const StudentScreen());
                      }
                    },
                    style: buttonStyle(300, 40),
                    icon: const Icon(Icons.send_sharp),
                    label: Text(
                      "Submit",
                      style: TextStyle(
                        fontSize: Get.textScaleFactor * 18,
                        fontWeight: FontWeight.bold,
                      ),
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
