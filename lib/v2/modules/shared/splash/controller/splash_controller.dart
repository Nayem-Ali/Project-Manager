import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:teamlead/v2/core/database/firebase_db/firebase_handler.dart';
import 'package:teamlead/v2/core/route/route_name.dart';
import 'package:teamlead/v2/core/utils/logger/logger.dart';
import 'package:teamlead/v2/modules/authentication/controller/user_controller.dart';
import 'package:teamlead/v2/modules/authentication/model/student_model.dart';
import 'package:teamlead/v2/modules/authentication/model/teacher_model.dart';


class SplashController extends GetxController {
  final UserController _userController = Get.find<UserController>();

  chooseScreen() async {
    User? currentUser = FirebaseHandler.auth.currentUser;

    if (currentUser == null) {
      debug("USer Not Found");
      Get.toNamed(RouteName.login);
    } else {
      Object? data = await _userController.getUserData(email: currentUser.email!);
      debug(data.runtimeType);
      if (data is TeacherModel) {
        debug("Teacher");
        // Get.to(Teacher());
      } else if (data is StudentModel) {
        Get.offAllNamed(RouteName.studentHome, arguments: data);
        debug("student");
      } else {
        debug("no data found");
        Get.offAllNamed(RouteName.info, arguments: currentUser);
      }
    }
  }

  @override
  void onInit() {
    Timer(const Duration(seconds: 3), () => chooseScreen());
    super.onInit();
  }
}
