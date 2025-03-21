import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teamlead/v2/core/route/route_name.dart';
import 'package:teamlead/v2/modules/authentication/controller/user_controller.dart';
import 'package:teamlead/v2/modules/student/proposal/controller/proposal_controller.dart';
import 'package:teamlead/v2/modules/widgets/k_option_button.dart';
import 'package:teamlead/v2/modules/widgets/k_team_list.dart';

class MyTeams extends StatefulWidget {
  const MyTeams({super.key});

  @override
  State<MyTeams> createState() => _MyTeamsState();
}

class _MyTeamsState extends State<MyTeams> {
  RxBool cse3300 = RxBool(true);
  RxBool cse4800 = RxBool(false);
  RxBool cse4801 = RxBool(false);

  final ProposalController _proposalController = Get.find<ProposalController>();
  final UserController _userController = Get.find<UserController>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      BotToast.showLoading();
      await _proposalController.fetchAllProposals(cse3300: cse3300.value);
      BotToast.closeAllLoading();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Teams"),
        centerTitle: true,
      ),
      body: Obx(
        () => Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  OptionButton(
                    onPressed: () async {
                      cse3300.value = true;
                      cse4800.value = false;
                      cse4801.value = false;
                      BotToast.showLoading();
                      await _proposalController.fetchAllProposals(cse3300: cse3300.value);
                      BotToast.closeAllLoading();
                    },
                    optionName: "CSE-3300",
                    doesFocus: cse3300.value,
                  ),
                  OptionButton(
                    onPressed: () async {
                      cse3300.value = false;
                      cse4800.value = true;
                      cse4801.value = false;
                      BotToast.showLoading();
                      await _proposalController.fetchAllProposals(cse4800: cse4800.value);
                      BotToast.closeAllLoading();
                    },
                    optionName: "CSE-4800",
                    doesFocus: cse4800.value,
                  ),
                  OptionButton(
                    onPressed: () async {
                      cse3300.value = false;
                      cse4800.value = false;
                      cse4801.value = true;
                      BotToast.showLoading();
                      await _proposalController.fetchAllProposals(cse4801: cse4801.value);
                      BotToast.closeAllLoading();
                    },
                    optionName: "CSE-4801",
                    doesFocus: cse4801.value,
                  ),
                ],
              ),
            ),
            Flexible(
              child: KTeamList(
                proposals: _proposalController.allProposal
                    .where(
                        (proposal) => proposal.supervisor == _userController.teacher.value.initial)
                    .toList(),
                routeName: RouteName.supervisorMarking,
                doesBoard: false,
                cse3300: cse3300.value,
                cse4800: cse4800.value,
                cse4801: cse4801.value,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
