import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewSubmittedData extends StatefulWidget {
  const ViewSubmittedData({Key? key}) : super(key: key);

  @override
  State<ViewSubmittedData> createState() => _ViewSubmittedDataState();
}

class _ViewSubmittedDataState extends State<ViewSubmittedData> {
  List<String> proposalData = Get.arguments;

  @override
  Widget build(BuildContext context) {
    List<String> name = proposalData[3].split('\n');
    List<String> id = proposalData[4].split('\n');
    List<String> email = proposalData[5].split('\n');
    List<String> phone = proposalData[6].split('\n');
    List<String> cgpa = proposalData[7].split('\n');
    print(email);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Submitted Proposal"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 12.h),
              Text("Proposal ID: ${proposalData[0]}", style: textStyle()),
              Text(
                "Title: ${proposalData[1]}",
                overflow: TextOverflow.ellipsis,
                style: textStyle(),
              ),
              Text("Team Members: ${proposalData[2]}", style: textStyle()),
              Text(
                proposalData[9] == ""
                    ? "Supervisor: Not Assigned"
                    : "Supervisor: ${proposalData[9]}",
                style: textStyle(),
              ),
              const Divider(
                thickness: 2,
              ),

              for (int i = 0; i < name.length; i++)
                Container(
                  width: Get.width,
                  margin: EdgeInsets.all(10.h),
                  padding: EdgeInsets.all(15.h),
                  decoration: BoxDecoration(border: Border.all()),
                  child: Column(
                    children: [
                      if (name[i] != "")
                        Text(
                          "Name: ${name[i]}",
                          style: textStyle(),
                        ),
                      if (id[i] != "")
                        Text(
                          "Student ID: ${id[i]}",
                          style: textStyle(),
                        ),
                      if (email.length == name.length)
                        Text(
                          "Email: ${email[i]}",
                          style: textStyle(),
                        ),
                      if (phone.length == name.length)
                        Text(
                          "Mobile: ${phone[i]}",
                          style: textStyle(),
                        ),
                      if (cgpa.length == name.length)
                        Text(
                          "CGPA: ${cgpa[i]}",
                          style: textStyle(),
                        ),
                    ],
                  ),
                ),
              // Text(proposalData[10].toString()),
            ],
          ),
        ));
  }
}

textStyle() {
  return GoogleFonts.adamina(fontWeight: FontWeight.bold, fontSize: 13.h);
}
