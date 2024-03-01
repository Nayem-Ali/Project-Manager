import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:teamlead/View/admin/add_admin.dart';
import 'package:teamlead/View/admin/approve_request.dart';
import 'package:teamlead/Widget/buttonStyle.dart';
import 'package:teamlead/services/result_sheet_api.dart';
import 'package:teamlead/view/admin/proposal_setting.dart';
import 'package:teamlead/view/admin/result_generation.dart';
import 'package:url_launcher/url_launcher.dart';

import 'all_submitted_proposal.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  bool isLoading = false;
  int value = 0;
  Duration duration = const Duration(minutes: 15);
  late Timer timer;

  resultGeneration() async {
    setTimer();

    setState(() {
      isLoading = true;
    });
    String response = await generateResult("CSE-3300");
    if (response == 'failed') {
      Get.snackbar("Result Generation for CSE-3300 failed", "No teams found");
    }
    setState(() {
      value += 1;
    });
    response = await generateResult("CSE-4800");
    if (response == 'failed') {
      Get.snackbar("Result Generation for CSE-4800 failed", "No teams found");
    }
    setState(() {
      value += 1;
    });
    response = await generateResult("CSE-4801");
    if (response == 'failed') {
      Get.snackbar("Result Generation for CSE-4801 failed", "No teams found");
    }
    setState(() {
      value += 1;
    });

    Uri url = Uri.parse(await ResultSheetApi.giveAccess());
    bool canLunch = !await launchUrl(url);
    if (canLunch) {
      Get.snackbar("Ops", "Something went wrong");
    } else {}
    setState(() {
      value = 0;
      duration = const Duration(minutes: 15);
      isLoading = false;
    });

  }

  setTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      const reduceSecondsBy = 1;
      setState(() {
        final seconds = duration.inSeconds - reduceSecondsBy;
        if (seconds < 0) {
          timer.cancel();
        } else {
          duration = Duration(seconds: seconds);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Admin Dashboard"),
          centerTitle: true,
        ),
        body: isLoading == false
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      image: const AssetImage('images/Leading-university-logo.png'),
                      width: Get.size.width * 0.4,
                      height: Get.size.height * 0.2,
                      fit: BoxFit.fill,
                    ),
                    const Spacer(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          style: buttonStyle(),
                          icon: const Icon(
                            Icons.assignment,
                            size: 25,
                          ),
                          label: const Text(
                            "View Proposals",
                            // textAlign: TextAlign.center,
                          ),
                          onPressed: () {
                            Get.to(const AssignSupervisor());
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton.icon(
                          style: buttonStyle(),
                          icon: const Icon(
                            Icons.add,
                            size: 25,
                          ),
                          label: const Text(
                            "Add Admin",
                            // textAlign: TextAlign.center,
                          ),
                          onPressed: () {
                            Get.to(const AddAdmin());
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: [
                        ElevatedButton.icon(
                          style: buttonStyle(),
                          icon: const Icon(
                            Icons.settings,
                            size: 25,
                          ),
                          label: const Text(
                            "Proposal Setting",
                            // textAlign: TextAlign.center,
                          ),
                          onPressed: () {
                            Get.to(const ProposalSetting());
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton.icon(
                          style: buttonStyle(),
                          icon: const Icon(
                            Icons.approval,
                            size: 25,
                          ),
                          label: const Text(
                            "Request",
                            // textAlign: TextAlign.center,
                          ),
                          onPressed: () {
                            Get.to(const ApproveRequest());
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton.icon(
                          style: buttonStyle(),
                          icon: const Icon(
                            FontAwesomeIcons.file,
                            size: 25,
                          ),
                          label: const Text(
                            "Generate Result",
                            // textAlign: TextAlign.center,
                          ),
                          onPressed: resultGeneration,
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      "Project Committee",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: Get.textScaleFactor * 25),
                    ),
                    Text(
                      "Department of CSE",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: Get.textScaleFactor * 30),
                    ),
                    const Spacer(),
                  ],
                ),
              )
            : Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "This may takes few minutes. Please do not exit during result generation"
                        ". Spreadsheet will be turned on after the operation.",
                        style: TextStyle(
                          fontSize: Get.textScaleFactor * 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Estimated Time ${duration.inSeconds ~/ 60} min ${duration.inSeconds % 60} sec",
                        style: TextStyle(
                          fontSize: Get.textScaleFactor * 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Progress: ${(value / 3 * 100).toStringAsFixed(2)}%",
                        style: TextStyle(
                          fontSize: Get.textScaleFactor * 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      LinearProgressIndicator(
                        borderRadius: BorderRadius.circular(20),
                        value: value / 3,
                        minHeight: Get.width * 0.04,
                        backgroundColor: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
