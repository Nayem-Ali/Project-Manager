import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teamlead/v2/modules/authentication/controller/user_controller.dart';
import 'package:teamlead/v2/modules/student/proposal/controller/proposal_controller.dart';
import 'package:teamlead/v2/modules/student/proposal/model/proposal_model.dart';
import 'package:teamlead/v2/modules/widgets/k_proposal_view.dart';
import 'package:teamlead/v2/modules/widgets/k_option_button.dart';
import 'package:teamlead/v2/modules/widgets/k_team_list.dart';

class ViewAllProposal extends StatefulWidget {
  const ViewAllProposal({super.key});

  @override
  State<ViewAllProposal> createState() => _ViewAllProposalState();
}

class _ViewAllProposalState extends State<ViewAllProposal> {
  Rx<bool> cse3300 = Rx<bool>(true);
  Rx<bool> cse4800 = Rx<bool>(false);
  Rx<bool> cse4801 = Rx<bool>(false);
  final _proposalController = Get.find<ProposalController>();

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
        title: const Text("Proposals"),
        centerTitle: true,
      ),
      body: Obx(
        () => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
            if (_proposalController.allProposal.isNotEmpty)
              Flexible(
                child: ListView.builder(
                  itemCount: _proposalController.allProposal.length,
                  itemBuilder: (context, index) {
                    ProposalModel proposal = _proposalController.allProposal[index];
                    return Card(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.green.shade100, Colors.teal.shade200],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: ExpansionTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child: Text(
                              "${proposal.id}",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          title:  Text("${proposal.title}"),
                          children: [KProposalView(proposal: proposal)],
                        ),
                      ),
                    );
                  },
                ),
              )
            else
              SizedBox(
                height: Get.height * 0.8,
                child: const Center(child: Text("No Data Found")),
              )
          ],
        ),
      ),
    );
  }
}
