import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teamlead/v2/modules/admin/manage_request/controller/manage_request_controller.dart';
import 'package:teamlead/v2/modules/authentication/model/enums.dart';
import 'package:teamlead/v2/modules/authentication/model/teacher_model.dart';
import 'package:teamlead/v2/modules/widgets/k_option_button.dart';
import 'package:teamlead/v2/modules/widgets/k_profile_row.dart';

class ManageRequest extends StatefulWidget {
  const ManageRequest({super.key});

  @override
  State<ManageRequest> createState() => _ManageRequestState();
}

class _ManageRequestState extends State<ManageRequest> {
  Rx<bool> doesPending = Rx<bool>(true);
  Rx<bool> doesRejected = Rx<bool>(false);
  final ManageRequestController _requestController = Get.find<ManageRequestController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Requests"),
        centerTitle: true,
      ),
      body: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OptionButton(
                  onPressed: () {
                    doesPending.value = true;
                    doesRejected.value = false;
                  },
                  optionName: "PENDING",
                  doesFocus: doesPending.value,
                ),
                OptionButton(
                  onPressed: () {
                    doesPending.value = false;
                    doesRejected.value = true;
                  },
                  optionName: "REJECTED",
                  doesFocus: doesRejected.value,
                ),
              ],
            ),
            Expanded(
              child: StreamBuilder(
                stream: doesPending.value
                    ? _requestController.getAllRequestedTeacher()
                    : _requestController.getAllRejectedTeacher(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasData) {
                    List<TeacherModel> teachers = snapshot.data!.docs
                        .map((data) => TeacherModel.fromJson(data.data()))
                        .toList();

                    if (teachers.isEmpty) {
                      return const Center(
                        child: Text(
                          "No requests available.",
                          style: TextStyle(fontSize: 16.0, color: Colors.grey),
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      itemCount: teachers.length,
                      itemBuilder: (context, index) {
                        TeacherModel request = teachers[index];

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          elevation: 3,
                          child: ExpansionTile(
                            initiallyExpanded: false,
                            title: Text(
                              request.name ?? "Unknown",
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(request.email ?? "No email"),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    KProfileRow(
                                      title: "Initial",
                                      value: request.initial ?? "N/A",
                                      icon: Icons.badge_outlined,
                                    ),
                                    KProfileRow(
                                      title: "Designation",
                                      value: request.designation ?? "N/A",
                                      icon: Icons.work_outline,
                                    ),
                                    KProfileRow(
                                      title: "Email",
                                      value: request.email ?? "N/A",
                                      icon: Icons.email_outlined,
                                    ),
                                    const SizedBox(height: 10.0),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text("ACKNOWLEDGEMENT"),
                                                  content: Text(
                                                    "Are sure to approve ${request.name} as "
                                                    "Teacher",
                                                  ),
                                                  actions: [
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        request.status = RequestStatus.approved;
                                                        _requestController.updateStatus(
                                                          newTeacher: request,
                                                        );
                                                        Get.back();
                                                      },
                                                      child: const Text("YES"),
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        Get.back();
                                                      },
                                                      child: const Text("NO"),
                                                    )
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: const Text("APPROVE"),
                                        ),
                                        if (doesPending.value)
                                          ElevatedButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: const Text("ACKNOWLEDGEMENT"),
                                                    content: Text(
                                                      "Are sure to reject ${request.name} as "
                                                          "Teacher",
                                                    ),
                                                    actions: [
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          request.status = RequestStatus.rejected;
                                                          _requestController.updateStatus(
                                                            newTeacher: request,
                                                          );
                                                          Get.back();
                                                        },
                                                        child: const Text("YES"),
                                                      ),
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          Get.back();
                                                        },
                                                        child: const Text("NO"),
                                                      )
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.redAccent,
                                            ),
                                            child: const Text("REJECT"),
                                          )
                                        else
                                          ElevatedButton(
                                            onPressed: () {
                                              // Add Reject logic
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.redAccent,
                                            ),
                                            child: const Text("DELETE"),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: Text(
                        "Failed to load requests.",
                        style: TextStyle(fontSize: 16.0, color: Colors.red),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
