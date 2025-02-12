import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:teamlead/v2/core/utils/logger/logger.dart';
import 'package:teamlead/v2/modules/admin/proposal_setting/controller/proposal_setting_controller.dart';
import 'package:teamlead/v2/modules/admin/proposal_setting/model/proposal_setting_model.dart';

class ProposalSetting extends StatefulWidget {
  const ProposalSetting({super.key});

  @override
  State<ProposalSetting> createState() => _ProposalSettingState();
}

class _ProposalSettingState extends State<ProposalSetting> {
  final _proposalSettingController = Get.find<ProposalSettingController>();

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
        ],
      ),
    );
  }
}
