import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teamlead/View/student/student_home.dart';
import 'package:teamlead/View/teacher/tracher_screen.dart';

import '../main.dart';
import '../services/db_service.dart';
import 'auth/info_screen.dart';

class SelectRoute extends StatefulWidget {
  const SelectRoute({Key? key}) : super(key: key);

  @override
  State<SelectRoute> createState() => _SelectRouteState();
}

class _SelectRouteState extends State<SelectRoute> {
  DataBaseMethods dataBaseMethods = DataBaseMethods();
  dynamic userData = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getData();
  }

  getData() async {
    userData = await dataBaseMethods.getStudent() ?? await dataBaseMethods.getTeacher();

    try{
      if (userData.containsKey('role')) {
        // await compute(callApi, 10);
        // print("role: ${userData['role'].toString()}");
        if (userData['role'].toString() == 'teacher') {
          Get.offAll(const TeacherHomeScreen());
        } else {
          Get.offAll(const StudentScreen());
        }
      } else {
        Get.offAll(const InfoScreen());
      }
    } catch(e){
      Get.offAll(const InfoScreen());
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
