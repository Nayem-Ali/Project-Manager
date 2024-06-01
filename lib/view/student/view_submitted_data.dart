import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ViewSubmittedData extends StatefulWidget {
  const ViewSubmittedData({Key? key}) : super(key: key);

  @override
  State<ViewSubmittedData> createState() => _ViewSubmittedDataState();
}

class _ViewSubmittedDataState extends State<ViewSubmittedData> {
  dynamic teamInfo = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Submitted Proposal"),
        ),
        body: Column(
          children: [
            // Text(teamInfo.toString()),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              padding: const EdgeInsets.all(10),
              width: Get.size.width,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  gradient: LinearGradient(colors: [Colors.greenAccent, Colors.grey])),
              child: Text(
                teamInfo['title'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.h,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              padding: const EdgeInsets.all(10),
              width: Get.size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(50.r)),
                  gradient: const LinearGradient(colors: [Colors.greenAccent, Colors.grey])),
              child: Text(
                teamInfo['link'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              padding: const EdgeInsets.all(10),
              width: Get.size.width,
              decoration:  BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(50.r)),
                  gradient: const LinearGradient(colors: [Colors.greenAccent, Colors.grey])),
              child: Text(
                "Preferred Supervisor: ${teamInfo['preference']}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              padding: const EdgeInsets.all(10),
              width: Get.size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20.r)),
                  gradient: const LinearGradient(colors: [Colors.cyan, Colors.tealAccent])),
              child: Text(
                teamInfo['projectType'],
                style:  TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
                textAlign: TextAlign.center,
              ),
            ),
            if (teamInfo.containsKey('id1'))
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                width: Get.size.width,
                decoration: BoxDecoration(border: Border.all()),
                child: Column(
                  children: [
                    Text(
                      "Name: ${teamInfo["name1"]}",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Student ID: ${teamInfo["id1"]}",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "CGPA: ${teamInfo["cgpa1"]}",
                      style:  TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Email: ${teamInfo["email1"]}",
                      style:  TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Phone: ${teamInfo["number1"]}",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            if (teamInfo.containsKey('id2'))
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                width: Get.size.width,
                decoration: BoxDecoration(border: Border.all()),
                child: Column(
                  children: [
                    Text(
                      "Name: ${teamInfo["name2"]}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Student ID: ${teamInfo["id2"]}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "CGPA: ${teamInfo["cgpa2"]}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Email: ${teamInfo["email2"]}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Phone: ${teamInfo["number2"]}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            if (teamInfo.containsKey('id3'))
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                width: Get.size.width,
                decoration: BoxDecoration(border: Border.all()),
                child: Column(
                  children: [
                    Text(
                      "Name: ${teamInfo["name3"]}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Student ID: ${teamInfo["id3"]}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "CGPA: ${teamInfo["cgpa3"]}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Email: ${teamInfo["email3"]}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Phone: ${teamInfo["number3"]}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            if (teamInfo.containsKey('id4'))
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                width: Get.size.width,
                decoration: BoxDecoration(
                  border: Border.all(),
                ),
                child: Column(
                  children: [
                    Text(
                      "Name: ${teamInfo["name4"]}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Student ID: ${teamInfo["id4"]}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "CGPA: ${teamInfo["cgpa4"]}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Email: ${teamInfo["email4"]}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Phone: ${teamInfo["number4"]}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}
