import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
                width: 200.w,
                height: 150.h,
                fit: BoxFit.fill,
              ),
              const Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    style: buttonStyle(300, 40),
                    icon:  Icon(
                      Icons.assignment,
                      size: 25.w,
                    ),
                    label: const Text(
                      "View Proposals",
                      // textAlign: TextAlign.center,
                    ),
                    onPressed: () {
                      Get.to(const AssignSupervisor());
                    },
                  ),
                   SizedBox(
                    height: 20.h,
                  ),
                  ElevatedButton.icon(
                    style: buttonStyle(300, 40),
                    icon:  Icon(
                      Icons.add,
                      size: 25.w,
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
               SizedBox(
                height: 20.h,
              ),
              Column(
                children: [
                  ElevatedButton.icon(
                    style: buttonStyle(300, 40),
                    icon:  Icon(
                      Icons.settings,
                      size: 25.w,
                    ),
                    label: const Text(
                      "Proposal Setting",
                      // textAlign: TextAlign.center,
                    ),
                    onPressed: () {
                      Get.to(const ProposalSetting());
                    },
                  ),
                   SizedBox(
                    height: 20.h,
                  ),
                  ElevatedButton.icon(
                    style: buttonStyle(300, 40),
                    icon:  Icon(
                      Icons.approval,
                      size: 25.w,
                    ),
                    label: const Text(
                      "Request",
                      // textAlign: TextAlign.center,
                    ),
                    onPressed: () {
                      Get.to(const ApproveRequest());
                    },
                  ),
                   SizedBox(
                    height: 20.h,
                  ),
                  ElevatedButton.icon(
                    style: buttonStyle(300, 40),
                    icon:  Icon(
                      FontAwesomeIcons.file,
                      size: 25.w,
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
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
              ),
              Text(
                "Department of CSE",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
