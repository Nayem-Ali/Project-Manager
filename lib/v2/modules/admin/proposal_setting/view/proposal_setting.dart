import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:teamlead/v2/core/utils/logger/logger.dart';
import 'package:teamlead/v2/modules/admin/proposal_setting/controller/proposal_setting_controller.dart';
import 'package:teamlead/v2/modules/admin/proposal_setting/model/proposal_setting_model.dart';
import 'package:teamlead/v2/modules/student/proposal/controller/proposal_controller.dart';

class ProposalSetting extends StatefulWidget {
  const ProposalSetting({super.key});

  @override
  State<ProposalSetting> createState() => _ProposalSettingState();
}

class _ProposalSettingState extends State<ProposalSetting> {
  final _proposalSettingController = Get.find<ProposalSettingController>();
  final _proposalController = Get.find<ProposalController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Proposal Setting"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          StreamBuilder(
            stream: _proposalSettingController.getProposalSetting(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                ProposalSettingModel setting =
                    ProposalSettingModel.fromJson(snapshot.data?.data() ?? {});
                String date = DateFormat.yMMMMEEEEd().format(setting.deadline!);
                String time = DateFormat.jm().format(setting.deadline!);
                return Column(
                  children: [
                    Card(
                      elevation: 4,
                      child: ListTile(
                        title: const Text("Proposal Submission Deadline"),
                        subtitle: Text("$date $time"),
                        trailing: IconButton(
                          onPressed: () async {
                            DateTime? pickedTime = await showDatePicker(
                              context: context,
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2050),
                            );
                            if (pickedTime != null) {
                              pickedTime = pickedTime.add(const Duration(hours: 23, minutes: 59));
                              setting.deadline = pickedTime;
                              _proposalSettingController.updateSetting(setting: setting);
                              debug(pickedTime);
                            }
                          },
                          icon: const Icon(Icons.edit),
                        ),
                      ),
                    ),
                    Card(
                      elevation: 4,
                      child: SwitchListTile(
                        title: const Text("Supervisor Preferences Status"),
                        value: setting.allowPreference!,
                        onChanged: (value) {
                          setting.allowPreference = value;
                          _proposalSettingController.updateSetting(setting: setting);
                        },
                      ),
                    ),
                    Card(
                      elevation: 4,
                      child: SwitchListTile(
                        title: const Text("Defense Board Marking Status"),
                        value: setting.allowEvaluation!,
                        onChanged: (value) {
                          setting.allowEvaluation = value;
                          _proposalSettingController.updateSetting(setting: setting);
                        },
                      ),
                    ),
                  ],
                );
              } else {
                return const Align(
                  alignment: Alignment.center,
                  child: Text("Something went wrong"),
                );
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: Get.width,
              child: ElevatedButton(
                onPressed: () async {
                  _proposalSettingController.formatProposal();
                },
                child: const Text("Get Proposal Spreadsheet"),
              ),
            ),
          )
        ],
      ),
    );
  }
}
/**
 *
 * final Workbook proposalBook = Workbook();
    final Worksheet cse3300 = proposalBook.worksheets[0];
    final Worksheet cse4800 = proposalBook.worksheets[1];
    final Worksheet cse4801 = proposalBook.worksheets[2];
    final Worksheet request3300 = proposalBook.worksheets[3];
    final Worksheet request4800 = proposalBook.worksheets[4];

    cse3300.name = "CSE-3300";
    cse4800.name = "CSE-4800";
    cse4801.name = "CSE-4801";
    request3300.name = "CSE-3300-team-request";
    request4800.name = "CSE-4800-team-request";
    await _proposalController.fetchAllProposals(cse3300: true);
    ProposalFormatting()
    .addAllData(proposals: _proposalController.allProposal, sheet: cse3300);
    await _proposalController.fetchAllProposals(cse4800: true);
    ProposalFormatting()
    .addAllData(proposals: _proposalController.allProposal, sheet: cse4800);
    await _proposalController.fetchAllProposals(cse4801: true);
    ProposalFormatting()
    .addAllData(proposals: _proposalController.allProposal, sheet: cse4801);
    await _proposalController.fetchAllProposals(request3300: true);
    ProposalFormatting()
    .addAllData(proposals: _proposalController.allProposal, sheet: request3300);
    await _proposalController.fetchAllProposals(request4800: true);
    ProposalFormatting()
    .addAllData(proposals: _proposalController.allProposal, sheet: request4800);
    proposalBook.dispose();
 */
