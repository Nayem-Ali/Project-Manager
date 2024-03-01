import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:teamlead/View/student/proposal.dart';
import 'package:teamlead/View/student/team_request.dart';
import 'package:teamlead/View/student/view_submitted_data.dart';
import 'package:teamlead/Widget/buttonStyle.dart';
import 'package:teamlead/Widget/drawerScreen.dart';
import 'package:teamlead/services/db_service.dart';
import 'package:teamlead/view/teacher/view_announcement.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentScreen extends StatefulWidget {
  const StudentScreen({Key? key}) : super(key: key);

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  DataBaseMethods dataBaseMethods = DataBaseMethods();
  DateTime currentTime = DateTime.now();
  DateTime deadline= DateTime.now();
  bool canSubmit = true;
  Map<String, dynamic> getStudentData = {};
  Map<String, dynamic> teamData = {};
  Map<String, dynamic> proposalCredential = {};

  String formatTime() => DateFormat.yMd().format(currentTime);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    try {
      getStudentData = await dataBaseMethods.getStudent();
      proposalCredential = await dataBaseMethods.getProposalCredential();
      deadline = proposalCredential['deadline'].toDate();
      teamData = await dataBaseMethods.getTeamData(
        getStudentData["projectType"],
        getStudentData['title'],
      );
      DateTime now = DateTime.now();
      if (deadline.difference(DateTime(now.year, now.month, now.day, 0, 0, 0)).inDays < 0) {
        canSubmit = false;
      }
      setState(() {});
    } catch (e) {
      teamData = {};
    }
    print("team data: $teamData");
  }

  wipePreviousProposal() {
    Get.defaultDialog(
        title: "Attention",
        middleText: "Are you sure to delete your previous proposal",
        actions: [
          TextButton(
            onPressed: () async {
              await dataBaseMethods.wipeProposal(teamData);
              await getData();
              Get.back();
            },
            child: const Text("Yes"),
          ),
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text("No"),
          )
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Project Manager"),
          centerTitle: true,
        ),
        drawer: const DrawerScreen(),
        body: canSubmit
            ? Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      if (teamData.isEmpty)
                        SizedBox(
                          height:Get.height * 0.8,
                          width: Get.width * 0.8,
                          child: Column(
                            children: [
                              const Spacer(),
                              if(deadline != null)
                              Text(
                                "Deadline: ${DateFormat.yMMMEd().format(deadline)}",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.teal.shade700,
                                ),
                              ),
                              const Divider(thickness: 1),
                              const SizedBox(
                                height: 20,
                              ),
                              const Text(
                                'Please make sure that only one member from a team submitting the proposal',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.redAccent),
                              ),
                              const SizedBox(height: 12),
                              ElevatedButton.icon(
                                style: buttonStyle(),
                                onPressed: () {
                                  Get.to(const Proposal(),
                                      arguments: proposalCredential['isPreference']);
                                },
                                label: const Text("Submit Proposal"),
                                icon: const Icon(Icons.edit_document),
                              ),
                              const Spacer(),
                              const Text(
                                'If you are unable to make a team, you can give your '
                                'details by tapping on the following button. Project committee'
                                ' will form a team for you.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.blue,
                                ),
                              ),
                              const SizedBox(height: 12),
                              ElevatedButton.icon(
                                onPressed: () {
                                  Get.to(const RequestTeam(),
                                      arguments: proposalCredential['isPreference']);
                                },
                                style: buttonStyle(),
                                label: const Text(
                                  "Request a team",
                                ),
                                icon: const Icon(Icons.request_page),
                              ),
                              const Spacer(),
                              TextButton.icon(
                                onPressed: () async {
                                  Uri url = Uri.parse(
                                      "https://docs.google.com/document/d/1e8-truB02YUG6bWx9YeGsTKIPVqOmYeA/edit?usp=sharing&ouid=113326367042385199173&rtpof=true&sd=true");
                                  if (!await launchUrl(url)) {
                                  } else {
                                    // Get.snackbar("Alert", "Something went wrong");
                                  }
                                },
                                icon: const Icon(Icons.download),
                                label: const Text(
                                  "Download Proposal Template",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              ElevatedButton.icon(
                                onPressed: () {
                                  Get.to(const ViewAnnouncement());
                                },
                                style: buttonStyle(),
                                icon: const Icon(Icons.notification_important),
                                label: const Text("Announcement"),
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                      if (teamData.length != 0)
                        Center(
                          child: teamData['title'].toString().isNotEmpty
                              ? SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height * 0.85,
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: 1,
                                          itemBuilder: (context, index) {
                                            return Column(
                                              children: [
                                                Card(
                                                  color: Colors.greenAccent.shade100,
                                                  shape: Border.all(),
                                                  elevation: 5,
                                                  clipBehavior: Clip.antiAlias,
                                                  child: Column(
                                                    children: [
                                                      ListTile(
                                                        title: Text(
                                                          teamData["title"],
                                                          overflow: TextOverflow.clip,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                Card(
                                                  child: ListTile(
                                                    title: Text(
                                                      teamData["name1"],
                                                      overflow: TextOverflow.clip,
                                                    ),
                                                    subtitle: Text(teamData["id1"]),
                                                  ),
                                                ),
                                                if (teamData.containsKey("email2"))
                                                  Card(
                                                    child: ListTile(
                                                      title: Text(
                                                        teamData["name2"],
                                                        overflow: TextOverflow.clip,
                                                      ),
                                                      subtitle: Text(teamData["id2"]),
                                                    ),
                                                  ),
                                                if (teamData.containsKey("email3"))
                                                  Card(
                                                    child: ListTile(
                                                      title: Text(
                                                        teamData["name3"],
                                                        overflow: TextOverflow.clip,
                                                      ),
                                                      subtitle: Text(teamData["id3"]),
                                                    ),
                                                  ),

                                                if (teamData.containsKey("email4"))
                                                  Card(
                                                    child: ListTile(
                                                      title: Text(
                                                        teamData["name4"],
                                                        overflow: TextOverflow.clip,
                                                      ),
                                                      subtitle: Text(teamData["id4"]),
                                                    ),
                                                  ),
                                                ElevatedButton.icon(
                                                  onPressed: () {
                                                    Get.to(const ViewSubmittedData(),
                                                        arguments: teamData);
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                      minimumSize:
                                                          const Size(double.infinity, 45)),
                                                  icon: const Icon(Icons.remove_red_eye),
                                                  label: Text(
                                                    "View",
                                                    style: TextStyle(
                                                      fontSize: Get.textScaleFactor * 18,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                // Text(getTeamData[""]),
                                                // Text(getTeamData[""]),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                      if (teamData['projectType'] == 'CSE-3300')
                                        Column(
                                          children: [
                                            Text(
                                              "Your proposal submitted for Project - I. To "
                                              "submit proposal for Project -II / Thesis. Wipe out"
                                              " previous proposal.",
                                              style: TextStyle(
                                                fontSize: Get.textScaleFactor * 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            ElevatedButton.icon(
                                              onPressed: wipePreviousProposal,
                                              style: ElevatedButton.styleFrom(
                                                  minimumSize: const Size(double.infinity, 45)),
                                              label: Text(
                                                "Delete",
                                                style: TextStyle(
                                                  fontSize: Get.textScaleFactor * 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              icon: const Icon(Icons.delete_forever),
                                            )
                                          ],
                                        )
                                    ],
                                  ),
                                )
                              : const CircularProgressIndicator(),
                        ),
                    ],
                  ),
                ),
              )
            : Center(
                child: Text(
                  "You have missed the deadline",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                      fontSize: Get.textScaleFactor * 20),
                ),
              ),
      ),
    );
  }
}
