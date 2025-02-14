import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:teamlead/firebase_options.dart';
import 'package:teamlead/v2/core/api/google_sheet_api/proposal_sheet_api.dart';
import 'package:teamlead/v2/core/api/google_sheet_api/result_sheet_api.dart';
import 'package:teamlead/v2/modules/admin/generate_result/controller/generate_result_controller.dart';
import 'package:teamlead/v2/modules/admin/manage_admin/controller/manage_admin_controller.dart';
import 'package:teamlead/v2/modules/admin/manage_request/controller/manage_request_controller.dart';
import 'package:teamlead/v2/modules/admin/proposal_setting/controller/proposal_setting_controller.dart';
import 'package:teamlead/v2/modules/authentication/controller/auth_controller.dart';
import 'package:teamlead/v2/modules/authentication/controller/user_controller.dart';
import 'package:teamlead/v2/modules/shared/splash/controller/splash_controller.dart';
import 'package:teamlead/v2/modules/student/proposal/controller/proposal_controller.dart';
import 'package:teamlead/v2/modules/teacher/team_evaluation/controller/team_evaluation_controller.dart';

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
    Get.put<TeamEvaluationController>(TeamEvaluationController());
    Get.put<ProposalSettingController>(ProposalSettingController());
    Get.put<ManageAdminController>(ManageAdminController());
    Get.put<ManageRequestController>(ManageRequestController());
    Get.put<GenerateResultController>(GenerateResultController());
  }
}
