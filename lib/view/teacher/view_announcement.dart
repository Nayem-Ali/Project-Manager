import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../services/db_service.dart';

class ViewAnnouncement extends StatefulWidget {
  const ViewAnnouncement({Key? key}) : super(key: key);

  @override
  State<ViewAnnouncement> createState() => _ViewAnnouncementState();
}

class _ViewAnnouncementState extends State<ViewAnnouncement> {
  DataBaseMethods dataBaseMethods = DataBaseMethods();
  dynamic announcement = [];
  List<String> teachersEmail = [];
  List<String> studentEmail = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    announcement = await dataBaseMethods.getAnnouncement();
    teachersEmail = await dataBaseMethods.getAllTeacherEmail();
    studentEmail = await dataBaseMethods.getAllStudentEmail();
    String? email = FirebaseAuth.instance.currentUser!.email;
    dynamic temp = List.from(announcement);
    if(studentEmail.contains(email)){
      for(var a in temp){
        if(a['receiver'] == 'teacher'){
          announcement.remove(a);
        }
      }
    }
    setState(() {});
  }

  viewMessage(Map<String, dynamic> data) {
    Get.bottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.white,
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Text(
              "Subject: ${data['subject']}",
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.h),
            Text(
              data["body"],
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            // Row(
            //   children: [
            //     const Spacer(),
            //     ElevatedButton(
            //       onPressed: () async {
            //         final Email emails = Email(
            //           subject: data["subject"],
            //           body: data['body'],
            //           recipients: [teachersEmail[0]],
            //           bcc: teachersEmail,
            //           // attachmentPaths: ['/path/to/attachment.zip'],
            //           isHTML: false,
            //         );
            //
            //         await FlutterEmailSender.send(emails);
            //       },
            //       child: const Text("Sent to Teachers"),
            //     ),
            //     const Spacer(),
            //     // const SizedBox(height:20),
            //     ElevatedButton(
            //       onPressed: () async {
            //         teachersEmail.addAll(studentEmail);
            //         final Email emails = Email(
            //           subject: data["subject"],
            //           body: data['body'],
            //           recipients: [teachersEmail[0]],
            //           bcc: teachersEmail,
            //           // attachmentPaths: ['/path/to/attachment.zip'],
            //           isHTML: false,
            //         );
            //
            //         await FlutterEmailSender.send(emails);
            //       },
            //       child: const Text("Sent to All"),
            //     ),
            //     const Spacer(),
            //   ],
            // )
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Announcement History"),
          centerTitle: true,
        ),
        body: announcement.isNotEmpty
            ? ListView.builder(
                itemCount: announcement.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      viewMessage(announcement[index]);
                    },
                    child: Card(
                      color: Colors.yellowAccent.shade100,
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text("${index + 1}"),
                        ),
                        title: Text(announcement[index]['subject']),
                        subtitle: Text("Publisher: ${announcement[index]["publisher"]}"),
                      ),
                    ),
                  );
                },
              )
            : const Center(
                child: Text("No Announcement"),
              ),
      ),
    );
  }
}
