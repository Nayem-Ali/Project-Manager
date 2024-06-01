import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:teamlead/View/teacher/project_evaluation.dart';
import 'package:teamlead/Widget/buttonStyle.dart';
import 'package:teamlead/services/db_service.dart';

class EvaluatePage extends StatefulWidget {
  const EvaluatePage({Key? key}) : super(key: key);

  @override
  State<EvaluatePage> createState() => _EvaluatePageState();
}

class _EvaluatePageState extends State<EvaluatePage> {
  DataBaseMethods dataBaseMethods = DataBaseMethods();
  dynamic teacherInfo = {};
  dynamic teamInfo = Get.arguments[0];
  int totalMembers = 0;
  List<String> name = [];
  List<String> id = [];
  List<String> email = [];
  List<String> cgpa = [];
  List<String> phone = [];

  List<TextEditingController> criteria1 = [];
  List<TextEditingController> criteria2 = [];

  bool enabled1 = true;
  bool enabled2 = true;
  final formKey = GlobalKey<FormState>();

  List<bool> absent = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  List<Map<String, dynamic>> studentEvaluationData = [];

  getData() async {
    // print(teamInfo);

    totalMembers = int.tryParse(teamInfo['Team Members']) ?? 0;
    name = teamInfo['Name'].split('\n');
    id = teamInfo['Student ID'].split('\n');
    email = teamInfo['Email'].split('\n');
    cgpa = teamInfo['CGPA'].split('\n');
    phone = teamInfo['Phone'].split('\n');

    for (int i = 0; i < totalMembers; i++) {
      criteria1.add(TextEditingController());
      criteria2.add(TextEditingController());
      absent.add(false);
      if (Get.arguments.length == 3) {
        criteria1[i].text = Get.arguments[2]['data'][i + 1]['criteria1'].toString();
        criteria2[i].text = Get.arguments[2]['data'][i + 1]['criteria2'].toString();
      }
    }
    teacherInfo = await dataBaseMethods.getTeacher();

    setState(() {});
  }

  addEvaluationData() {
    studentEvaluationData.clear();
    Map<String, dynamic> info = {
      "proposalID": teamInfo['ID'],
      "projectType": Get.arguments[1],
      "title": teamInfo['Title'],
      "evaluatedBy": teacherInfo['initial'],
    };
    studentEvaluationData.add(info);
    for (int i = 0; i < totalMembers; i++) {
      studentEvaluationData.add({
        'criteria1': double.tryParse(criteria1[i].text.trim().toString()) ?? 0,
        'criteria2': double.tryParse(criteria2[i].text.trim().toString()) ?? 0,
      });
    }
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
        appBar: AppBar(
          title: Text(teamInfo["Title"]),
        ),
        body: Form(
          key: formKey,
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: totalMembers,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Card(
                          color:
                              index % 2 == 1 ? Colors.blue.shade100 : Colors.greenAccent.shade100,
                          child: ListTile(
                            trailing: Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Text(
                                    "Mark as Absent",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 15.0),
                                  child: Switch(
                                    value: absent[index],
                                    activeColor: Colors.teal,
                                    onChanged: (bool value) {
                                      setState(() {
                                        absent[index] = value;
                                        if (value == true) {
                                          criteria1[index].clear();
                                          criteria2[index].clear();
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Text(id[index].trim()),
                            title: Text(name[index].trim()),
                            subtitleTextStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize:  14.sp,
                              color: Colors.black,
                            ),
                            titleTextStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: criteria1[index],
                            validator: (value) {
                              double total = double.tryParse(value!) ?? 0;
                              if (value.trim().isEmpty && absent[index] == false) {
                                return "Cannot left empty";
                              }
                              if (total > 30) {
                                return "30 marks limit exceeded";
                              }
                              return null;
                            },
                            readOnly: absent[index],
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                label: Text("Criteria - I"),
                                helperText: "Problem Definition, Design Complexity, Viva"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: criteria2[index],
                            validator: (value) {
                              double total = double.tryParse(value!) ?? 0;
                              if (value.trim().isEmpty && absent[index] == false) {
                                return "Cannot left empty";
                              }
                              if (total > 30) {
                                return "30 marks limit exceeded";
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number,
                            readOnly: absent[index],
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                label: Text("Criteria - 2"),
                                helperText: "Presentation, Testing, Report"),
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
              ElevatedButton(
                style: buttonStyle(300, 40),
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    addEvaluationData();
                    // print(studentEvaluationData);
                    String status = await dataBaseMethods.submitEvaluation(studentEvaluationData);

                    if (status == 'success') {
                      await dataBaseMethods.addTeamToTeacherMarked(
                        teamInfo['Title'],
                        Get.arguments[1],
                        teacherInfo['initial'],
                        int.parse(teamInfo['ID']),
                      );
                      Get.showSnackbar(
                        GetSnackBar(
                          backgroundColor: Colors.teal.shade800,
                          message: Get.arguments.length == 3
                              ? "Mark is updated Successfully"
                              : "Mark is added successfully",
                          duration: const Duration(seconds: 3),
                        ),
                      );
                    } else {
                      Get.showSnackbar(
                        GetSnackBar(
                          backgroundColor: Colors.red.shade800,
                          message: "Something went wrong try again later!",
                          duration: const Duration(seconds: 3),
                        ),
                      );
                    }
                    Get.off(const ProjectEvaluation(), arguments: Get.arguments[1]);
                  }
                },
                child: Text(
                  Get.arguments.length == 3 ? "Update" : "Evaluate",
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
