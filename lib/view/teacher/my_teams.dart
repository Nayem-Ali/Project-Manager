import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:teamlead/View/teacher/view_team.dart';
import 'package:teamlead/Widget/graidentContainer.dart';
import 'package:teamlead/services/db_service.dart';

// import 'package:teamlead/services/google_sheets_api.dart';

import '../../services/proposal_sheets_api.dart';

class MyTeams extends StatefulWidget {
  const MyTeams({Key? key}) : super(key: key);

  @override
  State<MyTeams> createState() => _MyTeamsState();
}

class _MyTeamsState extends State<MyTeams> {
  DataBaseMethods dataBaseMethods = DataBaseMethods();
  bool cse3300 = true;
  bool cse4800 = false;
  bool cse4801 = false;
  dynamic project = [];
  String status = "Loading .... ";
  List<Color> colors = [
    Colors.blue.shade100,
    Colors.cyanAccent.shade100,
    Colors.limeAccent.shade100,
    Colors.indigo.shade100,
    Colors.brown.shade100
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    dynamic myData = await dataBaseMethods.getTeacher();
    if (cse3300) {
      project = await ProjectSheetApi.getMyTeams(myData['initial'], 'CSE-3300');
    } else if (cse4800) {
      project = await ProjectSheetApi.getMyTeams(myData['initial'], 'CSE-4800');
    } else {
      project = await ProjectSheetApi.getMyTeams(myData['initial'], 'CSE-4801');
    }
    if (project.isEmpty) {
      status = "No teams found";
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Teams"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    status = 'Loading ....';
                    cse3300 = true;
                    cse4800 = false;
                    cse4801 = false;
                    project.clear();
                    getData();
                  });
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: Size(100.w, 35.h),
                  backgroundColor: cse3300 ? Colors.greenAccent.shade100 : Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                child: Text(
                  "CSE - 3300",
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 15.h,
                  ),
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    status = 'Loading ....';
                    cse3300 = false;
                    cse4800 = true;
                    cse4801 = false;
                    project.clear();
                    getData();
                  });
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: Size(100.w, 35.h),
                  backgroundColor: cse4800 ? Colors.greenAccent.shade100 : Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                child: Text(
                  "CSE - 4800",
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 15.h,
                  ),
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    status = 'Loading ....';
                    cse3300 = false;
                    cse4800 = false;
                    cse4801 = true;
                    project.clear();
                    getData();
                  });
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: Size(100.w, 35.h),
                  backgroundColor: cse4801 ? Colors.greenAccent.shade100 : Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                child: Text(
                  "CSE - 4801",
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 15.h,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: project.isNotEmpty
                ? ListView.builder(
                    itemCount: project.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          final String projectType;
                          if (cse4801) {
                            projectType = 'CSE-4801';
                          } else if (cse4800) {
                            projectType = 'CSE-4800';
                          } else {
                            projectType = 'CSE-3300';
                          }
                          Get.to(const ViewTeam(), arguments: [project[index], projectType]);
                        },
                        child: Card(
                          // color: colors[index % 5],
                          child: customContainer(
                            ListTile(
                              title: Text(
                                project[index]['Title'],
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : Center(
                    child: Text(status),
                  ),
          ),
        ],
      ),
    );
  }
}
