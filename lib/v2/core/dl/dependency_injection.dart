import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:teamlead/firebase_options.dart';
import 'package:teamlead/v2/core/api/google_sheet_api/proposal_sheet_api.dart';
import 'package:teamlead/v2/core/api/google_sheet_api/result_sheet_api.dart';
import 'package:teamlead/v2/core/utils/logger/logger.dart';
import 'package:teamlead/v2/modules/authentication/controller/auth_controller.dart';
import 'package:teamlead/v2/modules/authentication/controller/user_controller.dart';
import 'package:teamlead/v2/modules/shared/splash/controller/splash_controller.dart';
import 'package:teamlead/v2/modules/student/proposal/controller/proposal_controller.dart';

class SetupServices extends Bindings {
  @override
  Future<void> dependencies() async {
    //initializing firebase
    await Firebase.initializeApp(
      name: "Project Manager",
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // initializing proposal worksheet
    await Get.putAsync<ProposalSheetAPI>(() async {
      ProposalSheetAPI proposalSheetAPI = ProposalSheetAPI();
      await proposalSheetAPI.initialize();
      debug(proposalSheetAPI.cse3300);
      return proposalSheetAPI;
    });
    // initializing result worksheets
    await Get.putAsync<ResultSheetAPI>(() async {
      ResultSheetAPI resultSheetAPI = ResultSheetAPI();
      await resultSheetAPI.initialize();
      return resultSheetAPI;
    });

    Get.put<AuthController>(AuthController());
    Get.put<UserController>(UserController());
    Get.put<SplashController>(SplashController());
    Get.put<ProposalController>(ProposalController());
  }
}
