import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:get/get.dart';
import 'package:teamlead/View/teacher/view_mark.dart';
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
                name[i],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
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
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            padding: const EdgeInsets.all(10),
            width: Get.size.width,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                gradient: LinearGradient(colors: [Colors.greenAccent, Colors.grey])),
            child: Text(
              teamInfo['Title'],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          teamInfo['Proposal Drive Link'] != ''
              ? Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  padding: const EdgeInsets.all(10),
                  width: Get.size.width,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      gradient: LinearGradient(colors: [Colors.greenAccent, Colors.grey])),
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
                          "Name: ${name[index]}",
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      if (id.length == totalMembers)
                        Text(
                          "Student ID: ${id[index]}",
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      if (cgpa.length == totalMembers)
                        Text(
                          "CGPA: ${cgpa[index]}",
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      if (email.length == totalMembers)
                        Text(
                          "Email: ${email[index]}",
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      if (phone.length == totalMembers)
                        Text(
                          "Phone: ${phone[index]}",
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: selectNumber,
                label: const Text("Call"),
                icon: const Icon(
                  Icons.call,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () async {
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
                label: const Text("Email"),
                icon: const Icon(Icons.email),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Get.to(const ViewMark(), arguments: [teamInfo, Get.arguments[1]]);
                },
                icon: const Icon(Icons.bookmark_added_sharp),
                label: const Text("Marking"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
