import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teamlead/v2/modules/admin/generate_result/controller/generate_result_controller.dart';
import 'package:teamlead/v2/modules/student/proposal/controller/proposal_controller.dart';
import 'package:teamlead/v2/modules/widgets/k_option_button.dart';

class GenerateResult extends StatefulWidget {
  const GenerateResult({super.key});

  @override
  State<GenerateResult> createState() => _GenerateResultState();
}

class _GenerateResultState extends State<GenerateResult> {
  RxBool cse3300 = RxBool(false);
  RxBool cse4800 = RxBool(false);
  RxBool cse4801 = RxBool(false);
  RxInt totalTeams = RxInt(0);
  final _resultController = Get.find<GenerateResultController>();
  final _proposalController = Get.find<ProposalController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Result Generation"),
        centerTitle: true,
      ),
      body: Obx(
        () => Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OptionButton(
                  onPressed: () async {
                    cse3300.value = true;
                    cse4800.value = false;
                    cse4801.value = false;
                    _proposalController.fetchAllProposals(cse3300: cse3300.value);
                    await Future.delayed(const Duration(seconds: 3));
                    // _resultController.resultGeneration(proposals: _proposalController.allProposal);
                    totalTeams.value = _proposalController.allProposal.length;
                    _resultController.generateResult(
                      proposals: _proposalController.allProposal.value,
                      courseCode: "CSE-3300",
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
                    _proposalController.fetchAllProposals(cse4800: cse4800.value);
                    await Future.delayed(const Duration(seconds: 3));
                    totalTeams.value = _proposalController.allProposal.length;
                    // _resultController.resultGeneration(proposals: _proposalController.allProposal);
                    _resultController.generateResult(
                      proposals: _proposalController.allProposal.value,
                      courseCode: "CSE-4800",
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
                    _proposalController.fetchAllProposals(cse4801: cse4801.value);
                    await Future.delayed(const Duration(seconds: 3));
                    totalTeams.value = _proposalController.allProposal.length;
                    // _resultController.resultGeneration(proposals: _proposalController.allProposal);
                    _resultController.generateResult(
                      proposals: _proposalController.allProposal.value,
                      courseCode: "CSE-4801",
                    );
                  },
                  optionName: "CSE-4801",
                  doesFocus: cse4801.value,
                ),
              ],
            ),
            if (totalTeams.value != 0)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    LinearProgressIndicator(
                      value: _resultController.totalCompleted / totalTeams.value,
                      minHeight: 20,
                      backgroundColor: Colors.grey,
                    ),
                    Text(
                      "${_resultController.totalCompleted} / ${totalTeams.value}",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
            Flexible(
              child: ListView.builder(
                controller: ScrollController(keepScrollOffset: true),
                itemCount: _resultController.marks.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ExpansionTile(
                      title: Text(
                        _resultController.marks[index].title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Row(children: [
                        if (_resultController.marks[index].grades.first.boardMark ==
                                "Not Evaluated" &&
                            _resultController.marks[index].grades.first.supervisorMark ==
                                "Not Evaluated")
                          const Text("Not Evaluated by Board & Supervisor")
                        else if (_resultController.marks[index].evaluatedBy == "")
                          const Text("Not Evaluated by Board")
                        else if (_resultController.marks[index].grades.first.supervisorMark ==
                            "Not Evaluated")
                          const Text("Not Evaluated by Supervisor")
                        else
                          const Text("Evaluated")
                      ]),
                      children: _resultController.marks[index].grades
                          .map(
                            (grade) => Card(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Colors.green.shade100, Colors.teal.shade200],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: ListTile(
                                  title: Text("${grade.name}"),
                                  subtitle: Text("${grade.studentId}"),
                                  trailing: grade.total == '-'
                                      ? const Text("Not Evaluated")
                                      : Text("${grade.total} (${grade.grade})"),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                _resultController.getSheet();
              },
              child: const Text("Get Result Sheet"),
            ),
          ],
        ),
      ),
    );
  }
}
