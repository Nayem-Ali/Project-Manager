import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:teamlead/Widget/buttonStyle.dart';
import 'package:teamlead/services/db_service.dart';

import '../../services/proposal_sheets_api.dart';

class ProposalSetting extends StatefulWidget {
  const ProposalSetting({Key? key}) : super(key: key);

  @override
  State<ProposalSetting> createState() => _ProposalSettingState();
}

class _ProposalSettingState extends State<ProposalSetting> {
  DataBaseMethods dataBaseMethods = DataBaseMethods();
  TextEditingController dateController = TextEditingController();
  late DateTime deadline;
  bool preference = true;
  bool allowEvaluation = false;
  bool isTriggered = false;
  bool isLoading3 = false;
  bool isLoading1 = false;
  bool isLoading2 = false;
  bool isLoading4 = false;
  bool isLoading5 = false;
  Map<String, dynamic> previousData = {};

  pickDate() async {
    deadline = (await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2023),
          lastDate: DateTime(2050),
        )) ??
        DateTime.now();
    deadline = DateTime(deadline.year, deadline.month, deadline.day, 0, 0, 0);
    setState(() {
      isTriggered = !isTriggered;
    });
    dateController.text = DateFormat.yMMMd().format(deadline);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    previousData = await dataBaseMethods.getProposalCredential();
    deadline = previousData['deadline'].toDate();
    dateController.text = DateFormat.yMMMd().format(deadline);
    // print(dateController);
    preference = previousData['isPreference'];
    allowEvaluation = previousData['allowEvaluation'];
    setState(() {});
  }

  // updateMergedTeam() async {
  //
  //
  //   dynamic proposal33 = await ProjectSheetApi.getAllRows("CSE-3300");
  //   dynamic proposal48 = await ProjectSheetApi.getAllRows("CSE-4800");
  //   dynamic proposal481 = await ProjectSheetApi.getAllRows("CSE-4801");
  //
  //   if (proposal33 != null) {
  //     for (var proposal in proposal33) {
  //       // print(cse33);
  //       // if (cse33.contains(proposal['Title']) == false) {
  //       List<String> names = proposal['Name'].hlit('\n');
  //       List<String> id = proposal['Student ID'].hlit('\n');
  //       List<String> emails = proposal['Email'].hlit('\n');
  //       List<String> numbers = proposal['Phone'].hlit('\n');
  //       List<String> cgpa = proposal['CGPA'].hlit('\n');
  //
  //       Map<String, dynamic> teamInfo = {
  //         "projectType": "CSE-3300",
  //         "title": proposal['Title'],
  //         "link": proposal['Proposal Drive Link'],
  //         "preference": proposal["Preferred Supervisor"],
  //         for (int i = 0; i < names.length; i++) "name${i + 1}": names[i],
  //         for (int i = 0; i < id.length; i++) "id${i + 1}": id[i],
  //         for (int i = 0; i < emails.length; i++) "email${i + 1}": emails[i],
  //         for (int i = 0; i < numbers.length; i++) "number${i + 1}": numbers[i],
  //         for (int i = 0; i < cgpa.length; i++) "cgpa${i + 1}": cgpa[i],
  //         "isAssigned": "",
  //         "proposalID": "",
  //         "submitted": "yes",
  //       };
  //
  //       // await dataBaseMethods.addMergedTeamData("CSE-3300", proposal['Title'], teamInfo);
  //       // }
  //     }
  //   }
  //   if (proposal48 != null) {
  //     for (var proposal in proposal48) {
  //       // if (cse48.contains(proposal['Title']) == false) {
  //       List<String> names = proposal['Name'].hlit('\n');
  //       List<String> id = proposal['Student ID'].hlit('\n');
  //       List<String> emails = proposal['Email'].hlit('\n');
  //       List<String> numbers = proposal['Phone'].hlit('\n');
  //       List<String> cgpa = proposal['CGPA'].hlit('\n');
  //
  //       Map<String, dynamic> teamInfo = {
  //         "projectType": "CSE-4800",
  //         "title": proposal['Title'],
  //         "link": proposal['Proposal Drive Link'],
  //         "preference": proposal["Preferred Supervisor"],
  //         for (int i = 0; i < names.length; i++) "name${i + 1}": names[i],
  //         for (int i = 0; i < id.length; i++) "id${i + 1}": id[i],
  //         for (int i = 0; i < emails.length; i++) "email${i + 1}": emails[i],
  //         for (int i = 0; i < numbers.length; i++) "number${i + 1}": numbers[i],
  //         for (int i = 0; i < cgpa.length; i++) "cgpa${i + 1}": cgpa[i],
  //         "isAssigned": "",
  //         "proposalID": "",
  //         "submitted": "yes",
  //       };
  //
  //       // await dataBaseMethods.addMergedTeamData("CSE-4800", proposal['Title'], teamInfo);
  //       // }
  //     }
  //   }
  //
  //   if (proposal481 != null) {
  //     for (var proposal in proposal481) {
  //       // if (cse481.contains(proposal['Title']) == false) {
  //       List<String> names = proposal['Name'].hlit('\n');
  //       List<String> id = proposal['Student ID'].hlit('\n');
  //       List<String> emails = proposal['Email'].hlit('\n');
  //       List<String> numbers = proposal['Phone'].hlit('\n');
  //       List<String> cgpa = proposal['CGPA'].hlit('\n');
  //
  //       Map<String, dynamic> teamInfo = {
  //         "projectType": "CSE-4801",
  //         "title": proposal['Title'],
  //         "link": proposal['Proposal Drive Link'],
  //         "preference": proposal["Preferred Supervisor"],
  //         for (int i = 0; i < names.length; i++) "name${i + 1}": names[i],
  //         for (int i = 0; i < id.length; i++) "id${i + 1}": id[i],
  //         for (int i = 0; i < emails.length; i++) "email${i + 1}": emails[i],
  //         for (int i = 0; i < numbers.length; i++) "number${i + 1}": numbers[i],
  //         for (int i = 0; i < cgpa.length; i++) "cgpa${i + 1}": cgpa[i],
  //         "isAssigned": "",
  //         "proposalID": "",
  //         "submitted": "yes",
  //       };
  //
  //       // await dataBaseMethods.addMergedTeamData("CSE-4801", proposal['Title'], teamInfo);
  //       // }
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Proposal Setting'),
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: dateController,
                    onTap: () {
                      pickDate();
                    },
                    readOnly: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("Pick Submission Deadline"),
                      suffixIcon: Icon(Icons.date_range),
                    ),
                  ),
                ),
                if (isTriggered) SizedBox(width: 30.w),
                if (isTriggered)
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        Map<String, dynamic> credentials = {
                          "deadline": deadline,
                          "isPreference": preference,
                          "allowEvaluation": allowEvaluation,
                        };
                        await dataBaseMethods.addProposalCredential(credentials);

                        isTriggered = false;
                        setState(() {});
                      },
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(Get.width * 0.2, Get.height * 0.07)),
                      icon: const Icon(Icons.update),
                      label: Text(
                        'Update',
                        style: TextStyle(fontSize: 12.h),
                      ),
                    ),
                  )
              ],
            ),
            SizedBox(height: 20.h),
            SwitchListTile(
              value: preference,
              onChanged: (value) async {
                setState(() {
                  preference = value;
                });
                await dataBaseMethods.updateProposalCredential({"isPreference": preference});
              },
              title: Text(
                "Allow Supervisor Preference",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.h),
              ),
              tileColor: Colors.teal.shade100,
            ),
            SizedBox(height: 20.h),
            isLoading5
                ? const CircularProgressIndicator()
                : SwitchListTile(
                    value: allowEvaluation,
                    onChanged: (value) async {
                      setState(() {
                        allowEvaluation = value;
                        isLoading5 = true;
                      });

                      await dataBaseMethods
                          .updateProposalCredential({"allowEvaluation": allowEvaluation});
                      // if (allowEvaluation) {
                      //   // await updateMergedTeam();
                      // }
                      setState(() {
                        isLoading5 = false;
                      });
                    },
                    title: Text(
                      "Allow Team Evaluation",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.h),
                    ),
                    tileColor: Colors.teal.shade100,
                  ),
            SizedBox(height: 20.h),
            Text(
              "To assign supervisor admin need to get the google sheet link. Then open this link"
              " via browser to assign supervisor.",
              style: TextStyle(
                fontSize: 14.h,
                color: Colors.teal,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.h),
            ElevatedButton.icon(
              onPressed: () async {
                setState(() {
                  isLoading1 = true;
                });
                String url = await ProjectSheetApi.giveAccess();
                // print(url);
                // await Clipboard.setData(ClipboardData(text: url));
                await Share.share(url, subject: 'Proposal File');
                setState(() {
                  isLoading1 = false;
                });
              },
              style: buttonStyle(300, 40),
              label: isLoading1 == false
                  ? const Text("Get proposal file")
                  : const CircularProgressIndicator(
                      color: Colors.white,
                    ),
              icon: const Icon(Icons.file_copy),
            ),
            SizedBox(height: 20.h),
            ElevatedButton.icon(
              onPressed: () {
                Get.defaultDialog(
                    title: "Attention",
                    middleText: "When you move student from CSE-4800 to CSE-4801. Please go to the"
                        " sheet and remove the drop or failed student manually.",
                    titleStyle: const TextStyle(color: Colors.red),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Get.back();
                          Get.defaultDialog(
                              title: "Attention",
                              middleText:
                                  'To move 4800 data to 4801. 4801 current data will be replaced '
                                  'with 4800 data.',
                              titleStyle: const TextStyle(color: Colors.red),
                              actions: [
                                TextButton(
                                  onPressed: () async {
                                    setState(() {
                                      isLoading2 = true;
                                    });
                                    await dataBaseMethods.deleteProposal('CSE-4801');
                                    await ProjectSheetApi.shift4800();
                                    // await dataBaseMethods.moveData();
                                    setState(() {
                                      isLoading2 = false;
                                    });
                                    Get.back();
                                  },
                                  child: const Text("Yes"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: const Text("No"),
                                ),
                              ]);
                        },
                        child: const Text("OK"),
                      ),
                    ]);
              },
              style: buttonStyle(300, 40),
              label: isLoading2 == false
                  ? const Text("Move 4800 to 4801")
                  : const CircularProgressIndicator(
                      color: Colors.white,
                    ),
              icon: const Icon(Icons.move_up),
            ),
            SizedBox(height: 20.h),
            ElevatedButton.icon(
              onPressed: () {
                Get.defaultDialog(
                    title: "Attention",
                    middleText: 'Are you sure to remove all previous proposal data and marks. '
                        'This process takes time so please do not exit until process will finish',
                    actions: [
                      TextButton(
                        onPressed: () async {
                          setState(() {
                            isLoading4 = true;
                          });
                          await dataBaseMethods.deleteProposal('CSE-3300');
                          await ProjectSheetApi.clearProposalData("CSE-3300");
                          await dataBaseMethods.deleteProposal('CSE-4800');
                          await ProjectSheetApi.clearProposalData("CSE-4800");
                          // await dataBaseMethods.deleteProposal('CSE-3300-request');
                          await ProjectSheetApi.clearProposalData("CSE-3300-team-request");
                          // await dataBaseMethods.deleteProposal('CSE-4800-request');
                          await ProjectSheetApi.clearProposalData("CSE-4800-team-request");

                          await dataBaseMethods.deleteMarkedList();
                          setState(() {
                            isLoading4 = false;
                          });
                          Get.back();
                        },
                        child: const Text("Yes"),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: const Text("No"),
                      ),
                    ]);
              },
              style: buttonStyle(300, 40),
              label: isLoading4 == false
                  ? const Text("Clear All Proposal Data")
                  : const CircularProgressIndicator(

                      color: Colors.white,
                    ),
              icon: const Icon(Icons.clear),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
