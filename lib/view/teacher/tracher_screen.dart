import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:teamlead/View/admin/admin_home.dart';
import 'package:teamlead/View/auth/info_screen.dart';
import 'package:teamlead/View/teacher/my_teams.dart';
import 'package:teamlead/View/teacher/project_evaluation.dart';
import 'package:teamlead/Widget/buttonStyle.dart';
import 'package:teamlead/Widget/teacher_drawer.dart';
import 'package:teamlead/services/db_service.dart';
import 'package:teamlead/view/teacher/annoucement.dart';

class TeacherHomeScreen extends StatefulWidget {
  const TeacherHomeScreen({Key? key}) : super(key: key);

  @override
  State<TeacherHomeScreen> createState() => _TeacherHomeScreenState();
}

class _TeacherHomeScreenState extends State<TeacherHomeScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  DateTime currentTime = DateTime.now();
  List<dynamic> admins = [];
  dynamic teacherData = {};

  String formatTime() => DateFormat.yMMMMEEEEd().format(currentTime);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAdmins();
  }

  getAdmins() async {
    DataBaseMethods db = DataBaseMethods();
    teacherData = await db.getTeacher();
    admins = await db.getAdmin();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Project Manager"),
          centerTitle: true,
        ),
        drawer: const TeacherDrawer(),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // Row(
                //   children: [
                //
                //     Container(
                //       height: 60,
                //       width: 60,
                //       decoration: BoxDecoration(
                //         border: Border.all(color: Colors.teal, width: 2),
                //         // borderRadius: BorderRadius.circular(50),
                //       ),
                //       child: Image.network(
                //         auth.currentUser!.photoURL!,
                //         width: 60,
                //         height: 60,
                //         fit: BoxFit.fill,
                //       ),
                //     ),
                //     Container(
                //       padding: const EdgeInsets.symmetric(horizontal: 5),
                //       child: Column(
                //         mainAxisAlignment: MainAxisAlignment.start,
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           SizedBox(
                //             width: MediaQuery.of(context).size.width * 0.6,
                //             child: Text(
                //               "${auth.currentUser!.displayName}",
                //               overflow: TextOverflow.clip,
                //               softWrap: false,
                //               style: const TextStyle(
                //                 fontWeight: FontWeight.bold,
                //                 fontSize: 20,
                //               ),
                //             ),
                //           ),
                //           Text(
                //             formatTime(),
                //             style: const TextStyle(
                //               fontWeight: FontWeight.bold,
                //               fontSize: 16,
                //             ),
                //           )
                //         ],
                //       ),
                //     ),
                //     const Spacer(),
                //     const IconButton(
                //       onPressed: logOutUser,
                //       icon: Icon(Icons.menu),
                //     )
                //   ],
                // ),
                Image(
                  image: const AssetImage('images/Leading-university-logo.png'),
                  width: Get.size.width * 0.4,
                  height: Get.size.height * 0.2,
                  fit: BoxFit.fill,
                ),
                const Spacer(),
                if (teacherData['status'] == 'approved')
                  Column(
                    children: [
                      ElevatedButton.icon(
                        style: buttonStyle(),
                        icon: Icon(
                          Icons.people,
                          size: Get.height * 0.03,
                        ),
                        label: const Text("My Teams"),
                        onPressed: () {
                          Get.to(const MyTeams());
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton.icon(
                        style: buttonStyle(),
                        icon: Icon(
                          Icons.pending_actions_sharp,
                          size: Get.height * 0.03,
                        ),
                        label: const Text("Team Evaluation"),
                        onPressed: () {
                          Get.to(const ProjectEvaluation(), arguments: 'CSE-3300');
                        },
                      ),
                    ],
                  ),
                const SizedBox(
                  height: 20,
                ),
                if (teacherData['status'] == 'approved')
                  Column(
                    children: [
                      ElevatedButton.icon(
                        style: buttonStyle(),
                        icon: Icon(
                          Icons.announcement_sharp,
                          size: Get.height * 0.03,
                        ),
                        label: const Text("Announcement"),
                        onPressed: () {
                          Get.to(const Announcement());
                        },
                      ),
                      if (admins.contains(auth.currentUser!.email))
                        const SizedBox(
                          height: 20,
                        ),
                      if (admins.contains(auth.currentUser!.email))
                        ElevatedButton.icon(
                          style: buttonStyle(),
                          icon: Icon(
                            Icons.admin_panel_settings_rounded,
                            size: Get.height * 0.03,
                          ),
                          label: const Text(
                            "Admin Dashboard",
                          ),
                          onPressed: () {
                            Get.to(const AdminHome());
                          },
                        ),
                    ],
                  ),
                if (teacherData['status'] == 'pending')
                  const Center(
                    child: Text(
                      "Your request is under review. You can get all teacher feature if admin "
                      "approves your request upon given details.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                if (teacherData['status'] == 'rejected')
                  Center(
                    child: Column(
                      children: [
                        const Text(
                          "Your request is rejected by the admin.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Get.to(const InfoScreen());
                            },
                            child: const Text("Resubmit Info"))
                      ],
                    ),
                  ),
                const Spacer(),
                Text(
                  "Project Committee",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: Get.textScaleFactor * 25),
                ),
                Text(
                  "Department of CSE",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: Get.textScaleFactor * 30),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
