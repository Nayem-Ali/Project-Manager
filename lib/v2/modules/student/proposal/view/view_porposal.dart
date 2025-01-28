import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:teamlead/v2/modules/authentication/controller/user_controller.dart';
import 'package:teamlead/v2/modules/student/proposal/controller/proposal_controller.dart';
import 'package:teamlead/v2/modules/widgets/k_proposal_view.dart';
import 'package:teamlead/v2/modules/widgets/option_button.dart';

class ViewProposal extends StatefulWidget {
  const ViewProposal({super.key});

  @override
  State<ViewProposal> createState() => _ViewProposalState();
}

class _ViewProposalState extends State<ViewProposal> {
  Rx<bool> cse3300 = Rx<bool>(true);
  Rx<bool> cse4800 = Rx<bool>(false);
  Rx<bool> cse4801 = Rx<bool>(false);
  final _proposalController = Get.find<ProposalController>();
  final _userController = Get.find<UserController>();
  Rx<bool> doesFound = Rx<bool>(false);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      doesFound.value = await _proposalController.filterMyProposal(
          studentId: _userController.student.value.id!,
          cse3300: cse3300.value
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Proposal"),
        centerTitle: true,
      ),
      body: Obx(
        () => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OptionButton(
                  onPressed: () async {
                    cse3300.value = true;
                    cse4800.value = false;
                    cse4801.value = false;
                    doesFound.value = await _proposalController.filterMyProposal(
                      cse3300: cse3300.value,
                      studentId: _userController.student.value.id ?? "0",
                    );
                  },
                  optionName: "CSE-3300",
                  doesFocus: cse3300.value,
                ),
                OptionButton(
                  onPressed: () async {
                    cse3300.value = false;
                    cse4800.value = true;
                    cse4801.value = false;
                    doesFound.value = await _proposalController.filterMyProposal(
                      cse4800: cse4800.value,
                      studentId: _userController.student.value.id ?? "0",
                    );
                  },
                  optionName: "CSE-4800",
                  doesFocus: cse4800.value,
                ),
                OptionButton(
                  onPressed: () async {
                    cse3300.value = false;
                    cse4800.value = false;
                    cse4801.value = true;
                    doesFound.value = await _proposalController.filterMyProposal(
                      cse4801: cse4801.value,
                      studentId: _userController.student.value.id ?? "0",
                    );
                  },
                  optionName: "CSE-4801",
                  doesFocus: cse4801.value,
                ),
              ],
            ),
            if (doesFound.value)
              KProposalView(proposal: _proposalController.proposal.value)
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
