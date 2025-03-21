import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teamlead/v2/core/utils/logger/logger.dart';
import 'package:teamlead/v2/core/utils/validators/validators.dart';
import 'package:teamlead/v2/modules/authentication/controller/user_controller.dart';
import 'package:teamlead/v2/modules/shared/marking/controller/marking_controller.dart';
import 'package:teamlead/v2/modules/student/proposal/model/proposal_model.dart';
import 'package:teamlead/v2/modules/shared/marking/model/marking_model.dart';
import 'package:teamlead/v2/modules/widgets/k_proposal_view.dart';

class Marking extends StatefulWidget {
  const Marking({
    super.key,
    required this.proposal,
    required this.doesBoard,
    required this.course,
    this.mark,
  });

  final ProposalModel proposal;
  final bool doesBoard;
  final String course;
  final MarkingModel? mark;

  @override
  State<Marking> createState() => _MarkingState();
}

class _MarkingState extends State<Marking> {
  final _formKey = GlobalKey<FormState>();
  RxList<TextEditingController> criteria1 = RxList([]);
  RxList<TextEditingController> criteria2 = RxList([]);
  RxList<TextEditingController> total = RxList([]);
  RxList<bool> doesAbsent = RxList([]);
  RxList<double> totalMarks = RxList([]);
  String factor1 = "";
  String factor2 = "";

  final UserController _userController = Get.find<UserController>();
  final MarkingController _markController = Get.find<MarkingController>();

  @override
  void initState() {
    factor1 = widget.doesBoard ? "Problem Definition, Design & Viva" : "Technical";
    factor2 = widget.doesBoard ? "Presentation, Testing & Report" : "Teamwork";
    for (int i = 0; i < widget.proposal.totalMembers!; i++) {
      doesAbsent.add(false);
      totalMarks.add(0);
      criteria1.add(TextEditingController(
          text: widget.mark == null ? "" : widget.mark?.marks[i].criteria1.toString()));
      criteria2.add(TextEditingController(
          text: widget.mark == null ? "" : widget.mark?.marks[i].criteria2.toString()));
      total.add(TextEditingController(
          text: widget.mark == null ? "" : widget.mark?.marks[i].total.toString()));
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
          IconButton(
              onPressed: () {
                Get.bottomSheet(
                    isScrollControlled: true, KProposalView(proposal: widget.proposal));
              },
              icon: const Icon(Icons.remove_red_eye_outlined))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Criteria - 1: $factor1"),
            const SizedBox(height: 5),
            Text("Criteria - 2: $factor2"),
            const SizedBox(height: 5),
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 20,
                                    child: Switch(
                                      value: doesAbsent[index],
                                      onChanged: (value) {
                                        criteria1[index].text = "0";
                                        criteria2[index].text = "0";
                                        totalMarks[index] = 0;
                                        total[index].text = "${totalMarks[index]}";
                                        doesAbsent[index] = value;
                                      },
                                    ),
                                  ),
                                  const Text("Marks as Absent"),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
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
                                      total[index].text = "${totalMarks[index]}";
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
                                      total[index].text = "${totalMarks[index]}";
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
                                const SizedBox(width: 10),
                                Flexible(
                                  child: TextFormField(
                                    controller: total[index],
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      helperText: "",
                                      hintText: "Total",
                                    ),
                                    readOnly: true,
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
                onPressed: () async {
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
                    MarkingModel markingModel = MarkingModel(
                      proposalTitle: widget.proposal.title ?? "",
                      proposalId: widget.proposal.id ?? 0,
                      evaluatedBy: _userController.teacher.value.initial!,
                      marks: marks,
                    );
                    debug(markingModel.toJson());
                    // TODO: Send it to controller for adding firebase
                    await _markController.addMark(
                      markingModel: markingModel,
                      doesBoard: widget.doesBoard,
                      courseCode: widget.course,
                    );
                    BotToast.showText(text: "Mark is added successfully");
                  }

                  // Get.back();
                },
                icon: const Icon(Icons.send),
                label: Text(
                  widget.mark == null ? "Evaluate" : "Update",
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
