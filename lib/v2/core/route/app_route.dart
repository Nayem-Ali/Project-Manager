import 'package:get/get.dart';
import 'package:teamlead/v2/core/dl/dependency_injection.dart';
import 'package:teamlead/v2/core/route/route_name.dart';
import 'package:teamlead/v2/modules/authentication/view/info.dart';
import 'package:teamlead/v2/modules/authentication/view/login.dart';
import 'package:teamlead/v2/modules/shared/marking/view/marking.dart';
import 'package:teamlead/v2/modules/shared/profile/view/components/about_us.dart';
import 'package:teamlead/v2/modules/shared/splash/view/splash.dart';
import 'package:teamlead/v2/modules/student/home/view/student_home.dart';
import 'package:teamlead/v2/modules/student/proposal/view/submit_proposal.dart';
import 'package:teamlead/v2/modules/student/proposal/view/view_porposal.dart';
import 'package:teamlead/v2/modules/teacher/home/view/teacher_home.dart';
import 'package:teamlead/v2/modules/teacher/my_teams/view/my_teams.dart';
import 'package:teamlead/v2/modules/teacher/team_evaluation/view/team_evaluation.dart';

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
    GetPage(
      name: RouteName.aboutUs,
      page: () => const AboutUs(),
    ),
    GetPage(
      name: RouteName.teacherHome,
      page: () => TeacherHome(teacher: Get.arguments),
    ),
    GetPage(
      name: RouteName.allTeams,
      page: () => const TeamEvaluation(),
      binding: SetupServices(),
    ),
    GetPage(
      name: RouteName.boardMarking,
      page: () => Marking(
        proposal: Get.arguments,
        doesBoard: true,
      ),
    ),
    GetPage(
      name: RouteName.supervisorMarking,
      page: () => Marking(
        proposal: Get.arguments,
        doesBoard: false,
      ),
    ),
    GetPage(
      name: RouteName.myTeams,
      page: () => const MyTeams(),
      binding: SetupServices(),
    ),
  ];
}
