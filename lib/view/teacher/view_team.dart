import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:teamlead/View/teacher/view_mark.dart';
import 'package:teamlead/Widget/buttonStyle.dart';
import 'package:teamlead/Widget/graidentContainer.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewTeam extends StatefulWidget {
  const ViewTeam({Key? key}) : super(key: key);

  @override
  State<ViewTeam> createState() => _ViewTeamState();
}

class _ViewTeamState extends State<ViewTeam> {
  dynamic teamInfo = Get.arguments[0];
  int totalMembers = 0;
  List<String> name = [];
  List<String> id = [];
  List<String> email = [];
  List<String> cgpa = [];
  List<String> phone = [];

  selectNumber() {
    if (phone.length != totalMembers) {
      Get.showSnackbar(
        const GetSnackBar(
          duration: Duration(seconds: 3),
          message: "No Phone Number Found",
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    Get.dialog(AlertDialog(
      title: const Text("Pick a number to call"),
      actions: [
        for (int i = 0; i < totalMembers; i++)
          Align(
            alignment: Alignment.center,
            child: TextButton(
              onPressed: () async {
                String number = "+88${phone[i]}";
                // await FlutterPhoneDirectCaller.callNumber(number);
                final Uri url = Uri(scheme: 'tel', path: number);
                await launchUrl(url);
              },
              child: Text(
                name[i].trim(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.h,
                ),
              ),
            ),
          ),
      ],
    ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    extractData();
  }

  extractData() {
    totalMembers = int.tryParse(teamInfo['Team Members']) ?? 0;
    name = teamInfo['Name'].split('\n');
    id = teamInfo['Student ID'].split('\n');
    email = teamInfo['Email'].split('\n');
    cgpa = teamInfo['CGPA'].split('\n');
    phone = teamInfo['Phone'].split('\n');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(teamInfo['Title']),
        actions: [
          IconButton(
            onPressed: () async {
              if (email.length != totalMembers) {
                Get.showSnackbar(const GetSnackBar(
                  duration: Duration(seconds: 3),
                  message: "No Email Found",
                  backgroundColor: Colors.red,
                ));
                return;
              }
              final Email emails = Email(
                body: 'Email body',
                subject: 'Email subject',
                recipients: [
                  email[0],
                  email[1],
                  if (totalMembers == 3) email[2],
                  if (totalMembers == 4) email[3]
                ],
                // bcc: ['bcc@example.com'],
                // attachmentPaths: ['/path/to/attachment.zip'],
                isHTML: false,
              );

              await FlutterEmailSender.send(emails);
            },
            icon: const Icon(Icons.email),
          ),
          IconButton(
            onPressed: selectNumber,
            icon: const Icon(Icons.phone),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              teamInfo['Title'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.h,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          teamInfo['Proposal Drive Link'] != ''
              ?
                  Padding(
                    padding: const EdgeInsets.all(8.0),
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
                  )

              : const SizedBox(),
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
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.h),
                        ),
                      if (id.length == totalMembers)
                        Text(
                          "Student ID: ${id[index].trim()}",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.h),
                        ),
                      if (cgpa.length == totalMembers)
                        Text(
                          "CGPA: ${cgpa[index].trim()}",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.h),
                        ),
                      if (email.length == totalMembers)
                        Text(
                          "Email: ${email[index].trim()}",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.h),
                        ),
                      if (phone.length == totalMembers)
                        Text(
                          "Phone: ${phone[index].trim()}",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.h),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Get.to(const ViewMark(), arguments: [teamInfo, Get.arguments[1]]);
            },
            style: buttonStyle(200, 30),
            icon: Icon(size: 25.h, Icons.bookmark_added_sharp),
            label: const Text("Marking"),
          ),
        ],
      ),
    );
  }
}
