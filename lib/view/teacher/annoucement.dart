import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:get/get.dart';
import 'package:teamlead/services/db_service.dart';
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
    return SafeArea(
      child: Scaffold(
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
        body: Container(
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
                const SizedBox(height: 20),
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
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        if(formKey.currentState!.validate()){
                          Map<String, String> announcement = {
                            "publisher": auth.currentUser!.displayName!,
                            "subject": subject.text.trim(),
                            "body": body.text.trim(),
                            "receiver": "teacher"
                          };
                          await dataBaseMethods.publishAnnouncement(announcement);
                          Get.snackbar("Attention", "Your announcement published successfully");
                        }
                      },
      
                      child: const Text("Publish to Teachers"),
                    ),
                    // const SizedBox(height:20),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () async {
                        if(formKey.currentState!.validate()){
                          Map<String, String> announcement = {
                            "publisher": auth.currentUser!.displayName!,
                            "subject": subject.text.trim(),
                            "body": body.text.trim(),
                            "receiver": "all"
                          };
                          await dataBaseMethods.publishAnnouncement(announcement);
                          Get.snackbar("Attention", "Your announcement published successfully");
                        }
                      },
                      child: const Text("Publish to All"),
                    ),
                  ],
                ),
                // const SizedBox(height:20),
                Row(
                  children: [
      
                    ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          final Email emails = Email(
                            subject: body.text.trim(),
                            body: body.text.trim(),
                            recipients: [teachersEmail[0]],
                            bcc: teachersEmail,
                            // attachmentPaths: ['/path/to/attachment.zip'],
                            isHTML: false,
                          );
      
                          await FlutterEmailSender.send(emails);
                        }
                      },
                      child: const Text("Email to Teachers"),
                    ),
                    const Spacer(),
                    // const SizedBox(height:20),
                    ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          teachersEmail.addAll(studentEmail);
                          final Email emails = Email(
                            subject: body.text.trim(),
                            body: body.text.trim(),
                            recipients: [teachersEmail[0]],
                            bcc: teachersEmail,
                            // attachmentPaths: ['/path/to/attachment.zip'],
                            isHTML: false,
                          );
      
                          await FlutterEmailSender.send(emails);
                        }
                      },
                      child: const Text("Email to All"),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
