import 'package:get/get.dart';
import 'package:teamlead/v2/core/dl/dependency_injection.dart';
import 'package:teamlead/v2/core/route/route_name.dart';
import 'package:teamlead/v2/modules/admin/admin_home/view/admin_home.dart';
import 'package:teamlead/v2/modules/admin/generate_result/view/generate_result.dart';
import 'package:teamlead/v2/modules/admin/generate_schedule/view/generate_schedule.dart';
import 'package:teamlead/v2/modules/admin/manage_admin/view/manage_admin.dart';
import 'package:teamlead/v2/modules/admin/manage_request/view/manage_request.dart';
import 'package:teamlead/v2/modules/admin/proposal_setting/view/proposal_setting.dart';
import 'package:teamlead/v2/modules/admin/view_all_proposals/view_all_proposals.dart';
import 'package:teamlead/v2/modules/authentication/view/info.dart';
import 'package:teamlead/v2/modules/authentication/view/login.dart';
import 'package:teamlead/v2/modules/shared/marking/view/marking.dart';
import 'package:teamlead/v2/modules/shared/profile/view/components/about_us.dart';
import 'package:teamlead/v2/modules/shared/splash/view/splash.dart';
import 'package:teamlead/v2/modules/student/proposal/view/submit_proposal.dart';
import 'package:teamlead/v2/modules/student/proposal/view/view_proposal.dart';
import 'package:teamlead/v2/modules/student/student_home/view/student_home.dart';
import 'package:teamlead/v2/modules/teacher/my_teams/view/my_teams.dart';
import 'package:teamlead/v2/modules/teacher/teacher_home/view/teacher_home.dart';
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
      binding: SetupServices(),
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
        proposal: Get.arguments[0],
        course: Get.arguments[1],
        doesBoard: true,
        mark: Get.arguments[2],
      ),
    ),
    GetPage(
      name: RouteName.supervisorMarking,
      page: () => Marking(
        proposal: Get.arguments[0],
        course: Get.arguments[1],
        doesBoard: false,
        mark: Get.arguments[2],
      ),
      binding: SetupServices(),
    ),
    GetPage(
      name: RouteName.myTeams,
      page: () => const MyTeams(),
      binding: SetupServices(),
    ),
    GetPage(
      name: RouteName.adminHome,
      page: () => const AdminHome(),
    ),
    GetPage(
      name: RouteName.proposalSetting,
      page: () => const ProposalSetting(),
    ),
    GetPage(
        name: RouteName.manageAdmin, page: () => const ManageAdmin(), binding: SetupServices()),
    GetPage(
        name: RouteName.manageRequest,
        page: () => const ManageRequest(),
        binding: SetupServices()),
    GetPage(
        name: RouteName.generateResult,
        page: () => const GenerateResult(),
        binding: SetupServices()),
    GetPage(
        name: RouteName.generateSchedule,
        page: () => const GenerateSchedule(),
        binding: SetupServices()),
    GetPage(
        name: RouteName.viewAllProposal,
        page: () => const ViewAllProposal(),
        binding: SetupServices()),
  ];
}
