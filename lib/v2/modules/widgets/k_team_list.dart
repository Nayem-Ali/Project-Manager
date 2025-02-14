import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:teamlead/v2/core/utils/logger/logger.dart';
import 'package:teamlead/v2/modules/student/proposal/model/proposal_model.dart';
import 'package:teamlead/v2/modules/teacher/team_evaluation/controller/team_evaluation_controller.dart';

class KTeamList extends StatefulWidget {
  const KTeamList({
    super.key,
    required this.proposals,
    required this.routeName,
    required this.doesEvaluation,
    this.cse3300 = false,
    this.cse4800 = false,
    this.cse4801 = false,
  });

  final List<ProposalModel> proposals;
  final String routeName;
  final bool cse3300;
  final bool cse4800;
  final bool cse4801;
  final bool doesEvaluation;

  @override
  State<KTeamList> createState() => _KTeamListState();
}

class _KTeamListState extends State<KTeamList> {
  final _evaluationController = Get.find<TeamEvaluationController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: widget.proposals.isEmpty
          ? const Center(child: Text("No Teams Found"))
          : ListView.builder(
              itemCount: widget.proposals.length,
              itemBuilder: (context, index) {
                ProposalModel proposal = widget.proposals[index];
                return StreamBuilder(
                  stream: _evaluationController.getMarkedTeamsList(
                    doesEvaluation: true,
                    title: proposal.title ?? "",
                    cse3300: widget.cse3300,
                    cse4800: widget.cse4800,
                    cse4801: widget.cse4801,
                  ),
                  builder: (context, snapshot) {
                    return Card(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.green.shade100, Colors.teal.shade200],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: ListTile(
                          onTap: () => Get.toNamed(widget.routeName, arguments: proposal),
                          leading: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.black,
                            child: Text(
                              "${proposal.id}",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          title: Text(
                            "${proposal.title}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text("Supervisor: ${proposal.supervisor}"),
                          trailing: (snapshot.data?.docs.length ?? 0) > 0
                              ? const CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    FontAwesomeIcons.clipboardCheck,
                                    color: Colors.green,
                                    size: 20,
                                  ),
                                )
                              : const CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    FontAwesomeIcons.clipboardCheck,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
