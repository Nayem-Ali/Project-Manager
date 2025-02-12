import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teamlead/v2/core/route/route_name.dart';
import 'package:teamlead/v2/core/utils/constant/icons_path.dart';
import 'package:teamlead/v2/modules/authentication/model/enums.dart';
import 'package:teamlead/v2/modules/authentication/model/teacher_model.dart';
import 'package:teamlead/v2/modules/shared/profile/view/profile_view.dart';
import 'package:teamlead/v2/modules/widgets/k_gird_item.dart';
import 'package:teamlead/v2/modules/widgets/university_logo.dart';

class TeacherHome extends StatefulWidget {
  const TeacherHome({super.key, required this.teacher});

  final TeacherModel teacher;

  @override
  State<TeacherHome> createState() => _TeacherHomeState();
}

class _TeacherHomeState extends State<TeacherHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Project Manager"),
        centerTitle: true,
        actions: [
          widget.teacher.role == Roles.admin
              ? IconButton(
                  onPressed: () {
                    Get.toNamed(RouteName.adminHome);
                  },
                  icon: const Icon(Icons.admin_panel_settings),
                )
              : const SizedBox.shrink()
        ],
      ),
      drawer: Drawer(
        child: ProfileView(data: widget.teacher),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const UniversityLogo(),
            Flexible(
              child: GridView(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                shrinkWrap: true,
                children: [
                  GridItem(
                    gridImage: IconsPath.myTeamsIcon,
                    gridText: "My Teams",
                    onTap: () => Get.toNamed(RouteName.myTeams),
                  ),
                  GridItem(
                    gridImage: IconsPath.teamEvaluationIcon,
                    gridText: "Team Evaluation",
                    onTap: () => Get.toNamed(RouteName.allTeams),
                  ),
                  GridItem(
                    gridImage: IconsPath.defenseSchedule,
                    gridText: "Defense Schedule",
                    onTap: () {},
                  ),
                  GridItem(
                    gridImage: IconsPath.announcement,
                    gridText: "Announcement",
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
