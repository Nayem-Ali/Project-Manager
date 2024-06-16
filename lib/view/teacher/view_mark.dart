import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:teamlead/services/db_service.dart';

class ViewMark extends StatefulWidget {
  const ViewMark({Key? key}) : super(key: key);

  @override
  State<ViewMark> createState() => _ViewMarkState();
}

class _ViewMarkState extends State<ViewMark> {
  DataBaseMethods dataBaseMethods = DataBaseMethods();
  dynamic teamInfo = Get.arguments[0];
  int totalMembers = 0;
  List<TextEditingController> technical = [];
  List<TextEditingController> teamWork = [];
  List<TextEditingController> total = [];
  List<String> name = [];
  List<String> id = [];
  List<bool> isAbsent = [];
  List<Map<String, dynamic>> marks = [];
  List<dynamic> evaluationMarks = [];

  final formKey = GlobalKey<FormState>();

  extractData() {
    totalMembers = int.tryParse(teamInfo['Team Members']) ?? 0;
    name = teamInfo['Name'].split('\n');
    id = teamInfo['Student ID'].split('\n');
    for (int i = 0; i < totalMembers; i++) {
      teamWork.add(TextEditingController());
      technical.add(TextEditingController());
      total.add(TextEditingController());
      isAbsent.add(false);
    }
  }

  submitData() async {
    try {
      for (int i = 0; i < totalMembers; i++) {
        Map<String, dynamic> mark = {};
        mark["total"] = (double.tryParse(teamWork[i].text.trim()) ?? 0) +
            (double.tryParse(technical[i].text.trim()) ?? 0);
        mark["technical"] = double.tryParse(technical[i].text.trim()) ?? 0;
        mark["teamwork"] = double.tryParse(teamWork[i].text.trim()) ?? 0;
        marks.add(mark);
      }
      await dataBaseMethods.addSupervisorMark(Get.arguments[1], teamInfo, marks);
      marks.clear();
      Get.back();
      Get.showSnackbar(
        GetSnackBar(
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.teal,
          message: evaluationMarks.isEmpty ? 'Mark is added' : "Mark is updated",
        ),
      );
    } catch (e) {
      Get.showSnackbar(
        GetSnackBar(
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.red,
            message: e.toString()),
      );
    }

    // print(marks);
  }

  getData() async {
    evaluationMarks = await dataBaseMethods.getSupervisorMark(Get.arguments[1], teamInfo);
    // print(evaluationMarks);
    if (evaluationMarks.isNotEmpty) {
      for (int i = 0; i < totalMembers; i++) {
        teamWork[i].text = evaluationMarks[i]['teamwork'].toString();
        technical[i].text = evaluationMarks[i]['technical'].toString();
        total[i].text = evaluationMarks[i]['total'].toString();
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    extractData();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mark"),
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.all(5),
        child: Form(
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
                          color: index % 2 == 1
                              ? Colors.tealAccent.shade100
                              : Colors.limeAccent.shade100,
                          child: ListTile(
                            subtitle: Text(name[index].trim()),
                            title: Text(id[index].trim()),
                            trailing: Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(top: 6.0),
                                  child: Text(
                                    "Mark as Absent",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(top: 15.0),
                                  child: Switch(
                                    value: isAbsent[index],
                                    onChanged: (value) {
                                      setState(() {
                                        total[index].clear();
                                        technical[index].clear();
                                        teamWork[index].clear();
                                        isAbsent[index] = !isAbsent[index];
                                      });
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        if (!isAbsent[index])
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: total[index],
                                  readOnly: true,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    double tmp = double.tryParse(value!) ?? 0;
                                    if (tmp > 40.0) {
                                      return "40 marks exceeded.";
                                    } else if (value.trim().isEmpty && isAbsent[index] == true) {
                                      return "Enter marks.";
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    label: Text("Total"),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: TextFormField(
                                  controller: technical[index],
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    double tmp = double.tryParse(value!) ?? 0;
                                    if (tmp > 20.0) {
                                      return "20 marks exceeded.";
                                    } else if (value.trim().isEmpty && isAbsent[index] == true) {
                                      return "Enter marks.";
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    label: Text("Technical"),
                                  ),
                                  onChanged: (value) {
                                    double k = (double.tryParse(value.trim()) ?? 0) +
                                        (double.tryParse(teamWork[index].text.trim()) ?? 0);
                                    setState(() {
                                      total[index].text = k.toString();
                                    });
                                  },
                                ),
                              ),
                              SizedBox(width: 15.w),
                              Expanded(
                                child: TextFormField(
                                  controller: teamWork[index],
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    double tmp = double.tryParse(value!) ?? 0;
                                    if (tmp > 20.0) {
                                      return "20 marks exceeded.";
                                    } else if (value.trim().isEmpty && isAbsent[index] == true) {
                                      return "Enter marks.";
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    label: Text("Teamwork"),
                                  ),
                                  onChanged: (value) {
                                    double k = (double.tryParse(value.trim()) ?? 0) +
                                        (double.tryParse(technical[index].text.trim()) ?? 0);
                                    setState(() {
                                      total[index].text = k.toString();
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        SizedBox(height: 10.h),
                      ],
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    submitData();
                    Get.back();
                  }
                },
                child: evaluationMarks.isEmpty ? const Text("Submit") : const Text("Update"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
