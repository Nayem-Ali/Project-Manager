import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:teamlead/Widget/buttonStyle.dart';
import 'package:teamlead/services/db_service.dart';
import 'package:teamlead/services/push_notification.dart';
import 'package:teamlead/view/teacher/view_announcement.dart';

class Announcement extends StatefulWidget {
  const Announcement({Key? key}) : super(key: key);

  @override
  State<Announcement> createState() => _AnnouncementState();
}

class _AnnouncementState extends State<Announcement> {
  DataBaseMethods dataBaseMethods = DataBaseMethods();
  TextEditingController subject = TextEditingController();
  TextEditingController body = TextEditingController();
  TextEditingController link = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

  final formKey = GlobalKey<FormState>();

  List<String> teachersEmail = [];
  List<String> studentEmail = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    teachersEmail = await dataBaseMethods.getAllTeacherEmail();
    studentEmail = await dataBaseMethods.getAllStudentEmail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Announcement"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Get.to(const ViewAnnouncement());
            },
            icon: const Icon(Icons.notification_important),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(10),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: subject,
                  minLines: null,
                  maxLines: null,
                  decoration: const InputDecoration(
                    label: Text("Subject"),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.trim().isEmpty) return "Enter subject of announcement";
                    return null;
                  },
                ),
                SizedBox(height: 20.h),
                TextFormField(
                  controller: body,
                  minLines: null,
                  maxLines: null,
                  decoration: const InputDecoration(
                    label: Text("Body"),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.trim().isEmpty) return "Enter body of announcement";
                    return null;
                  },
                ),
                SizedBox(height: 20.h),
                TextFormField(
                  controller: link,
                  minLines: null,
                  maxLines: null,
                  decoration: const InputDecoration(
                    label: Text("Attach link if any"),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20.h),
                ElevatedButton.icon(
                  onPressed: () async {
                    if(formKey.currentState!.validate()){
                      Map<String, dynamic> announcement = {
                        "publisher": auth.currentUser!.displayName!,
                        "subject": subject.text.trim(),
                        "body": body.text.trim(),
                        "link": link.text.trim(),
                        "date": DateTime.now(),
                      };
        
                      await dataBaseMethods.publishAnnouncement(announcement);
                      // final fcm = FirebaseMessaging.instance;
                      // await fcm.requestPermission(
                      //   alert: true,
                      //   announcement: true,
                      //   badge: true,
                      //   criticalAlert: false,
                      //   provisional: false,
                      //   sound: true,
                      // );
                      // await fcm.subscribeToTopic('Announcement');
        
                      Get.snackbar("Attention", "Your announcement published successfully");
                    }
                  },
                  style: buttonStyle(300, 40),
                  label: const Text("Publish"),
                  icon: const Icon(Icons.publish),
                ),
                // const SizedBox(height:20),
                // Row(
                //   children: [
                //
                //     ElevatedButton(
                //       onPressed: () async {
                //         if (formKey.currentState!.validate()) {
                //           final Email emails = Email(
                //             subject: body.text.trim(),
                //             body: body.text.trim(),
                //             recipients: [teachersEmail[0]],
                //             bcc: teachersEmail,
                //             // attachmentPaths: ['/path/to/attachment.zip'],
                //             isHTML: false,
                //           );
                //
                //           await FlutterEmailSender.send(emails);
                //         }
                //       },
                //       child: const Text("Email to Teachers"),
                //     ),
                //     const Spacer(),
                //     // const SizedBox(height:20),
                //     ElevatedButton(
                //       onPressed: () async {
                //         if (formKey.currentState!.validate()) {
                //           teachersEmail.addAll(studentEmail);
                //           final Email emails = Email(
                //             subject: body.text.trim(),
                //             body: body.text.trim(),
                //             recipients: [teachersEmail[0]],
                //             bcc: teachersEmail,
                //             // attachmentPaths: ['/path/to/attachment.zip'],
                //             isHTML: false,
                //           );
                //
                //           await FlutterEmailSender.send(emails);
                //         }
                //       },
                //       child: const Text("Email to All"),
                //     ),
                //   ],
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
