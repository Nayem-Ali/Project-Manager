import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teamlead/v2/core/route/route_name.dart';
import 'package:teamlead/v2/core/utils/constant/icons_path.dart';
import 'package:teamlead/v2/modules/widgets/k_gird_item.dart';
import 'package:teamlead/v2/modules/widgets/university_logo.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Project Manager"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const UniversityLogo(),
              SizedBox(
                width: kIsWeb ? 400 : Get.width,
                child: GridView(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.25
                  ),
                  shrinkWrap: true,
                  children: [
                    GridItem(
                      gridImage: IconsPath.proposalSettingIcon,
                      gridText: "Proposal Setting",
                      onTap: () => Get.toNamed(RouteName.proposalSetting),
                    ),
                    GridItem(
                      gridImage: IconsPath.manageAdminIcon,
                      gridText: "Manage Admin",
                      onTap: () => Get.toNamed(RouteName.manageAdmin),
                    ),
                    GridItem(
                      gridImage: IconsPath.teacherRequestIcon,
                      gridText: "Manage Request",
                      onTap: () => Get.toNamed(RouteName.manageRequest),
                    ),
                    GridItem(
                      gridImage: IconsPath.resultGenerationIcon,
                      gridText: "Generate Result",
                      onTap: () => Get.toNamed(RouteName.generateResult),
                    ),
                    GridItem(
                      gridImage: IconsPath.defenseSchedule,
                      gridText: "Generate Schedule",
                      onTap: () => Get.toNamed(RouteName.generateSchedule),
                    ),
                    GridItem(
                      gridImage: IconsPath.viewDocsIcon,
                      gridText: "View Proposals",
                      onTap: () => Get.toNamed(RouteName.viewAllProposal),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Project Committee",
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.primary),
              ),
              Text(
                "Department of CSE",
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.primary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
