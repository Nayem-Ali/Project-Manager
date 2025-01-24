import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:teamlead/v2/core/database/firebase_db/firebase_handler.dart';
import 'package:teamlead/v2/core/route/route_name.dart';
import 'package:teamlead/v2/core/utils/logger/logger.dart';


class SplashController extends GetxController{


  chooseScreen() async {
    User? currentUser = FirebaseHandler.auth.currentUser;

    if(currentUser == null){
      debug("USer Not Found");
      Get.toNamed(RouteName.login);
      // go to login Screen
    } else {
      debug("User found");
      // get user role
    }
    // print(value);
    // if(value == null){
    //   Get.offAndToNamed(intro);
    // }else{
    //   Get.offAndToNamed(bottomNav);
    // }
  }

  @override
  void onInit() {
    Timer(const Duration(seconds: 3), () => chooseScreen());
    super.onInit();
  }

}