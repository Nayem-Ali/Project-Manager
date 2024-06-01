import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teamlead/View/teacher/view_evaluation_data.dart';

// import 'package:teamlead/services/google_sheets_api.dart';

import '../View/teacher/evaluate_team.dart';
import '../services/db_service.dart';
import '../services/proposal_sheets_api.dart';

class Project2 extends StatefulWidget {
  const Project2({Key? key}) : super(key: key);

  @override
  State<Project2> createState() => _Project1State();
}

class _Project1State extends State<Project2> {
  TextEditingController searchController = TextEditingController();
  DataBaseMethods dataBaseMethods = DataBaseMethods();
  dynamic p1 = [];
  dynamic evaluatedBy = [];
  dynamic teacherInfo = [];
  List<int> searchResult = [];
  String status = "Loading...";
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    teacherInfo = await dataBaseMethods.getTeacher();
    p1 = await ProjectSheetApi.getAllRows('CSE-4800');
    evaluatedBy.clear();
    if (p1 != null) {
      evaluatedBy = await dataBaseMethods.getTeamToTeacherMarked(
        teacherInfo['initial'],
        'CSE-4800',
      );
      // for (int i = 0; i < p1.length; i++) {
      //   evaluatedBy.add(await dataBaseMethods.getEvaluationID(
      //     'CSE-4800',
      //     p1[i]["Title"],
      //     "evaluationData",
      //   ));
      // }
    } else {
      status = "No teams found";
    }
    // for (int i = 0; i < evaluatedBy.length; i++) {
    //   for (int j = 0; j < evaluatedBy[i].length; j++) {
    //     await dataBaseMethods.addTeamToTeacherMarked(
    //       p1[i]['Title'],
    //       'CSE-4800',
    //       evaluatedBy[i][j],
    //       i,
    //     );
    //   }
    // }
    setState(() {
      isLoading = false;
    });
  }

  search(String key) {
    searchResult.clear();
    for (int i = 0; i < p1.length; i++) {
      if (p1[i]["Title"].toString().toLowerCase().contains(key.toLowerCase())) {
        searchResult.add(i);
        // print(p1[i]['Title']);
      } else if (p1[i]["Student ID"].toString().toLowerCase().contains(key.toLowerCase())) {
        searchResult.add(i);
        // print(p1[i]["Student ID"]);
      } else if (p1[i]["Name"].toString().toLowerCase().contains(key.toLowerCase())) {
        searchResult.add(i);
        // print(p1[i]["Name"]);
      } else if (p1[i]["Supervisor"].toString().toLowerCase().contains(key.toLowerCase())) {
        searchResult.add(i);
        // print(p1[i]["Supervisor"]);
      }
    }
    if (searchResult.isEmpty) {
      Get.snackbar("Result not found", "Try with right search key");
    }
    setState(() {});
  }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return p1 != null
        ? Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: searchController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      onPressed: () {
                        search(searchController.text.trim());
                      },
                      icon: const Icon(Icons.search),
                    ),
                    label: Text(
                      "Enter title, ID, name, supervisor initial",
                      style: GoogleFonts.adamina(fontWeight: FontWeight.bold, fontSize: 12.sp),
                    ),
                  ),
                ),
              ),
              if (isLoading) const Spacer(),
              isLoading == false
                  ? Expanded(
                      child: searchResult.isEmpty
                          ? ListView.builder(
                              itemCount: p1.length,
                              itemBuilder: (context, index) {
                                return p1[index]['Title'] != ""
                                    ? GestureDetector(
                                        onTap: () {
                                          // print(evaluatedBy[index]);
                                          if (evaluatedBy.contains(p1[index]['Title'])) {
                                            Get.to(
                                              const ViewEvaluatedData(),
                                              arguments: [
                                                p1[index],
                                                teacherInfo["initial"],
                                                'CSE-4800',
                                              ],
                                            );
                                          } else {
                                            Get.to(const EvaluatePage(),
                                                arguments: [p1[index], 'CSE-4800']);
                                          }
                                        },
                                        child: Card(
                                          color: Colors.green.shade100,
                                          child: ListTile(
                                            leading: CircleAvatar(
                                              backgroundColor: Colors.transparent,
                                              child: Text(
                                                p1[index]['ID'],
                                                style: GoogleFonts.adamina(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            title: Text(
                                              p1[index]['Title'],
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            subtitle:
                                                Text("Supervisor: ${p1[index]['Supervisor']}"),
                                            trailing: evaluatedBy.contains(p1[index]['Title'])
                                                ? const Text(
                                                    "Evaluated",
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontWeight: FontWeight.bold),
                                                  )
                                                : const SizedBox(),
                                          ),
                                        ),
                                      )
                                    : const SizedBox();
                              },
                            )
                          : ListView.builder(
                              itemCount: searchResult.length,
                              itemBuilder: (context, idx) {
                                return GestureDetector(
                                  onTap: () {
                                    // print(evaluatedBy[searchResult[index]]);
                                    if (evaluatedBy.contains(p1[searchResult[idx]]['Title'])) {
                                      Get.to(
                                        const ViewEvaluatedData(),
                                        arguments: [
                                          p1[searchResult[idx]],
                                          teacherInfo["initial"],
                                          'CSE-4800',
                                        ],
                                      );
                                    } else {
                                      Get.to(const EvaluatePage(),
                                          arguments: [p1[searchResult[idx]], 'CSE-4800']);
                                    }
                                  },
                                  child: Card(
                                    color: Colors.green.shade100,
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        child: Text(
                                          p1[searchResult[idx]]['ID'],
                                          style: GoogleFonts.adamina(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        p1[searchResult[idx]]['Title'],
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      subtitle: Text(
                                          "Supervisor: ${p1[searchResult[idx]]['Supervisor']}"),
                                      trailing:
                                          evaluatedBy.contains(p1[searchResult[idx]]['Title'])
                                              ? const Text(
                                                  "Evaluated",
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontWeight: FontWeight.bold),
                                                )
                                              : const SizedBox(),
                                    ),
                                  ),
                                );
                              },
                            ),
                    )
                  : Align(
                      alignment: Alignment.center,
                      child: Text(status),
                    ),
              if (isLoading) const Spacer(),
            ],
          )
        : Center(
            child: Text(status),
          );
  }
}
