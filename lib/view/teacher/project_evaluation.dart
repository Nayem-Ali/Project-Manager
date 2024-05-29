import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teamlead/View/teacher/tracher_screen.dart';
import 'package:teamlead/Widget/project1.dart';
import 'package:teamlead/services/db_service.dart';

import '../../Widget/project2.dart';
import '../../Widget/project3.dart';

class ProjectEvaluation extends StatefulWidget {
  const ProjectEvaluation({Key? key}) : super(key: key);

  @override
  State<ProjectEvaluation> createState() => _ProjectEvaluationState();
}

class _ProjectEvaluationState extends State<ProjectEvaluation> {
  DataBaseMethods dataBaseMethods = DataBaseMethods();
  bool allow = false;
  String type = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    dynamic data = await dataBaseMethods.getProposalCredential();
    allow = data["allowEvaluation"];
    type = Get.arguments;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Project Evaluation"),
            leading: IconButton(onPressed: (){
              Get.off(const TeacherHomeScreen());
            }, icon: const Icon(Icons.arrow_back),),
            centerTitle: true,
          ),
          body: allow
              ? Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            setState(() {
                              type = 'CSE-3300';
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: type == 'CSE-3300'
                                ? Colors.greenAccent.shade100
                                : Colors.transparent,
                            shadowColor: Colors.transparent,
                          ),
                          child: Text(
                            "CSE - 3300",
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: Get.textScaleFactor * 16,
                            ),
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            setState(() {
                              type = 'CSE-4800';
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: type == 'CSE-4800'
                                ? Colors.greenAccent.shade100
                                : Colors.transparent,
                            shadowColor: Colors.transparent,
                          ),
                          child: Text(
                            "CSE - 4800",
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: Get.textScaleFactor * 16,
                            ),
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            setState(() {
                              type = 'CSE-4801';
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: type == 'CSE-4801'
                                ? Colors.greenAccent.shade100
                                : Colors.transparent,
                            shadowColor: Colors.transparent,
                          ),
                          child: Text(
                            "CSE - 4801",
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: Get.textScaleFactor * 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if(type == 'CSE-3300') const Expanded(child: Project1()),
                    if(type == 'CSE-4800') const Expanded(child: Project2()),
                    if(type == 'CSE-4801') const Expanded(child: Project3()),
                    // TabBar(
                    //   tabs: [
                    //     Tab(
                    //       icon: Text(
                    //         "CSE - 3300",
                    //         style: TextStyle(
                    //           color: Colors.teal,
                    //           fontSize: Get.textScaleFactor * 16,
                    //           fontWeight: FontWeight.bold,
                    //         ),
                    //       ),
                    //     ),
                    //     Tab(
                    //       icon: Text(
                    //         "CSE - 4800",
                    //         style: TextStyle(
                    //           color: Colors.teal,
                    //           fontSize: Get.textScaleFactor * 16,
                    //           fontWeight: FontWeight.bold,
                    //         ),
                    //       ),
                    //     ),
                    //     Tab(
                    //       icon: Text(
                    //         "CSE - 4801",
                    //         style: TextStyle(
                    //           color: Colors.teal,
                    //           fontSize: Get.textScaleFactor * 16,
                    //           fontWeight: FontWeight.bold,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    //
                    // ),
                    // const Expanded(
                    //   child: TabBarView(
                    //
                    //     children: [
                    //       Project1(),
                    //       Project2(),
                    //       Project3(),
                    //     ],
                    //   ),
                    // ),
                  ],
                )
              : Center(
                  child: Text(
                    "Defence is not started yet",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: Get.textScaleFactor * 18),
                    textAlign: TextAlign.center,
                  ),
                ),
        ),
      ),
    );
  }
}
