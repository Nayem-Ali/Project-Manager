import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../services/db_service.dart';
import '../../services/proposal_sheets_api.dart';
import '../../services/result_sheet_api.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({Key? key}) : super(key: key);

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  bool cse3300 = false;
  bool cse4800 = false;
  bool cse4801 = false;
  RxInt count = 0.obs;
  RxInt totalTeams = 0.obs;
  dynamic teams = [];
  List<dynamic> result = [].obs;

  sheetLink() async {
    Uri url = Uri.parse(await ResultSheetApi.giveAccess());
    bool canLunch = !await launchUrl(url);
    if (canLunch) {
      Get.snackbar("Ops", "Something went wrong");
    } else {}
  }

  getResult(String type) async {
    DataBaseMethods dataBaseMethods = DataBaseMethods();

    await ResultSheetApi.deleteResult(type);

    teams = await ProjectSheetApi.getAllRows(type);
    if (teams == null) {
      Get.snackbar("Result Generation for CSE-3300 failed", "No teams found");
    }
    try {
      result.clear();
      count.value = 0;
      totalTeams.value = teams.length;
      setState(() {});
      for (var team in teams) {
        List<double> supervisorEvaluation = [];
        List<double> boardEvaluation = [];
        List<String> evaluatedBy = [];
        List<String> grade = [];
        List<double> points = [];
        List<double> totalMark = [];
        bool markedBySupervisor = false;
        bool markedByBoard = false;
        dynamic boardMark = await dataBaseMethods.getEvaluationData(
          type,
          team['Title']!,
          'evaluationData',
        );
        dynamic supervisorMark =
            await dataBaseMethods.getSupervisorMarkForGenerateResult(type, team['Title']);

        if (supervisorMark.length > 0) {
          markedBySupervisor = true;
        }
        if (boardMark.length > 0) {
          markedByBoard = true;

          for (int i = 0; i < boardMark[0]['data'].length - 1; i++) {
            boardEvaluation.add(0.0);
          }
        }

        for (int i = 0; i < supervisorMark.length; i++) {
          double totalObtained = supervisorMark[i]['total'] * 1.0;
          supervisorEvaluation.add(totalObtained);
        }
        //
        for (var individualMark in boardMark) {
          if (individualMark['data'][0]['evaluatedBy'] != null) {
            evaluatedBy.add(individualMark['data'][0]['evaluatedBy']);

            for (int i = 0; i < individualMark['data'].length - 1; i++) {
              double c1 = individualMark['data'][i + 1]['criteria1'] * 1.0;
              double c2 = individualMark['data'][i + 1]['criteria2'] * 1.0;
              boardEvaluation[i] += c1 + c2;
            }
          }
        }
        //
        for (int i = 0; i < boardEvaluation.length; i++) {
          boardEvaluation[i] = (boardEvaluation[i] / evaluatedBy.length).floor() * 1.0;
        }
        //
        if (markedByBoard && markedBySupervisor) {
          for (int i = 0; i < boardEvaluation.length; i++) {
            totalMark.add(boardEvaluation[i] + supervisorEvaluation[i]);
            if (totalMark[i] >= 80) {
              grade.add('A+');
              points.add(4.00);
            } else if (totalMark[i] >= 75 && totalMark[i] <= 79) {
              grade.add('A');
              points.add(3.75);
            } else if (totalMark[i] >= 70 && totalMark[i] <= 74) {
              grade.add('A-');
              points.add(3.50);
            } else if (totalMark[i] >= 65 && totalMark[i] <= 69) {
              grade.add('B+');
              points.add(3.25);
            } else if (totalMark[i] >= 60 && totalMark[i] <= 64) {
              grade.add('B');
              points.add(3.00);
            } else if (totalMark[i] >= 55 && totalMark[i] <= 59) {
              grade.add('B-');
              points.add(2.75);
            } else if (totalMark[i] >= 50 && totalMark[i] <= 54) {
              grade.add('C+');
              points.add(2.50);
            } else if (totalMark[i] >= 45 && totalMark[i] <= 49) {
              grade.add('C');
              points.add(2.25);
            } else if (totalMark[i] >= 40 && totalMark[i] <= 44) {
              grade.add('D');
              points.add(2.00);
            } else {
              grade.add("F");
              points.add(0.00);
            }
          }
        }

        final resultData = {
          "ID": "",
          "Title": team['Title'],
          "Name": team['Name'],
          "Team Members": team["Team Members"],
          "Student ID": team['Student ID'],
          "Evaluated By":
              markedByBoard ? "${evaluatedBy.join(', ')}\n(${evaluatedBy.length})" : "",
          "Defense Board Mark Average":
              markedByBoard ? boardEvaluation.join('\n') : "Not Evaluated",
          "Supervisor Mark":
              markedBySupervisor ? supervisorEvaluation.join('\n') : "Not Evaluated",
          "Total": markedBySupervisor && markedByBoard ? totalMark.join('\n') : "Not Evaluated",
          "Grade": markedBySupervisor && markedByBoard ? grade.join('\n') : "Not Evaluated",
          "Point": markedBySupervisor && markedByBoard ? points.join('\n') : "Not Evaluated",
        };

        await ResultSheetApi.addResult(resultData, type);
        markedBySupervisor = false;
        markedByBoard = false;
        count.value++;
        result.add(resultData);
      }
    } catch (e) {
      print(e.toString());
      Get.snackbar("Result Generation for CSE-3300 failed", "No teams found");
    }

    // cse4800 = await ProjectSheetApi.getAllRows("CSE-4800");
    // cse4801 = await ProjectSheetApi.getAllRows("CSE-4801");
    teams.clear();
    setState(() {});
  }

  showResultData(int index) {
    if (result[index]['Total'] == "Not Evaluated") return;
    List<String> studentID = result[index]['Student ID'].split('\n');
    List<String> total = result[index]['Total'].split('\n');
    List<String> grade = result[index]['Grade'].split('\n');
    List<String> point = result[index]['Point'].split('\n');
    Get.bottomSheet(
      backgroundColor: Colors.white,
      isDismissible: true,
      isScrollControlled: true,
      Table(
        border: TableBorder.all(),
        children: [
          TableRow(children: [
            Text(
              "Student ID",
              style: TextStyle(fontSize: Get.textScaleFactor * 15, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Text(
              "Total",
              style: TextStyle(fontSize: Get.textScaleFactor * 15, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Text(
              "Grade",
              style: TextStyle(fontSize: Get.textScaleFactor * 15, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Text(
              "CGPA",
              style: TextStyle(fontSize: Get.textScaleFactor * 15, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ]),
          for (int i = 0; i < studentID.length; i++)
            TableRow(children: [
              Text(
                studentID[i],
                style: TextStyle(fontSize: Get.textScaleFactor * 15, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Text(
                total[i],
                style: TextStyle(fontSize: Get.textScaleFactor * 15, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Text(
                grade[i],
                style: TextStyle(fontSize: Get.textScaleFactor * 15, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Text(
                point[i],
                style: TextStyle(fontSize: Get.textScaleFactor * 15, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ])
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Result"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(4),
            child: Text(
              "To generate result please press any button",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedButton(
                onPressed: () {
                  if (count.value == totalTeams.value) {
                    getResult("CSE-3300");
                    cse4801 = cse4800 = false;
                    cse3300 = true;
                  } else {
                    Get.showSnackbar(const GetSnackBar(
                      duration: Duration(seconds: 3),
                      message: "Wait until finish current result generation.",
                      backgroundColor: Colors.redAccent,
                    ));
                  }
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: cse3300 ? Colors.greenAccent.shade100 : Colors.transparent,
                ),
                child: const Text("CSE-3300"),
              ),
              OutlinedButton(
                onPressed: () {
                  if (count.value == totalTeams.value) {
                    getResult("CSE-4800");
                    cse4801 = cse3300 = false;
                    cse4800 = true;
                  } else {
                    Get.showSnackbar(const GetSnackBar(
                      duration: Duration(seconds: 3),
                      message: "Wait until finish current result generation.",
                      backgroundColor: Colors.redAccent,
                    ));
                  }
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: cse4800 ? Colors.greenAccent.shade100 : Colors.transparent,
                ),
                child: const Text("CSE-4800"),
              ),
              OutlinedButton(
                onPressed: () {
                  if (count.value == totalTeams.value) {
                    getResult("CSE-4801");
                    cse3300 = cse4800 = false;
                    cse4801 = true;
                  } else {
                    Get.showSnackbar(const GetSnackBar(
                      duration: Duration(seconds: 3),
                      message: "Wait until finish current result generation.",
                      backgroundColor: Colors.redAccent,
                    ));
                  }
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: cse4801 ? Colors.greenAccent.shade100 : Colors.transparent,
                ),
                child: const Text("CSE-4801"),
              ),
            ],
          ),

          if (totalTeams.value != 0)
            Obx(
              () => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    LinearProgressIndicator(
                      value: count.value / totalTeams.value,
                      minHeight: 20,
                      borderRadius: BorderRadius.circular(10),
                      backgroundColor: Colors.grey,
                    ),
                    Text(
                      "${(100 * (count.value / totalTeams.value)).toStringAsFixed(2)} %",
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
          if (totalTeams.value != 0)
            Obx(
              () => Expanded(
                child: ListView.builder(
                  itemCount: result.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: index % 2 == 0 ? Colors.blueGrey.shade100 : Colors.green.shade100,
                      child: ListTile(
                        onTap: () => showResultData(index),
                        leading: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: Text(
                            "${index + 1}",
                            style: GoogleFonts.adamina(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          result[index]['Title'],
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: result[index]['Total'] == "Not Evaluated"
                            ? const Text(
                                "Not Evaluated",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : const Text(
                                "Evaluated",
                                style: TextStyle(
                                  color: Colors.indigoAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ),
            ),
          // Obx(
          //   () => LinearProgressIndicator(
          //     value: resultProgress.count.value / teams.length,
          //   ),
          // ),
          // Obx(
          //   () => Expanded(
          //     child: ListView.builder(
          //       itemCount: resultProgress.resultData.length,
          //       itemBuilder: (_,index) {
          //         return Card(
          //           child: ListTile(
          //             title: resultProgress.resultData[index]['Title'],
          //           ),
          //         );
          //       },
          //     ),
          //   ),
          // ),
          if (count.value == totalTeams.value)
            ElevatedButton(
              onPressed: sheetLink,
              child: const Text(
                "Open Result Sheet",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            )
        ],
      ),
    );
  }
}
