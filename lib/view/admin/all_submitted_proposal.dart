import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:teamlead/View/admin/view_proposal.dart';
import 'package:teamlead/services/db_service.dart';

import 'package:teamlead/view/admin/team_statistics.dart';

import '../../services/proposal_sheets_api.dart';

class AssignSupervisor extends StatefulWidget {
  const AssignSupervisor({Key? key}) : super(key: key);

  @override
  State<AssignSupervisor> createState() => _AssignSupervisorState();
}

class _AssignSupervisorState extends State<AssignSupervisor> {
  dynamic proposalData = [];
  TextEditingController searchController = TextEditingController();
  List<int> searchResult = [];

  bool cse3300 = true;
  bool cse4800 = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    String type = cse3300 ? 'CSE-3300' : 'CSE-4800';
    proposalData = await ProjectSheetApi.getAllRows(type);
    setState(() {});
  }

  search(String key) {
    searchResult.clear();
    for (int i = 0; i < proposalData.length; i++) {
      if (proposalData[i]["Title"].toString().toLowerCase().contains(key.toLowerCase())) {
        searchResult.add(i);
        print(proposalData[i]['Title']);
      } else if (proposalData[i]["Student ID"]
          .toString()
          .toLowerCase()
          .contains(key.toLowerCase())) {
        searchResult.add(i);
        print(proposalData[i]["Student ID"]);
      } else if (proposalData[i]["Name"].toString().toLowerCase().contains(key.toLowerCase())) {
        searchResult.add(i);
        print(proposalData[i]["Name"]);
      } else if (proposalData[i]["Supervisor"]
          .toString()
          .toLowerCase()
          .contains(key.toLowerCase())) {
        searchResult.add(i);
        print(proposalData[i]["Supervisor"]);
      }
    }
    print(searchResult);
    if (searchResult.isEmpty) {
      Get.snackbar("Result not found", "Try with right search key");
    }
    setState(() {});
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
          title: const Text("Proposals"),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  Get.to(const TeamStatistics());
                },
                icon: const Icon(Icons.bar_chart))
          ],
        ),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  onPressed: () async {
                    setState(() {
                      searchController.clear();
                      searchResult.clear();
                      cse3300 = true;
                      cse4800 = false;
                    });
                    await getData();
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: cse3300 ? Colors.greenAccent.shade100 : Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  child: Text(
                    "CSE - 3300",
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: Get.textScaleFactor * 20,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                OutlinedButton(
                    onPressed: () async {
                      setState(() {
                        searchController.clear();
                        searchResult.clear();
                        cse3300 = false;
                        cse4800 = true;
                      });
                      await getData();
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: cse4800 ? Colors.greenAccent.shade100 : Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    child: Text(
                      "CSE - 4800",
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: Get.textScaleFactor * 20,
                      ),
                    )),
              ],
            ),
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
                    label: const Text("Enter title, ID, name, supervisor initial")),
              ),
            ),
            Expanded(
              child: searchResult.isEmpty && proposalData != null
                  ? ListView.builder(
                      itemCount: proposalData.length,
                      itemBuilder: (context, index) {
                        return proposalData[index]["Title"] != ""
                            ? GestureDetector(
                                onTap: () {
                                  Get.to(const ViewProposal(), arguments: proposalData[index]);
                                },
                                child: Card(
                                  color: index % 2 == 0
                                      ? Colors.limeAccent.shade100
                                      : Colors.cyanAccent.shade100,
                                  child: ListTile(
                                    title: Text(proposalData[index]["Title"]),
                                    subtitle: proposalData[index]['Supervisor'] != ''
                                        ? Text("Assigned to: ${proposalData[index]['Supervisor']}")
                                        : const Text("Not yet assigned"),
                                  ),
                                ),
                              )
                            : const SizedBox();
                      },
                    )
                  : ListView.builder(
                      itemCount: searchResult.length,
                      itemBuilder: (context, index) {
                        return proposalData[searchResult[index]]["Title"] != ""
                            ? GestureDetector(
                                onTap: () {
                                  Get.to(const ViewProposal(),
                                      arguments: proposalData[searchResult[index]]);
                                },
                                child: Card(
                                  color: index % 2 == 0
                                      ? Colors.limeAccent.shade100
                                      : Colors.cyanAccent.shade100,
                                  child: ListTile(
                                    title: Text(proposalData[searchResult[index]]["Title"]),
                                    subtitle: proposalData[searchResult[index]]['Supervisor'] != ''
                                        ? Text(
                                            "Assigned to: ${proposalData[searchResult[index]]['Supervisor']}")
                                        : const Text("Not yet assigned"),
                                  ),
                                ),
                              )
                            : const SizedBox();
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
