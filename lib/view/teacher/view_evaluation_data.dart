import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teamlead/View/teacher/update_evaluation_data.dart';
import 'package:teamlead/services/db_service.dart';

class ViewEvaluatedData extends StatefulWidget {
  const ViewEvaluatedData({Key? key}) : super(key: key);

  @override
  State<ViewEvaluatedData> createState() => _ViewEvaluatedDataState();
}

class _ViewEvaluatedDataState extends State<ViewEvaluatedData> {
  String initial = Get.arguments[1];
  dynamic teamInfo = Get.arguments[0];
  dynamic evaluatedData = {};
  int totalMembers = 0;
  List<String> name = [];
  List<String> id = [];
  List<String> email = [];
  List<String> cgpa = [];
  List<String> phone = [];

  List<Color> colors = [
    Colors.greenAccent.shade100,
    Colors.yellowAccent.shade100,
    Colors.lightBlue.shade100,
    Colors.deepOrangeAccent.shade100,
  ];

  DataBaseMethods dataBaseMethods = DataBaseMethods();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    evaluatedData = await dataBaseMethods.getIndividualEvaluationData(
        Get.arguments[2], teamInfo['Title'], "evaluationData", initial);
    totalMembers = int.tryParse(teamInfo['Team Members']) ?? 0;
    name = teamInfo['Name'].split('\n');
    id = teamInfo['Student ID'].split('\n');
    email = teamInfo['Email'].split('\n');
    cgpa = teamInfo['CGPA'].split('\n');
    phone = teamInfo['Phone'].split('\n');
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(teamInfo["Title"]),
      ),
      body: evaluatedData.length != 0
          ? Column(
              children: [
                Expanded(
                  flex: 2,
                  child: ListView.builder(
                    itemCount: totalMembers,
                    itemBuilder: (context, index) {
                      return Container(
                        color: colors[index],
                        width: Get.size.width,
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: Column(
                          children: [
                            Text(
                              name[index],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              id[index],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Total Marks Obtained: "
                              "${double.parse(evaluatedData['data'][index + 1]['criteria1']) + double.parse(evaluatedData['data'][index + 1]['criteria2'])}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Divider(thickness: 2),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      "CRITERIA - I: ${evaluatedData['data'][index + 1]['criteria1']}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    if (evaluatedData['data'][index + 1]['viva'] != "")
                                      Text(
                                        "Viva: ${evaluatedData['data'][index + 1]['viva']}",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    if (evaluatedData['data'][index + 1]['problemDefinition'] !=
                                        "")
                                      Text(
                                        "Problem Definition: ${evaluatedData['data'][index + 1]['problemDefinition']}",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    if (evaluatedData['data'][index + 1]['designComplexity'] != "")
                                      Text(
                                        "Design Complexity: ${evaluatedData['data'][index + 1]['designComplexity']}",
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      "CRITERIA - II: ${evaluatedData['data'][index + 1]['criteria2']}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    if (evaluatedData['data'][index + 1]['presentation'] != "")
                                      Text(
                                        "Presentation: ${evaluatedData['data'][index + 1]['presentation']}",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    if (evaluatedData['data'][index + 1]['testing'] != "")
                                      Text(
                                        "Testing & Evaluation: ${evaluatedData['data'][index + 1]['testing']}",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    if (evaluatedData['data'][index + 1]['report'] != "")
                                      Text(
                                        "Report Writing: ${evaluatedData['data'][index + 1]['report']}",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Get.off(const UpdateEvaluationData(), arguments: [
                      initial,
                      teamInfo,
                      evaluatedData,
                    ]);
                  },
                  label: const Text("Edit"),
                  icon: const Icon(Icons.edit),
                )
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
