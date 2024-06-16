import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:teamlead/View/student/proposal.dart';
import 'package:teamlead/View/student/team_request.dart';
import 'package:teamlead/Widget/buttonStyle.dart';
import 'package:teamlead/Widget/student_drawer.dart';
import 'package:teamlead/services/db_service.dart';
import 'package:teamlead/services/proposal_sheets_api.dart';
import 'package:teamlead/view/student/view_submitted_data.dart';
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
  late DateTime deadline;
  Map<String, dynamic> getStudentData = {};
  List<String> proposalData = [];
  Map<String, dynamic> proposalCredential = {};
  bool isLoading = true;
  bool isFound = false;
  String courseCode = "";

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
      String studentID = getStudentData['id'];
      List<String> student3300 = await ProjectSheetApi.getColumn("CSE-3300", "Student ID");
      List<String> student4800 = await ProjectSheetApi.getColumn("CSE-4800", "Student ID");
      List<String> student3300R =
      await ProjectSheetApi.getColumn("CSE-3300-team-request", "Student ID");
      List<String> student4800R =
      await ProjectSheetApi.getColumn("CSE-4800-team-request", "Student ID");
      // print(student3300.join(" ").contains(studentID));
      if (student3300.isNotEmpty && !isFound) {
        for (int i = 0; i < student3300.length; i++) {
          if (student3300[i].contains(studentID)) {
            proposalData = await ProjectSheetApi.getRow('CSE-3300', i + 2);
            isFound = true;
            courseCode = 'CSE-3300';
            break;
          }
        }
      }
      if (student4800.isNotEmpty && !isFound) {
        for (int i = 0; i < student4800.length; i++) {
          if (student4800[i].contains(studentID)) {
            proposalData = await ProjectSheetApi.getRow('CSE-4800', i + 2);
            isFound = true;
            courseCode = 'CSE-4800';
            break;
          }
        }
      }
      if (student3300R.isNotEmpty && !isFound) {
        for (int i = 0; i < student3300R.length; i++) {
          if (student3300R[i].contains(studentID)) {
            proposalData = await ProjectSheetApi.getRow('CSE-3300-team-request', i + 2);
            isFound = true;
            courseCode = 'CSE-3300-team-request';
            break;
          }
        }
      }
      if (student4800R.isNotEmpty && !isFound) {
        for (int i = 0; i < student4800R.length; i++) {
          if (student4800R[i].contains(studentID)) {
            proposalData = await ProjectSheetApi.getRow('CSE-4800-team-request', i + 2);
            isFound = true;
            courseCode = 'CSE-4800-team-request';
            break;
          }
        }
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      proposalData = [];
    }
    // print("team data: $proposalData");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Project Manager"),
        centerTitle: true,
      ),
      drawer: const DrawerScreen(),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Text(
                "Deadline: ${DateFormat.yMMMEd().format(deadline)}",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.teal.shade700,
                ),
              ),
              const Divider(thickness: 1),
              SizedBox(height: 10.h),
              if (proposalData.isNotEmpty)
                Text("Proposal Submitted for ${courseCode.substring(0, 8)}", style: GoogleFonts
                    .adamina(
                  fontSize: 14.h,
                  color: Colors.teal,
                  fontWeight: FontWeight.bold
                ),),
              SizedBox(height: 10.h),
              if (proposalData.isNotEmpty)
                ElevatedButton.icon(
                  onPressed: () {
                    Get.to(() => const ViewSubmittedData(), arguments: proposalData);
                  },
                  style: buttonStyle(300, 40),
                  icon: const Icon(Icons.remove_red_eye_outlined),
                  label: const Text("View Proposal"),
                ),
              SizedBox(height: 10.h),
              Text(
                'Please make sure that only one member from a team submitting the proposal',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14.h, fontWeight: FontWeight.w700, color: Colors.redAccent),
              ),
              SizedBox(height: 10.h),
              ElevatedButton.icon(
                style: buttonStyle(300, 40),
                onPressed: () {
                  // print(deadline.difference(currentTime).inDays);\
                  if (deadline
                      .difference(DateTime.now())
                      .inSeconds < 0) {
                    Get.showSnackbar(
                      const GetSnackBar(
                        duration: Duration(seconds: 3),
                        backgroundColor: Colors.redAccent,
                        message: "Deadline is over.",
                      ),
                    );
                  } else {
                    Get.to(
                      const Proposal(),
                      arguments: [proposalCredential['isPreference'], courseCode],
                    );
                  }
                },
                label: const Text("Submit Proposal"),
                icon: const Icon(Icons.edit_document),
              ),
              SizedBox(height: 10.h),
              Text(
                'If you are unable to make a team, you can give your '
                    'details by tapping on the following button. Project committee'
                    ' will form a team for you.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.h,
                  fontWeight: FontWeight.w700,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 10.h),
              ElevatedButton.icon(
                onPressed: () {
                  if (deadline
                      .difference(DateTime.now())
                      .inSeconds < 0) {
                    Get.showSnackbar(
                      const GetSnackBar(
                        duration: Duration(seconds: 3),
                        backgroundColor: Colors.redAccent,
                        message: "Deadline is over.",
                      ),
                    );
                  } else {
                    Get.to(const RequestTeam(),
                        arguments: [proposalCredential['isPreference'], courseCode]);
                  }
                },
                style: buttonStyle(300, 40),
                label: const Text(
                  "Request a team",
                ),
                icon: const Icon(Icons.request_page),
              ),
              SizedBox(height: 10.h),
              TextButton.icon(
                onPressed: () async {
                  Uri url = Uri.parse(
                      "https://docs.google.com/document/d/1e8-truB02YUG6bWx9YeGsTKIPVqOmYeA/edit?usp=sharing&ouid=113326367042385199173&rtpof=true&sd=true");
                  if (!await launchUrl(url)) {} else {
                    // Get.snackbar("Alert", "Something went wrong");
                  }
                },
                icon: const Icon(Icons.download),
                label: Text(
                  "Download Proposal Template",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.h,
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              ElevatedButton.icon(
                onPressed: () {
                  Get.to(const ViewAnnouncement());
                },
                style: buttonStyle(300, 40),
                icon: const Icon(Icons.notification_important),
                label: const Text("Announcement"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// Center(
// child: teamData['title'].toString().isNotEmpty
// ? SizedBox(
// width: MediaQuery.of(context).size.width,
// height: MediaQuery.of(context).size.height * 0.85,
// child: Column(
// children: [
// Expanded(
// child: ListView.builder(
// itemCount: 1,
// itemBuilder: (context, index) {
// return Column(
// children: [
// Card(
// color: Colors.greenAccent.shade100,
// shape: Border.all(),
// elevation: 5,
// clipBehavior: Clip.antiAlias,
// child: Column(
// children: [
// ListTile(
// title: Text(
// teamData["title"],
// overflow: TextOverflow.clip,
// ),
// ),
// ],
// ),
// ),
//
// Card(
// child: ListTile(
// title: Text(
// teamData["name1"],
// overflow: TextOverflow.clip,
// ),
// subtitle: Text(teamData["id1"]),
// ),
// ),
// if (teamData.containsKey("email2"))
// Card(
// child: ListTile(
// title: Text(
// teamData["name2"],
// overflow: TextOverflow.clip,
// ),
// subtitle: Text(teamData["id2"]),
// ),
// ),
// if (teamData.containsKey("email3"))
// Card(
// child: ListTile(
// title: Text(
// teamData["name3"],
// overflow: TextOverflow.clip,
// ),
// subtitle: Text(teamData["id3"]),
// ),
// ),
//
// if (teamData.containsKey("email4"))
// Card(
// child: ListTile(
// title: Text(
// teamData["name4"],
// overflow: TextOverflow.clip,
// ),
// subtitle: Text(teamData["id4"]),
// ),
// ),
// ElevatedButton.icon(
// onPressed: () {
// Get.to(const ViewSubmittedData(),
// arguments: teamData);
// },
// style: ElevatedButton.styleFrom(
// minimumSize:
// const Size(double.infinity, 45)),
// icon: const Icon(Icons.remove_red_eye),
// label: Text(
// "View",
// style: TextStyle(
// fontSize: Get.textScaleFactor * 18,
// fontWeight: FontWeight.bold,
// ),
// ),
// ),
// // Text(getTeamData[""]),
// // Text(getTeamData[""]),
// ],
// );
// },
// ),
// ),
// if (teamData['projectType'] == 'CSE-3300')
// Column(
// children: [
// Text(
// "Your proposal submitted for Project - I. To "
// "submit proposal for Project -II / Thesis. Wipe out"
// " previous proposal.",
// style: TextStyle(
// fontSize: Get.textScaleFactor * 18,
// fontWeight: FontWeight.bold,
// ),
// textAlign: TextAlign.center,
// ),
// ElevatedButton.icon(
// onPressed: wipePreviousProposal,
// style: ElevatedButton.styleFrom(
// minimumSize: const Size(double.infinity, 45)),
// label: Text(
// "Delete",
// style: TextStyle(
// fontSize: Get.textScaleFactor * 18,
// fontWeight: FontWeight.bold,
// ),
// ),
// icon: const Icon(Icons.delete_forever),
// )
// ],
// )
// ],
// ),
// )
// : const CircularProgressIndicator(),
// ),
