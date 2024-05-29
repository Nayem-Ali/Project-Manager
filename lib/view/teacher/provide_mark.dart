import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teamlead/View/teacher/project_evaluation.dart';
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

  TextEditingController student1Criteria1 = TextEditingController();
  TextEditingController student1Criteria2 = TextEditingController();
  TextEditingController student2Criteria1 = TextEditingController();
  TextEditingController student2Criteria2 = TextEditingController();
  TextEditingController student3Criteria1 = TextEditingController();
  TextEditingController student3Criteria2 = TextEditingController();
  TextEditingController student4Criteria1 = TextEditingController();
  TextEditingController student4Criteria2 = TextEditingController();

  TextEditingController problemDefinition1 = TextEditingController();
  TextEditingController problemDefinition2 = TextEditingController();
  TextEditingController problemDefinition3 = TextEditingController();
  TextEditingController problemDefinition4 = TextEditingController();

  TextEditingController designComplexity1 = TextEditingController();
  TextEditingController designComplexity2 = TextEditingController();
  TextEditingController designComplexity3 = TextEditingController();
  TextEditingController designComplexity4 = TextEditingController();

  TextEditingController viva1 = TextEditingController();
  TextEditingController viva2 = TextEditingController();
  TextEditingController viva3 = TextEditingController();
  TextEditingController viva4 = TextEditingController();

  TextEditingController presentation1 = TextEditingController();
  TextEditingController presentation2 = TextEditingController();
  TextEditingController presentation3 = TextEditingController();
  TextEditingController presentation4 = TextEditingController();

  TextEditingController testing1 = TextEditingController();
  TextEditingController testing2 = TextEditingController();
  TextEditingController testing3 = TextEditingController();
  TextEditingController testing4 = TextEditingController();

  TextEditingController report1 = TextEditingController();
  TextEditingController report2 = TextEditingController();
  TextEditingController report3 = TextEditingController();
  TextEditingController report4 = TextEditingController();

  bool enabled1 = true;
  bool enabled2 = true;
  final formKey = GlobalKey<FormState>();

  List<bool> absent = [false, false, false,false];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  List<Map<String, dynamic>> studentEvaluationData = [
    {
      "proposalID": "",
      "projectType": "",
      "title": "",
      "evaluatedBy": "",
    },
    {
      "criteria1": "",
      "problemDefinition": "",
      "designComplexity": "",
      "viva": "",
      "criteria2": "",
      "presentation": "",
      "testing": "",
      "report": "",
    },
    {
      "criteria1": "",
      "problemDefinition": "",
      "designComplexity": "",
      "viva": "",
      "criteria2": "",
      "presentation": "",
      "testing": "",
      "report": "",
    },
    {
      "criteria1": "",
      "problemDefinition": "",
      "designComplexity": "",
      "viva": "",
      "criteria2": "",
      "presentation": "",
      "testing": "",
      "report": "",
    },
    {
      "criteria1": "",
      "problemDefinition": "",
      "designComplexity": "",
      "viva": "",
      "criteria2": "",
      "presentation": "",
      "testing": "",
      "report": "",
    },
  ];

  getData() async {
    // print(teamInfo);

    totalMembers = int.tryParse(teamInfo['Team Members']) ?? 0;
    name = teamInfo['Name'].split('\n');
    id = teamInfo['Student ID'].split('\n');
    email = teamInfo['Email'].split('\n');
    cgpa = teamInfo['CGPA'].split('\n');
    phone = teamInfo['Phone'].split('\n');
    teacherInfo = await dataBaseMethods.getTeacher();
    studentEvaluationData[0]["evaluatedBy"] = teacherInfo['initial'];
    studentEvaluationData[0]["title"] = teamInfo['Title'];
    studentEvaluationData[0]["projectType"] = Get.arguments[1];
    studentEvaluationData[0]["proposalID"] = teamInfo['ID'];
    setState(() {});
  }

  updateCriteria1(int index) {
    if (index == 0) {
      double designComplexity = double.tryParse(designComplexity1.text) ?? 0;
      double problemDefinition = double.tryParse(problemDefinition1.text) ?? 0;
      double viva = double.tryParse(viva1.text) ?? 0;
      double total = designComplexity + viva + problemDefinition;
      student1Criteria1.text = total.toString();
      studentEvaluationData[index + 1]["criteria1"] = student1Criteria1.text;
      studentEvaluationData[index + 1]["problemDefinition"] = problemDefinition1.text;
      studentEvaluationData[index + 1]["designComplexity"] = designComplexity1.text;
      studentEvaluationData[index + 1]["viva"] = viva1.text;
    } else if (index == 1) {
      double designComplexity = double.tryParse(designComplexity2.text) ?? 0;
      double problemDefinition = double.tryParse(problemDefinition2.text) ?? 0;
      double viva = double.tryParse(viva2.text) ?? 0;
      double total = designComplexity + viva + problemDefinition;
      student2Criteria1.text = total.toString();
      studentEvaluationData[index + 1]["criteria1"] = student2Criteria1.text;
      studentEvaluationData[index + 1]["problemDefinition"] = problemDefinition2.text;
      studentEvaluationData[index + 1]["designComplexity"] = designComplexity2.text;
      studentEvaluationData[index + 1]["viva"] = viva2.text;
    } else if (index == 2) {
      double designComplexity = double.tryParse(designComplexity3.text) ?? 0;
      double problemDefinition = double.tryParse(problemDefinition3.text) ?? 0;
      double viva = double.tryParse(viva3.text) ?? 0;
      double total = designComplexity + viva + problemDefinition;
      student3Criteria1.text = total.toString();
      studentEvaluationData[index + 1]["criteria1"] = student3Criteria1.text;
      studentEvaluationData[index + 1]["problemDefinition"] = problemDefinition3.text;
      studentEvaluationData[index + 1]["designComplexity"] = designComplexity3.text;
      studentEvaluationData[index + 1]["viva"] = viva3.text;
    } else if (index == 3) {
      double designComplexity = double.tryParse(designComplexity4.text) ?? 0;
      double problemDefinition = double.tryParse(problemDefinition4.text) ?? 0;
      double viva = double.tryParse(viva4.text) ?? 0;
      double total = designComplexity + viva + problemDefinition;
      student4Criteria1.text = total.toString();
      studentEvaluationData[index + 1]["criteria1"] = student4Criteria1.text as double;
      studentEvaluationData[index + 1]["problemDefinition"] = problemDefinition4.text;
      studentEvaluationData[index + 1]["designComplexity"] = designComplexity4.text;
      studentEvaluationData[index + 1]["viva"] = viva4.text;
    }
  }

  updateCriteria2(int index) {
    if (index == 0) {
      double presentation = double.tryParse(presentation1.text) ?? 0;
      double testing = double.tryParse(testing1.text) ?? 0;
      double report = double.tryParse(report1.text) ?? 0;
      double total = presentation + testing + report;
      student1Criteria2.text = total.toString();
      studentEvaluationData[index + 1]["criteria2"] = student1Criteria2.text;
      studentEvaluationData[index + 1]["presentation"] = presentation1.text;
      studentEvaluationData[index + 1]["testing"] = testing1.text;
      studentEvaluationData[index + 1]["report"] = report1.text;
    } else if (index == 1) {
      double presentation = double.tryParse(presentation2.text) ?? 0;
      double testing = double.tryParse(testing2.text) ?? 0;
      double report = double.tryParse(report2.text) ?? 0;
      double total = presentation + testing + report;
      student2Criteria2.text = total.toString();
      studentEvaluationData[index + 1]["criteria2"] = student2Criteria2.text;
      studentEvaluationData[index + 1]["presentation"] = presentation2.text;
      studentEvaluationData[index + 1]["testing"] = testing2.text;
      studentEvaluationData[index + 1]["report"] = report2.text;
    } else if (index == 2) {
      double presentation = double.tryParse(presentation3.text) ?? 0;
      double testing = double.tryParse(testing3.text) ?? 0;
      double report = double.tryParse(report3.text) ?? 0;
      double total = presentation + testing + report;
      student3Criteria2.text = total.toString();
      studentEvaluationData[index + 1]["criteria2"] = student3Criteria2.text;
      studentEvaluationData[index + 1]["presentation"] = presentation3.text;
      studentEvaluationData[index + 1]["testing"] = testing3.text;
      studentEvaluationData[index + 1]["report"] = report3.text;
    } else if (index == 3) {
      double presentation = double.tryParse(presentation4.text) ?? 0;
      double testing = double.tryParse(testing4.text) ?? 0;
      double report = double.tryParse(report4.text) ?? 0;
      double total = presentation + testing + report;
      student4Criteria2.text = total.toString();
      studentEvaluationData[index + 1]["criteria2"] = student4Criteria2.text;
      studentEvaluationData[index + 1]["presentation"] = presentation4.text;
      studentEvaluationData[index + 1]["testing"] = testing4.text;
      studentEvaluationData[index + 1]["report"] = report4.text;
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
                          color: index % 2 == 1 ? Colors.blue.shade100 : Colors.greenAccent.shade100,
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
                                      fontSize: Get.textScaleFactor * 14,
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
                                          student1Criteria1.clear();
                                          student1Criteria2.clear();
                                          student2Criteria1.clear();
                                          student2Criteria2.clear();
                                          student3Criteria1.clear();
                                          student3Criteria2.clear();
                                          student4Criteria1.clear();
                                          student4Criteria2.clear();

                                          viva1.clear();
                                          viva2.clear();
                                          viva3.clear();
                                          viva4.clear();

                                          problemDefinition1.clear();
                                          problemDefinition2.clear();
                                          problemDefinition3.clear();
                                          problemDefinition4.clear();

                                          designComplexity1.clear();
                                          designComplexity2.clear();
                                          designComplexity3.clear();
                                          designComplexity4.clear();

                                          presentation1.clear();
                                          presentation2.clear();
                                          presentation3.clear();
                                          presentation4.clear();

                                          testing1.clear();
                                          testing2.clear();
                                          testing3.clear();
                                          testing4.clear();

                                          report1.clear();
                                          report2.clear();
                                          report3.clear();
                                          report4.clear();

                                          updateCriteria1(index);
                                          updateCriteria2(index);
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Text(id[index]),
                            title: Text(name[index]),
                            subtitleTextStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: Get.textScaleFactor * 16,
                              color: Colors.black,
                            ),
                            titleTextStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        if (absent[index] == false)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: (index == 0)
                                      ? student1Criteria1
                                      : (index == 1)
                                      ? student2Criteria1
                                      : (index == 2)
                                      ? student3Criteria1
                                      : student4Criteria1,
                                  onChanged: (value) {
                                    if (value != "") {
                                      (index == 0)
                                          ? studentEvaluationData[index + 1]["criteria1"] =
                                          student1Criteria1.text
                                          : (index == 1)
                                          ? studentEvaluationData[index + 1]["criteria1"] =
                                          student2Criteria1.text
                                          : (index == 2)
                                          ? studentEvaluationData[index + 1]["criteria1"] =
                                          student3Criteria1.text
                                          : studentEvaluationData[index + 1]["criteria1"] =
                                          student4Criteria1.text;

                                      setState(() {
                                        enabled1 = false;
                                      });
                                    } else if (value == "") {
                                      setState(() {
                                        enabled1 = true;
                                      });
                                    }
                                  },
                                  validator: (value){

                                    double total = double.tryParse(value!) ?? 0;
                                    if(value.trim().isEmpty){
                                      return "Cannot left empty";
                                    }
                                    if(total >30){
                                      return "30 marks limit exceeded";
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    label: Text("Criteria - I"),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: (index == 0)
                                            ? problemDefinition1
                                            : (index == 1)
                                            ? problemDefinition2
                                            : (index == 2)
                                            ? problemDefinition3
                                            : problemDefinition4,
                                        onChanged: (value) {
                                          updateCriteria1(index);
                                        },

                                        enabled: enabled1,
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          label: Text("Problem Definition"),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: TextFormField(
                                        controller: (index == 0)
                                            ? designComplexity1
                                            : (index == 1)
                                            ? designComplexity2
                                            : (index == 2)
                                            ? designComplexity3
                                            : designComplexity4,
                                        onChanged: (value) {
                                          updateCriteria1(index);
                                        },
                                        enabled: enabled1,
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          label: Text("Design Complexity"),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: TextFormField(
                                        controller: (index == 0)
                                            ? viva1
                                            : (index == 1)
                                            ? viva2
                                            : (index == 2)
                                            ? viva3
                                            : viva4,
                                        onChanged: (value) {
                                          updateCriteria1(index);
                                        },
                                        enabled: enabled1,
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          label: Text("Viva"),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  controller: (index == 0)
                                      ? student1Criteria2
                                      : (index == 1)
                                      ? student2Criteria2
                                      : (index == 2)
                                      ? student3Criteria2
                                      : student4Criteria2,
                                  onChanged: (value) {
                                    if (value != "") {
                                      (index == 0)
                                          ? studentEvaluationData[index + 1]["criteria2"] =
                                          student1Criteria2.text
                                          : (index == 1)
                                          ? studentEvaluationData[index + 1]["criteria2"] =
                                          student2Criteria2.text
                                          : (index == 2)
                                          ? studentEvaluationData[index + 1]["criteria2"] =
                                          student3Criteria2.text
                                          : studentEvaluationData[index + 1]["criteria2"] =
                                          student4Criteria2.text;
                                      setState(() {
                                        enabled2 = false;
                                      });
                                    } else if (value == "") {
                                      setState(() {
                                        enabled2 = true;
                                      });
                                    }
                                  },
                                  validator: (value){
                                    double total = double.tryParse(value!) ?? 0;
                                    if(value.trim().isEmpty){
                                      return "Cannot left empty";
                                    }
                                    if(total >30){
                                      return "30 marks limit exceeded";
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    label: Text("Criteria - II"),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: (index == 0)
                                            ? presentation1
                                            : (index == 1)
                                            ? presentation2
                                            : (index == 2)
                                            ? presentation3
                                            : presentation4,
                                        onChanged: (value) {
                                          updateCriteria2(index);
                                        },
                                        enabled: enabled2,
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          label: Text("Presentation"),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: TextFormField(
                                        controller: (index == 0)
                                            ? testing1
                                            : (index == 1)
                                            ? testing2
                                            : (index == 2)
                                            ? testing3
                                            : testing4,
                                        enabled: enabled2,
                                        onChanged: (value) {
                                          updateCriteria2(index);
                                        },
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          label: Text("Testing & Evaluation"),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: TextFormField(
                                        controller: (index == 0)
                                            ? report1
                                            : (index == 1)
                                            ? report2
                                            : (index == 2)
                                            ? report3
                                            : report4,
                                        onChanged: (value) {
                                          updateCriteria2(index);
                                        },
                                        enabled: enabled2,
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          label: Text("Report Writing"),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 50),
                ),
                onPressed: () async {
                  if(formKey.currentState!.validate()){
                    print(studentEvaluationData);
                    await dataBaseMethods.submitEvaluation(studentEvaluationData);
                    Get.off(const ProjectEvaluation());
                  }

                },
                child: const Text("Evaluate"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
