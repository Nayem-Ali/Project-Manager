import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    dynamic data = await dataBaseMethods.getProposalCredential();
    allow = data["allowEvaluation"];
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
            centerTitle: true,
          ),
          body: allow
              ? Column(
                  children: [
                    TabBar(
                      tabs: [
                        Tab(
                          icon: Text(
                            "CSE - 3300",
                            style: TextStyle(
                              color: Colors.teal,
                              fontSize: Get.textScaleFactor * 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Tab(
                          icon: Text(
                            "CSE - 4800",
                            style: TextStyle(
                              color: Colors.teal,
                              fontSize: Get.textScaleFactor * 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Tab(
                          icon: Text(
                            "CSE - 4801",
                            style: TextStyle(
                              color: Colors.teal,
                              fontSize: Get.textScaleFactor * 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],

                    ),
                    const Expanded(
                      child: TabBarView(

                        children: [
                          Project1(),
                          Project2(),
                          Project3(),
                        ],
                      ),
                    ),
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
