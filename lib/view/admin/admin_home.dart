import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:teamlead/View/admin/add_admin.dart';
import 'package:teamlead/View/admin/approve_request.dart';
import 'package:teamlead/Widget/buttonStyle.dart';
import 'package:teamlead/view/admin/proposal_setting.dart';
import 'package:teamlead/view/admin/result_page.dart';

import 'all_submitted_proposal.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Admin Dashboard"),
          centerTitle: true,
        ),
        body: Center(
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
                    onPressed: () {
                      Get.to(const ResultPage());
                    },
                  ),
                ],
              ),
              const Spacer(),
              Text(
                "Project Committee",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: Get.textScaleFactor * 25),
              ),
              Text(
                "Department of CSE",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: Get.textScaleFactor * 30),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
