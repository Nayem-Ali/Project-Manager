import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:teamlead/view/teacher/notice_view.dart';

import '../../services/db_service.dart';

class ViewAnnouncement extends StatefulWidget {
  const ViewAnnouncement({Key? key}) : super(key: key);

  @override
  State<ViewAnnouncement> createState() => _ViewAnnouncementState();
}

class _ViewAnnouncementState extends State<ViewAnnouncement> {
  DataBaseMethods dataBaseMethods = DataBaseMethods();
  List<Map<String, dynamic>> announcement = [];
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
    announcement.sort((a, b) => b['date'].compareTo(a['date']));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Announcement History"),
        centerTitle: true,
      ),
      body: announcement.isNotEmpty
          ? ListView.builder(
              itemCount: announcement.length,
              itemBuilder: (context, index) {
                DateTime date = announcement[index]["date"].toDate();
                return Card(
                  color: Colors.blueGrey.shade100,
                  child: ListTile(
                    onTap: () {
                      Get.to(() => NoticeView(), arguments: announcement[index]);
                    },

                    title: Text(announcement[index]['subject'], overflow: TextOverflow.ellipsis,),
                    subtitle: Text(
                      "${DateFormat.yMMMEd().format(date)}; ${DateFormat.jm().format(date)}",
                    ),
                  ),
                );
              },
            )
          : const Center(
              child: Text("No Announcement"),
            ),
    );
  }
}
