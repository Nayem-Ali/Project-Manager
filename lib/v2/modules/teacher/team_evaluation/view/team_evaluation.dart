import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teamlead/v2/core/route/route_name.dart';
import 'package:teamlead/v2/core/utils/logger/logger.dart';
import 'package:teamlead/v2/modules/admin/proposal_setting/controller/proposal_setting_controller.dart';
import 'package:teamlead/v2/modules/admin/proposal_setting/model/proposal_setting_model.dart';
import 'package:teamlead/v2/modules/student/proposal/controller/proposal_controller.dart';
import 'package:teamlead/v2/modules/student/proposal/model/proposal_model.dart';
import 'package:teamlead/v2/modules/teacher/team_evaluation/controller/team_evaluation_controller.dart';
import 'package:teamlead/v2/modules/widgets/k_option_button.dart';
import 'package:teamlead/v2/modules/widgets/k_team_list.dart';

class TeamEvaluation extends StatefulWidget {
  const TeamEvaluation({super.key});

  @override
  State<TeamEvaluation> createState() => _TeamEvaluationState();
}

class _TeamEvaluationState extends State<TeamEvaluation> {
  RxBool cse3300 = RxBool(true);
  RxBool cse4800 = RxBool(false);
  RxBool cse4801 = RxBool(false);
  final ProposalController _proposalController = Get.find<ProposalController>();
  final TeamEvaluationController _evaluationController = Get.find<TeamEvaluationController>();
  final ProposalSettingController _settingController = Get.find<ProposalSettingController>();
  TextEditingController searchController = TextEditingController();

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
        title: const Text("Team Evaluation"),
        centerTitle: true,
      ),
      body: Obx(
        () => Column(
          children: [
            Row(
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: TextFormField(
                controller: searchController,
                onChanged: (value) async {
                  if (value.trim().isEmpty) {
                    BotToast.showLoading();
                    await _proposalController.fetchAllProposals(
                      cse4801: cse4801.value,
                      cse3300: cse3300.value,
                      cse4800: cse4800.value,
                    );
                    BotToast.closeAllLoading();
                  }
                },
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: "Search by Supervisor, Title, ID or Name",
                  suffixIcon: IconButton(
                    onPressed: () {
                      List<ProposalModel> allProposals = _proposalController.allProposal.value;
                      List<ProposalModel> searchResult = _evaluationController.searchTeams(
                        allProposals: allProposals,
                        searchKey: searchController.text.trim(),
                      );
                      debug(searchResult);
                      if (searchResult.isNotEmpty) {
                        _proposalController.allProposal.value = searchResult;
                      }
                    },
                    icon: const Icon(Icons.search),
                  ),
                ),
              ),
            ),
            Flexible(
              child: KTeamList(
                proposals: _proposalController.allProposal.value,
                routeName: RouteName.boardMarking,
                cse3300: cse3300.value,
                cse4800: cse4800.value,
                cse4801: cse4801.value,
                doesEvaluation: true,
              ),
            )
            // Flexible(
            //   child: StreamBuilder(
            //     stream: _settingController.getProposalSetting(),
            //     builder: (context, snapshot) {
            //       if (snapshot.hasData) {
            //         ProposalSettingModel setting =
            //             ProposalSettingModel.fromJson(snapshot.data?.data() ?? {});
            //         return setting.allowEvaluation!
            //             ? KTeamList(
            //                 proposals: _proposalController.allProposal.value,
            //                 routeName: RouteName.boardMarking,
            //                 cse3300: cse3300.value,
            //                 cse4800: cse4800.value,
            //                 cse4801: cse4801.value,
            //                 doesEvaluation: true,
            //               )
            //             : const Center(
            //                 child: Text("Evaluation is not yet started"),
            //               );
            //       } else {
            //         return const SizedBox.shrink();
            //       }
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
