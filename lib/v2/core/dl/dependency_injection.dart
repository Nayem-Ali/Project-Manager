import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:teamlead/firebase_options.dart';
import 'package:teamlead/v2/featuers/shared/splash/controller/splash_controller.dart';

class SetupServices extends Bindings {
  @override
  Future<void> dependencies() async {

    //initializing firebase
    await Firebase.initializeApp(
      name: "Project Manager",
      options: DefaultFirebaseOptions.currentPlatform,
    );

    Get.put<SplashController>(SplashController());
  }

}