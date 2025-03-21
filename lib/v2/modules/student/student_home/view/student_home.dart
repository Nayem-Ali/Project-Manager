import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:teamlead/v2/core/route/route_name.dart';
import 'package:teamlead/v2/core/utils/constant/icons_path.dart';
import 'package:teamlead/v2/core/utils/constant/urls.dart';
import 'package:teamlead/v2/core/utils/reusable_method/link_handler.dart';
import 'package:teamlead/v2/modules/admin/proposal_setting/controller/proposal_setting_controller.dart';
import 'package:teamlead/v2/modules/authentication/model/student_model.dart';
import 'package:teamlead/v2/modules/shared/profile/view/profile_view.dart';
import 'package:teamlead/v2/modules/student/student_home/controller/student_home_controller.dart';
import 'package:teamlead/v2/modules/student/student_home/model/proposal_credential_model.dart';
import '../../../widgets/k_gird_item.dart';
import 'components/text_card.dart';

class StudentHome extends StatefulWidget {
  const StudentHome({super.key, required this.student});

  final StudentModel student;

  @override
  State<StudentHome> createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  final ProposalSettingController _settingController = Get.find<ProposalSettingController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ProfileView(data: widget.student),
      ),
      appBar: AppBar(
        title: const Text("Project Manager"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Divider(),
                StreamBuilder(
                  stream: _settingController.getProposalSetting(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      ProposalCredentialModel credential = ProposalCredentialModel.fromJson(
                        snapshot.data?.data() ?? {},
                      );
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.timelapse,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "Deadline: ${DateFormat.yMMMEd().format(credential.deadline)} ${DateFormat.jm().format(credential.deadline)}",
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(color: Colors.teal),
                          ),
                        ],
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
                const Divider(),
                SizedBox(
                  width: kIsWeb ? 400 : Get.width,
                  child: GridView(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    shrinkWrap: true,
                    children: [
                      GridItem(
                        gridImage: IconsPath.viewDocsIcon,
                        gridText: "View Proposal(s)",
                        onTap: () => Get.toNamed(RouteName.viewProposal),
                      ),
                      GridItem(
                        gridImage: IconsPath.submitDocsIcon,
                        gridText: "Submit Proposal",
                        onTap: () => Get.toNamed(RouteName.submitProposal, arguments: false),
                      ),
                      GridItem(
                        gridImage: IconsPath.requestTeamIcon,
                        gridText: "Team Request",
                        onTap: () => Get.toNamed(RouteName.submitProposal, arguments: true),
                      ),
                      GridItem(
                        gridImage: IconsPath.downloadIcon,
                        gridText: "Get Proposal Template",
                        onTap: () => LinkHandler.shareLink(Urls.templateUrl),
                      ),
                    ],
                  ),
                ),
                const TextCard(
                  text: "Please make sure only one member from a team submit proposal.",
                  color: Colors.redAccent,
                ),
                const TextCard(
                  text: 'If you are unable to make a team, you can give your '
                      'details by tapping on the "Team Request" button. Project Committee'
                      ' will form a team for you.',
                  color: Colors.blueAccent,
                ),
                const TextCard(
                  text: "Get the download link of proposal template. If you don't have any.",
                  color: Colors.green,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
