import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:teamlead/v2/core/dl/dependency_injection.dart';
import 'package:teamlead/v2/core/route/route_name.dart';
import 'package:teamlead/v2/modules/authentication/view/info.dart';
import 'package:teamlead/v2/modules/authentication/view/login.dart';
import 'package:teamlead/v2/modules/shared/splash/view/splash.dart';
import 'package:teamlead/v2/modules/student/home/view/student_home.dart';
import 'package:teamlead/v2/modules/student/proposal/view/submit_proposal.dart';
import 'package:teamlead/v2/modules/student/proposal/view/view_porposal.dart';

class AppRoute {
  static List<GetPage> getPages = [
    GetPage(
      name: RouteName.splash,
      page: () => const Splash(),
      binding: SetupServices(),
    ),
    GetPage(
      name: RouteName.login,
      page: () => const Login(),
    ),
    GetPage(
      name: RouteName.info,
      page: () => Info(user: Get.arguments),
    ),
    GetPage(
      name: RouteName.studentHome,
      page: () => StudentHome(student: Get.arguments),
    ),
    GetPage(
      name: RouteName.submitProposal,
      page: () => SubmitProposal(doesRequest: Get.arguments),
      binding: SetupServices(),
    ),
    GetPage(
      name: RouteName.viewProposal,
      page: () => const ViewProposal(),
      binding: SetupServices(),
    ),
  ];
}
