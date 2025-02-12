import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teamlead/v2/core/utils/logger/logger.dart';
import 'package:teamlead/v2/core/utils/validators/validators.dart';
import 'package:teamlead/v2/modules/student/proposal/model/proposal_model.dart';
import 'package:teamlead/v2/modules/shared/marking/model/marking_model.dart';
import 'package:teamlead/v2/modules/widgets/k_proposal_view.dart';

class Marking extends StatefulWidget {
  const Marking({super.key, required this.proposal, required this.doesBoard});

  final ProposalModel proposal;
  final bool doesBoard;

  @override
  State<Marking> createState() => _MarkingState();
}

class _MarkingState extends State<Marking> {
  final _formKey = GlobalKey<FormState>();
  RxList<TextEditingController> criteria1 = RxList([]);
  RxList<TextEditingController> criteria2 = RxList([]);
  RxList<bool> doesAbsent = RxList([]);
  RxList<double> totalMarks = RxList([]);

  @override
  void initState() {
    for (int i = 0; i < widget.proposal.totalMembers!; i++) {
      doesAbsent.add(false);
      totalMarks.add(0);
      criteria1.add(TextEditingController());
      criteria2.add(TextEditingController());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.proposal.title}"),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            Get.bottomSheet(
              isScrollControlled: true,
              KProposalView(proposal: widget.proposal)
            );
          }, icon: const Icon(Icons.remove_red_eye_outlined))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Flexible(
              child: Form(
                key: _formKey,
                child: ListView.builder(
                  itemCount: widget.proposal.members?.length ?? 0,
                  itemBuilder: (context, index) {
                    Member member = widget.proposal.members![index];
                    return Obx(
                      () => Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.green.shade100, Colors.teal.shade200],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: ListTile(
                              title: Text("${member.name}"),
                              subtitle: Text("${member.studentId}"),
                              trailing: Column(
                                children: [
                                  const Text("Marks as Absent"),
                                  Flexible(
                                    child: Switch(
                                      value: doesAbsent[index],
                                      onChanged: (value) {
                                        criteria1[index].text = "0";
                                        criteria2[index].text = "0";
                                        totalMarks[index] = 0;
                                        doesAbsent[index] = value;
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          ListTile(
                            title: Center(
                              child: Text(
                                  "Total marks obtained ${totalMarks[index]} out of ${widget
                                      .doesBoard ? 60 : 40}"),
                            ),
                          ),
                          if (!doesAbsent[index])
                            Row(
                              children: [
                                Flexible(
                                  child: TextFormField(
                                    controller: criteria1[index],
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      totalMarks[index] =
                                          (double.tryParse(criteria1[index].text.trim()) ?? 0) +
                                              (double.tryParse(criteria2[index].text.trim()) ?? 0);
                                    },
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      helperText: "",
                                      labelText: "Criteria - 1",
                                    ),
                                    validator: widget.doesBoard
                                        ? Validators.defenseMarkValidator
                                        : Validators.supervisorMarkValidator,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Flexible(
                                  child: TextFormField(
                                    controller: criteria2[index],
                                    onChanged: (value) {
                                      totalMarks[index] =
                                          (double.tryParse(criteria1[index].text.trim()) ?? 0) +
                                              (double.tryParse(criteria2[index].text.trim()) ?? 0);
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      helperText: "",
                                      labelText: "Criteria - 2",
                                    ),
                                    validator: widget.doesBoard
                                        ? Validators.defenseMarkValidator
                                        : Validators.supervisorMarkValidator,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(
              height: Get.height * 0.06,
              width: Get.width,
              child: ElevatedButton.icon(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    List<IndividualMark> marks = [];
                    for (int i = 0; i < widget.proposal.totalMembers!; i++) {
                      marks.add(IndividualMark(
                          name: "${widget.proposal.members?[i].name}",
                          studentID: "${widget.proposal.members?[i].studentId}",
                          criteria1: double.tryParse(criteria1[i].text.trim()) ?? 0,
                          criteria2: double.tryParse(criteria2[i].text.trim()) ?? 0,
                          total: totalMarks[i]));
                    }
                    MarkingModel boardMark = MarkingModel(
                      proposalTitle: widget.proposal.title ?? "",
                      proposalId: widget.proposal.id ?? 0,
                      evaluatedBy: "",
                      marks: marks,
                    );
                    debug(boardMark.toJson());
                    // TODO: Send it to controller for adding firebase
                  }
                  // BotToast.showText(text: "Mark is added successfully");
                  // Get.back();
                },
                icon: const Icon(Icons.send),
                label: Text(
                  "Evaluate",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
