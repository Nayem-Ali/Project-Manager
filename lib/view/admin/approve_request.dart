import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teamlead/services/db_service.dart';

class ApproveRequest extends StatefulWidget {
  const ApproveRequest({Key? key}) : super(key: key);

  @override
  State<ApproveRequest> createState() => _ApproveRequestState();
}

class _ApproveRequestState extends State<ApproveRequest> {
  DataBaseMethods dataBaseMethods = DataBaseMethods();
  dynamic allTeacherData = [];
  dynamic pending = [];
  dynamic rejected = [];
  bool reject = false;
  bool request = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    allTeacherData = await dataBaseMethods.getAllTeacherData();
    for (int i = 0; i < allTeacherData.length; i++) {
      if (allTeacherData[i]['status'] == 'pending') {
        pending.add(allTeacherData[i]);
      } else if (allTeacherData[i]['status'] == 'rejected') {
        rejected.add(allTeacherData[i]);
      }
    }
    setState(() {});
  }

  viewData(Map<String, dynamic> teacherData) {
    Get.bottomSheet(
        backgroundColor: Colors.white,
        Column(
          children: [
            const Spacer(),
            Text(
              "Name: ${teacherData['name']}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: Get.size.height * 0.02),
            Text(
              "Email: ${teacherData['email']}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: Get.size.height * 0.02),
            Text(
              "Designation: ${teacherData['designation']}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: Get.size.height * 0.02),
            Text(
              "Initial: ${teacherData['initial']}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: Get.size.height * 0.02),
            Text(
              "Request Status: ${teacherData['status'].toString().capitalizeFirst}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: Get.size.height * 0.02),
            ElevatedButton.icon(
              onPressed: () async {
                await dataBaseMethods.approveTeacher(teacherData['email'].toString(), "approved");
                Get.back();
              },
              style: ElevatedButton.styleFrom(minimumSize: Size(Get.size.width * 0.8, 40)),
              label: const Text(
                "Approve",
                style: TextStyle(fontSize: 18),
              ),
              icon: const Icon(Icons.done),
            ),
            SizedBox(height: Get.size.height * 0.02),
            ElevatedButton.icon(
              onPressed: () async {
                await dataBaseMethods.approveTeacher(teacherData['email'].toString(), "rejected");
                Get.back();
              },
              style: ElevatedButton.styleFrom(minimumSize: Size(Get.size.width * 0.8, 40)),
              label: Text(
                "Reject",
                style: TextStyle(fontSize: Get.textScaleFactor * 20),
              ),
              icon: const Icon(Icons.not_interested),
            ),
            const Spacer(),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Pending Request"),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Row(
              children: [
                const Spacer(),
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      request = true;
                      reject = false;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: request ? Colors.greenAccent.shade100 : Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  child: const Text("Pending"),
                ),
                const Spacer(),
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      request = false;
                      reject = true;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: reject ? Colors.redAccent.shade100 : Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  child: const Text("Rejected"),
                ),
                const Spacer(),
              ],
            ),
            if (request)
              pending.length != 0
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: pending.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              viewData(pending[index]);
                            },
                            child: Card(
                              color: Colors.teal.shade100,
                              child: ListTile(
                                title: Text("Name: ${pending[index]['name']}"),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : const Center(
                      child: Text("No Pending Request"),
                    ),
            if (reject)
              rejected.length != 0
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: rejected.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              viewData(rejected[index]);
                            },
                            child: Card(
                              color: Colors.redAccent.shade100,
                              child: ListTile(
                                title: Text("Name: ${rejected[index]['name']}"),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : const Center(
                      child: Text(
                        "No Rejected Request",
                      ),
                    ),
          ],
        ));
  }
}
