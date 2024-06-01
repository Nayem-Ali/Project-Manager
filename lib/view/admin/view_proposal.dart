import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewProposal extends StatefulWidget {
  const ViewProposal({Key? key}) : super(key: key);

  @override
  State<ViewProposal> createState() => _ViewProposalState();
}

class _ViewProposalState extends State<ViewProposal> {
  dynamic teamInfo = Get.arguments;
  int totalMembers = 0;
  List<String> name = [];
  List<String> id = [];
  List<String> email = [];
  List<String> cgpa = [];
  List<String> phone = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllStudentInfo();
  }

  getAllStudentInfo() {
    totalMembers = int.tryParse(teamInfo['Team Members']) ?? 0;
    name = teamInfo['Name'].split('\n');
    id = teamInfo['Student ID'].split('\n');
    email = teamInfo['Email'].split('\n');
    cgpa = teamInfo['CGPA'].split('\n');
    phone = teamInfo['Phone'].split('\n');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Submitted Proposal"),
        ),
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              padding: const EdgeInsets.all(10),
              width: Get.size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20.r)),
                  gradient: const LinearGradient(colors: [Colors.greenAccent, Colors.grey])),
              child: Text(
                teamInfo['Title'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            if(teamInfo['Proposal Drive Link'] !='')
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              padding: const EdgeInsets.all(10),
              width: Get.size.width,
              decoration:  BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(50.r)),
                  gradient: const LinearGradient(colors: [Colors.greenAccent, Colors.grey])),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final Uri url = Uri.parse(teamInfo['Proposal Drive Link']);
                        if (!await launchUrl(url)) {
                        } else {
                          throw "Something went wrong";
                        }
                      },
                      child: Text(
                        teamInfo['Proposal Drive Link'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: null,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      await Clipboard.setData(
                          ClipboardData(text: teamInfo['Proposal Drive Link']));
                    },
                    icon: const Icon(Icons.copy),
                  )
                ],
              ),
            ),
            if(teamInfo['Preferred Supervisor'] != '')
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              padding: const EdgeInsets.all(10),
              width: Get.size.width,
              decoration:  BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(50.r)),
                  gradient: const LinearGradient(colors: [Colors.greenAccent, Colors.tealAccent])),
              child: Column(
                children: [
                  Text(
                    "Preferred Supervisor",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Divider(thickness: 2),
                  Text(
                    teamInfo['Preferred Supervisor'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                    ),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: totalMembers,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    padding: const EdgeInsets.all(10),
                    width: Get.size.width,
                    decoration: BoxDecoration(
                      // borderRadius: const BorderRadius.all(Radius.circular(50)),
                      border: Border.all(),
                      // gradient: LinearGradient(colors: [Colors.greenAccent, Colors.tealAccent]),
                    ),
                    child: Column(
                      children: [
                        if (name.length == totalMembers)
                          Text(
                            "Name: ${name[index].trim()}",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                          ),
                        if (id.length == totalMembers)
                          Text(
                            "Student ID: ${id[index].trim()}",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                          ),
                        if (cgpa.length == totalMembers)
                          Text(
                            "CGPA: ${cgpa[index].trim()}",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                          ),
                        if (email.length == totalMembers)
                          Text(
                            "Email: ${email[index].trim()}",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                          ),
                        if (phone.length == totalMembers)
                          Text(
                            "Phone: ${phone[index].trim()}",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
